module Api
  module V1
    class CommentsController < ApiController

      def create
        request = Request.find(params[:request_id])
        if request.pro_id != current_user.id
          head :unauthorized
        else
          comment = request.comments.new(comment_params)

          if comment.save
            render json: comment, status: :created
          else
            render_error(comment.errors.full_messages[0], :unprocessable_entity)
          end
        end
      end

      def destroy
        comment = Comment.find(params[:id])
        if comment.request.pro_id != current_user.id
          head :unauthorized
        else
          comment.destroy
          head :no_content
        end
      end

      def update
        comment = Comment.find(params[:id])
        if comment.request.pro_id != current_user.id
          head :unauthorized
        else
          if comment.update(comment_params)
            render json: comment
          else
            render_error(comment.errors.full_messages[0], :unprocessable_entity)
          end
        end
      end


      private

      def comment_params
        params.require(:comment).permit(:step, :comment)
      end
    end
  end
end