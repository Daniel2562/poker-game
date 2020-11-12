module Api
  module V1
    class HandsController < ApiController

      def index
        session = Session.find(params[:session_id])
        if session.user_id != current_user.id
          head :unauthorized
        else
          render json: session.hands.all
        end
      end

      def show
        hand = Hand.find(params[:id])
        if hand.user_id != current_user.id
          head :unauthorized
        elsif params[:session_id].present? && hand.session_id != params[:session_id]
          head :not_found
        else
          render json: hand
        end
      end

      def create
        session = Session.find(params[:session_id])
        if session.blank?
          head :not_found
        elsif session.user_id != current_user.id
          head :unauthorized
        else
          hand = session.hands.new(hand_params)
          hand.user_id = current_user.id
          if hand.save
            render json: hand, status: :created#, serializer: OptimizedHandSerializer
          else
            render_error(hand.errors.full_messages[0], :unprocessable_entity)
          end
        end
      end

      def update
        hand = Hand.find(params[:id])
        if !hand
          head :not_found
        elsif hand.user_id != current_user.id
          head :unauthorized
        elsif hand.update(hand_params)
          render json: hand
        else
          render_error(hand.errors.full_messages[0], :unprocessable_entity)
        end
      end

      def migrate
        hand = Hand.find(params[:id])
        if !hand
          head :not_found
        elsif hand.user_id != current_user.id && !current_user.admin
          head :unauthorized
        else
          hand.steps.destroy_all
          hand.villains.destroy_all
          if hand.update(hand_params)
            render json: hand
          else
            render_error(hand.errors.full_messages[0], :unprocessable_entity)
          end
        end
      end

      def migrate_timestamps
        return head :unauthorized unless current_user.admin
        hand = Hand.find(params[:id])
        return head :not_found unless hand
        hand.created_at = timestamp_params[:created_at]
        if hand.save
          render json: hand
        else
          render_error(hand.errors.full_messages[0], :unprocessable_entity)
        end
      end

      def destroy
        hand = Hand.find(params[:id])
        hand.destroy
        head :no_content
      end

      private

      def timestamp_params
        params.require(:hand).permit(:created_at)
      end

      def hand_params

        if params[:hand][:villains]
          params[:hand][:villains_attributes] = params[:hand][:villains]
          params[:hand].delete(:villains)
        end

        if params[:hand][:steps]
          params[:hand][:steps_attributes] = params[:hand][:steps]
          params[:hand].delete(:steps)
        end

        params.require(:hand).permit(:level, :level_time, :hand_limit,
                                     :big_blind, :small_blind, :ante,
                                     :players_dealt, :position,
                                     :start_pot, :start_stack, :final_stack, :state,
                                     hole_cards: [], table_cards: [],
                                     villains_attributes: [:profile, :position, :start_stack],
                                     steps_attributes: [:actor, :action, :amount, :stack, :title, :comment])

      end
    end
  end
end
