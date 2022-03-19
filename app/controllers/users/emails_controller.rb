class Users::EmailsController < ApplicationController

  def new; end

  def create
    user = User.find_by(email: email)

    if user
      sign_in_and_redirect user
    else
      password = Devise.friendly_token[0, 20]
      user = User.create(email: email, password: password, password_confirmation: password)
      if user.new_record?
        user.send_confirmation_instructions
      else
        render :new
      end
    end
  end

  private

  def email
    params.require(:email)
  end
end
