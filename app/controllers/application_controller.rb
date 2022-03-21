class ApplicationController < ActionController::Base
  include Pundit::Authorization
  
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  def current_user
    super
  rescue Devise::MissingWarden
    nil
  end  

  private

  def user_not_authorized(exception)
    respond_to do |format|
      format.html do
        flash[:alert] = exception.message
        redirect_to root_path        
      end
      policy_name = exception.policy.class.to_s.underscore
      format.turbo_stream { render turbo_stream: turbo_stream.update('alert', partial: 'shared/pundit_errors', locals:{resource: exception, policy_name: policy_name}) }
    end
  end
end
