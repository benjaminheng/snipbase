module SessionsHelper
    def log_in(user)
        session[:user_id] = user.id
    end

    def current_user
        @current_user ||= User.find_by(id: session[:user_id])
    end

    def log_out
        session[:user_id] = nil
        @current_user = nil
    end

    # true if logged in
    def logged_in?
        return !current_user.nil?
    end
end
