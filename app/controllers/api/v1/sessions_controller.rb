module Api
  module V1
    class SessionsController < ApiController

      def index
        render json: current_user.sessions.all
      end

      def show
        render json: current_user.sessions.find(params[:id])
      end

      def create
        session = current_user.sessions.new(session_params)
        if session.save
        render json: session, status: :created
        else
        render_error(session.errors.full_messages[0], :unprocessable_entity)
        end
      end

      def update
        session = current_user.sessions.find(params[:id])
        if session.update(session_params)
        render json: session
        else
        render_error(session.errors.full_messages[0], :unprocessable_entity)
        end
      end

      def destroy
        session = current_user.sessions.find(params[:id])
        session.destroy
        head :no_content
      end

      def migrate_timestamps
        return head :unauthorized unless current_user.admin
        session = Session.find(params[:id])
        return head :not_found unless session
        session.created_at = timestamp_params[:created_at]
        if session.save
          render json: session
        else
          render_error(session.errors.full_messages[0], :unprocessable_entity)
        end
      end

      private

      def timestamp_params
        params.require(:session).permit(:created_at)
      end

      def session_params
        params.require(:session).permit(:title, :game, :kind, :level_time, :big_blind, :small_blind, :ante)
      end
    end
  end
end
