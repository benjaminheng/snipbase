class ApplicationController < ActionController::Base
    # Prevent CSRF attacks by raising an exception.
    # For APIs, you may want to use :null_session instead.
    protect_from_forgery with: :exception
    include SessionsHelper

    # Redirects user to login page if not user is not logged in
    def ensure_authenticated
        if !logged_in?
            redirect_to login_path
            false
        end
    end
end
