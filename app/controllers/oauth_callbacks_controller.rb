class OauthCallbacksController < Devise::OmniauthCallbacksController
  def github
    auth_callback('Github')
  end

  def vkontakte
    auth_callback('Vkontakte')
  end

  private

  def auth_callback(kind)
    if request.env['omniauth.auth'].info[:email].nil?
      redirect_to new_users_email_path
    else
      @user = User.from_omniauth(request.env['omniauth.auth'])
      if @user&.confirmed?
        flash[:notice] = I18n.t 'devise.omniauth_callbacks.success', kind: "#{kind}"
        sign_in_and_redirect @user, event: :authentication
      else
        session["devise.#{kind}_data"] = request.env['omniauth.auth'].except('extra') # Removing extra as it can overflow some session stores
        redirect_to new_user_registration_url, alert: @user&.errors.full_messages.join("\n")
      end
    end
  end
end
