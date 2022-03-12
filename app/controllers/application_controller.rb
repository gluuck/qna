class ApplicationController < ActionController::Base
  def current_user
    super
  rescue Devise::MissingWarden
    nil
  end
end
