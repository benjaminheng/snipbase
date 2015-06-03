class GroupsController < ApplicationController
    def show 
        @user = User.find_by(username: params[:username]);
        @group = Group.new
    end

    def create
        @user = User.find_by(username: params[:username]);
        @group = Group.new(group_params)
        if @group.save
            flash[:success] = "Successfully created group!"
            # redirect so we have a completely new request
            redirect_to show_user_groups_path(@user.username)
        else
            flash[:danger] = "Error creating group."
            render 'show'
        end
    end

    private
    def group_params
        params.require(:group).permit(:name)
    end
end
