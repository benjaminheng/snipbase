class GroupsController < ApplicationController
    #before_filter :ensure_authenticated, only: ["show_all", "create", "show", "show_members", "accept_invite", "decline_invite"]
    before_filter :ensure_authenticated

    # show all groups
    def show_all
        @user = User.find_by(username: params[:username]);
        @group = Group.new
    end

    # create new group
    def create
        @user = User.find_by(username: params[:username]);
        @group = Group.new(group_params)
        @group.owner = @user

        if @group.save
            @group.add_user(@user)   # Add creator to group
            # invite users if any are specified
            params['invitees'].split(',').each do |username|
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
            render 'show_all'
        end
    end

    # show single group
    def show
        @group = Group.find(params[:id])
        # ensure user is authorized to view group
        redirect_to root_path unless current_user.active_groups.include?(@group)
    end

    def show_members
        @group = Group.find(params[:id])
        # ensure user is authorized to view group members
        redirect_to root_path unless current_user.active_groups.include?(@group)
    end

    def accept_invite
        group = Group.find(params[:id])
        return unless current_user.pending_groups.include?(group)
        current_user.accept_group_invite(group)
        flash[:success] = "Joined group \"#{group.name}\""
        respond_to_invite
    end

    def decline_invite
        group = Group.find(params[:id])
        return unless current_user.pending_groups.include?(group)
        current_user.decline_group_invite(group)
        flash[:info] = "Declined group invite for \"#{group.name}\""
        respond_to_invite
    end

    def respond_to_invite
        respond_to do |format|
            format.html { redirect_to :back }
            format.js { render 'shared/refresh_message' }
        end
    end

    private
    def group_params
        params.require(:group).permit(:name)
    end
end
