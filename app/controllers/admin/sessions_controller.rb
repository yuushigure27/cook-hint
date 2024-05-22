# frozen_string_literal: true

class Admin::SessionsController < Devise::SessionsController

  protected


  def after_sign_in_path_for(resource)
    admin_posts_path
   end

   def after_sign_out_path_for(resource)
    new_admin_session_path
   end

  def configure_sign_in_params
    devise_parameter_sanitizer.permit(:sign_in) { |u| u.permit(:email, :encrypted_password) }
  end
end
