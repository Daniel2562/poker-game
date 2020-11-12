class UsersController < ViewController
  def confirm
    user = User.find_by_confirmation_token(params[:token])
    if user
      user.confirmed_at = DateTime.current
      user.confirmation_token = nil
      user.save
      render 'users/confirmed'
    else
      render 'users/invalid_confirmation'
    end
  end

  def confirm_reset
    user = User.find_by_reset_password_token(params[:token])
    if user
      if params[:password].present? && params[:password_confirmation].present?
        user.confirm_reset_password(params[:password], params[:password_confirmation])
        if user.reset_password_token == nil
          render 'users/reset_confirmed'
        else
          @url = users_confirm_reset_url(user.reset_password_token)
          render 'users/reset_form'
        end
      else
        @url = users_confirm_reset_url(user.reset_password_token)
        render 'users/reset_form'
      end
    else
      render 'users/invalid_reset_confirmation'
    end
  end
end
