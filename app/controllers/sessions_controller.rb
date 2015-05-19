class SessionsController < ApplicationController
    def new
        render 'login'
    end

    def create  # login
        user = User.find_by(username: params[:session][:username])
        if user && user.authenticate(params[:session][:password])
            log_in user
            redirect_to '/'
        else
            flash.now[:error] = 'Invalid username or password.'
            render 'login'
        end
    end

    def destroy # logout
        log_out
        redirect_to '/'
    end
end
