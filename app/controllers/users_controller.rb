class UsersController < ApplicationController

    def register
        @user = User.new
    end

    def create
        @user = User.new(user_params)
        if @user.save
            flash[:info] = "Successfully registered!"
            redirect_to root_path
        else
            render 'register'
        end
    end

    private
    def user_params
        params.require(:user).permit(:username, :name, :email, :password, :password_confirmation)
    end
end
