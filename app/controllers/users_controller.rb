class UsersController < ApplicationController
    before_filter :ensure_authenticated, only: ["edit", "update"]

    def new 
        @user = User.new
    end

    def create
        @user = User.new(user_params)
        if @user.save
            flash[:success] = "Successfully registered!"
            log_in @user
            redirect_to root_path
        else
            render 'new'
        end
    end

    def show
        @user = User.find_by(username: params[:username]);
        conditions = {user: @user}
        if (current_user != @user)  # only show public snippets
            conditions[:private] = false;
        end
        @snippets = Snippet.where(conditions).order(:created_at).reverse_order;
        render :layout => 'fullwidth'
    end

    def edit
        @user = User.find(current_user.id);
    end

    def update
        @user = User.find(current_user.id)
        if params[:update_profile_btn]
            update_profile
        elsif params[:update_password_btn]
            update_password
        end
        return
    end

    private
    def update_profile
        @user = User.find(current_user.id)
        # Check that password_verification exists and is correct
        if !correct_password?(@user, params[:user], :password_verification)
            respond_to_update and return
        end

        # Update user
        if @user.update_attributes(update_profile_params)
            flash.now[:success] = "Successfully updated profile!"
        end
        respond_to_update and return
    end

    private
    def update_password
        @user = User.find(current_user.id)
        if !correct_password?(@user, params[:user], :existing_password)
            respond_to_update and return
        elsif params[:user][:password].blank?
            @user.errors.add :password, "is empty."
            respond_to_update and return
        end

        if @user.update_attributes(update_password_params)
            flash.now[:success] = "Successfully changed password!"
        end
        respond_to_update
    end

    private
    def respond_to_update
        respond_to do |format|
            format.html { render 'edit' }
            format.js
        end
    end

    private
    def destroy
    end

    private
    def correct_password?(user, params, password_param)
        if params[password_param].blank?
            @user.errors.add password_param, "is empty."
            return false
        elsif !@user.authenticate(params[password_param])
            @user.errors.add password_param, "is wrong."
            return false
        end
        return true
    end

    private
    def user_params
        params.require(:user).permit(:username, :name, :email, :password, :password_confirmation)
    end

    private
    def update_profile_params 
        params.require(:user).permit(:name, :email)
    end

    private
    def update_password_params 
        params.require(:user).permit(:password, :password_confirmation)
    end
end
