class ApplicationController < ActionController::Base
    # Prevent CSRF attacks by raising an exception.
    # For APIs, you may want to use :null_session instead.
    protect_from_forgery with: :exception

    # helper methods available to view
    include SessionsHelper
    helper_method :notifications

    # Redirects user to login page if not user is not logged in
    def ensure_authenticated
        if !logged_in?
            redirect_to login_path
            false
        end
    end

    # Gets notifications for the current user
    def notifications
        @notifications = {group_invites: []}
        return @notifications unless logged_in?

        # Get pending group invites
        @notifications[:group_invites] = current_user.pending_groups
        return @notifications
    end

    def redirect_back_or_refresh_messages(msg, type)
        respond_to do |format|
            format.html { 
                flash[type] = msg
                redirect_to :back 
            }
            format.js { 
                flash.now[type] = msg
                render 'shared/refresh_message' 
            }
        end
    end
end
