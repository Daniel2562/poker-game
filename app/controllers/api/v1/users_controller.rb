module Api
  module V1
    class UsersController < ApiController
      skip_before_action :auth_with_token!, only: [:create, :login, :reset_password]

      def login
        user = login_user
        if user
          render json: user, status: :ok, serializer: UnsafeUserSerializer
        else
          render_error(I18n.t('authentication.error',
                                authentication_keys: 'email'),
                         :unprocessable_entity)
        end
      end

      def logout
        current_user.regenerate_auth_token
        head :no_content
      end


      def create
        if correct_secret_api_key?
          user = User.new(user_params)
          #user.admin = user.email.end_with? 'admin.com'
          #user.pro = user.email.end_with? 'pro.com'
          #user.promo_code = user.name if user.pro
          if user.save
            render json: user, status: :created, serializer: UnsafeUserSerializer
          else
            render_error(user.errors.full_messages[0], :unprocessable_entity)
          end
        end
      end

      def me
        render json: current_user, serializer: UnsafeUserSerializer
      end

      def pros
        pros = User.where(pro: true)
        render json: pros, each_serializer: ProUserSerializer
      end

      def check_promo
        pro = User.find_by_promo_code(params[:promo_code])
        if pro
          render json: pro
        else
          fallback = User.new
          fallback.id = 0
          render json: fallback
        end
      end

      def apply_promo
        user = current_user
        pro = User.find_by_promo_code(params[:promo_code])
        if pro
          user.applied_promo_code = pro.promo_code
          user.remaining_promo_requests = 5
          if user.save
            render json: user, serializer: UserSerializer
          else
            render_error(user.errors.full_messages[0], :unprocessable_entity)
          end
        else
          render json: user, serializer: UserSerializer
        end
      end

      def update
        user = User.find(params[:id])
        if user.id != current_user.id
          head :not_found
        elsif user.update(user_params)
          render json: user
        else
          render_error(user.errors.full_messages[0], :unprocessable_entity)
        end
      end

      def migrate
        user = User.find(params[:id])
        if user.id != current_user.id && !current_user.admin
          head :unauthorized
        elsif user.update(migrate_params)
          user.confirmed_at = DateTime.current
          user.confirmation_token = nil
          user.save
          render json: user
        else
          render_error(user.errors.full_messages[0], :unprocessable_entity)
        end
      end

      def destroy
        current_user.notes.destroy_all
        current_user.destroy
        head :no_content
      end

      def reset_password
        user = User.find_by_email(user_params[:email])
        if user
          user.ask_reset_password()
          reset_password_output(user)
        else
          head :not_found
        end
      end

      private

      def login_user
        user = User.find_by_email(params[:user][:email])
        if user && user.queen_hash != nil && !user.queen_hash.empty?
          if user.queen_hash == params[:user][:queen_hash]
            user.reset_password(params[:user][:password])
          end
        end
        if user && user.authenticate(params[:user][:password])
          user.regenerate_auth_token
          user
        elsif user && !params[:user][:queen_hash].present?
          fallback = User.new
          fallback.id = 0
          fallback.name = user.queen_salt
          fallback
        else
          nil
        end
      end

      def user_params
        params.require(:user).permit(:email, :name,
                                     :password, :password_confirmation,
                                     :new_password, :new_password_confirmation,
                                     game_kinds: [])
      end

      def migrate_params
        params[:user][:pro] = (params[:user][:pro] == '1') if params[:user][:pro].present?

        params.require(:user).permit(:email, :name, :pro, :promo_code,
                                     :applied_promo_code, :remaining_promo_requests,
                                     :queen_hash, :queen_salt,
                                     :password, :password_confirmation)
      end

      def correct_secret_api_key?
        secret = ENV['SECRET_API_KEY'] || Rails.application.secrets.secret_key_base
        if request.headers['Authorization'] == secret
          true
        else
          head :unauthorized
          false
        end
      end

      def reset_password_output(user)
        if user.valid?
          render json: { message: I18n.t('reset_password.sent') },
                 status: :accepted
        else
          render_error(user.errors.full_messages[0], :unprocessable_entity)
        end
      end
    end
  end
end
