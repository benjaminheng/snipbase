class SessionsController < ApplicationController
    def new
    end

    def create  # login
        user = User.find_by(username: params[:session][:username])
        if user && user.authenticate(params[:session][:password])
            log_in user
            redirect_to root_path
        else
            flash.now[:error] = 'Invalid username or password.'
            render 'new'
        end
    end

    def destroy # logout
        log_out
        redirect_to root_path
    end
end
