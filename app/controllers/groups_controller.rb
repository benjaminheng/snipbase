class GroupsController < ApplicationController
    def show 
        @user = User.find_by(username: params[:username]);
        @group = Group.new
    end

    def create
        @user = User.find_by(username: params[:username]);
        @group = Group.new(group_params)
        @group.owner = @user

        if @group.save
            @group.add_user(@user)   # Add creator to group
            # invite users if any are specified
            group_invitees_params.split(',').each do |username|
                username.strip!
                invitee = User.find_by(username: username)
                if invitee
                    @user.invite_to_group(@group, invitee)
                end
            end

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

    private
    def group_invitees_params
        params.require(:invitees)
    end
end
