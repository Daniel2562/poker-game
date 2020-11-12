module Api
  module V1
    class RequestsController < ApiController

      def index
        hand = Hand.find(params[:hand_id])
        if hand.user_id != current_user.id
          head :unauthorized
        else
          render_many hand.requests.all
        end
      end

      def index_created
        render_many current_user.created_requests.all
      end

      def index_incoming
        render_many current_user.incoming_requests.all
      end

      def index_created_by
        if current_user.id == params[:id] || current_user.admin
          user = User.find(params[:id])
          if user
            render_many user.created_requests.all
          else
            head :not_found
          end
        else
          head :unauthorized
        end
      end

      def index_incoming_to
        if current_user.id == params[:id] || current_user.admin
          user = User.find(params[:id])
          if user
            render_many user.incoming_requests.all
          else
            head :not_found
          end
        else
          head :unauthorized
        end
      end

      def show
        request = Request.find(params[:id])
        if request.user_id != current_user.id && request.pro_id != current_user.id && !current_user.admin
          head :unauthorized
        elsif params[:hand_id].present? && request.hand_id != params[:hand_id]
          head :not_found
        else
          render_one request
        end
      end

      def create
        user = current_user

        hand = Hand.find(params[:hand_id])
        if hand.user_id != user.id
          return head :unauthorized
        end

        pro = User.find(params[:request][:pro_id])
        return head :not_found if !pro.present?

        if params[:payment] == 'Promo'
          if (pro.promo_code != params[:promo_code] || user.remaining_promo_requests <= 0)
            return head :unauthorized
          else
            user.remaining_promo_requests = user.remaining_promo_requests - 1
          end
        end

        user.save

        request = hand.requests.new(create_request_params)
        request.user_id = user.id
        request.viewed = false
        request.resolved = false
        request.accepted = false
        if request.save
          render_one request
        else
          render_error(request.errors.full_messages[0], :unprocessable_entity)
        end
      end

      def destroy
        request = Request.find(params[:id])
        if request.user_id != current_user.id
          head :unauthorized
        else
          request.destroy
          head :no_content
        end
      end

      def view
        request = Request.find(params[:id])
        if request.pro_id != current_user.id && !current_user.admin
          head :unauthorized
        else
          if request.update viewed:true
            render_one request
          else
            render_error(request.errors.full_messages[0], :unprocessable_entity)
          end
        end
      end

      def accept
        request = Request.find(params[:id])
        if request.user_id != current_user.id
          head :unauthorized
        else
          if request.update accepted:true
            render_one request
          else
            render_error(request.errors.full_messages[0], :unprocessable_entity)
          end
        end
      end

      def resolve
        request = Request.find(params[:id])
        if request.pro_id != current_user.id && !current_user.admin
          head :unauthorized
        else
          if request.update(resolve_request_params)
            render_one request
          else
            render_error(request.errors.full_messages[0], :unprocessable_entity)
          end
        end
      end

      def migrate_timestamps
        return head :unauthorized unless current_user.admin
        request = Request.find(params[:id])
        return head :not_found unless request
        request.created_at = timestamp_params[:created_at]
        if request.save
          render json: request
        else
          render_error(request.errors.full_messages[0], :unprocessable_entity)
        end
      end

      private

      def timestamp_params
        params.require(:request).permit(:created_at)
      end


      def render_many requests
        render json: requests, include:
            ['pro', 'user', 'hand', 'hand.session',
             'hand.villains']
      end

      def render_one request
        render json: request, include:
            ['pro', 'user', 'hand', 'hand.session', 'hand.hole_cards',
             'hand.table_cards', 'hand.villains', 'hand.steps', 'comments']
      end

      def create_request_params
        params.require(:request).permit(:pro_id, :payment)
      end

      def resolve_request_params

        if params[:request][:comments].present?
          params[:request][:comments_attributes] = params[:request][:comments]
          params[:request].delete(:comments)
        end

        params[:request][:viewed] = true
        params[:request][:resolved] = true
        params[:request][:accepted] = false

        params.require(:request).permit(:summary, :viewed, :resolved, :accepted,
                                        comments_attributes: [:id, :step, :comment])
      end
    end
  end
end