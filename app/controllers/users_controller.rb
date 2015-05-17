class UsersController < ApplicationController

    def register
        @user = User.new
    end

    def create
        valid = true
        if params[:user][:password] != params[:user][:password_confirmation]
            valid = false
        end

        @user = User.new(user_params)
        if valid && @user.save
            flash[:info] = "Successfully registered!"
            redirect_to '/'
        else
            render 'register'
        end
    end

    private
    def user_params
        params.require(:user).permit(:username, :name, :email, :password)
    end
end
