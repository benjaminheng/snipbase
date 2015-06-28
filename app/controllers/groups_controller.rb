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
                if invitee && !@group.users.include?(invitee)
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
        @snippets = @group.snippets.order_desc
        # ensure user is authorized to view group
        redirect_to show_user_groups_path(username: current_user.username) unless current_user.active_groups.include?(@group)
    end

    def show_members
        @group = Group.find(params[:id])
        # ensure user is authorized to view group members
        redirect_to root_path unless current_user.active_groups.include?(@group)
    end

    def invite_members
        @user = current_user
        @group = Group.find(params[:id])
        return unless current_user == @group.owner
        return if params['invitees'].empty?
        params['invitees'].split(',').each do |username|
            username.strip!
            invitee = User.find_by(username: username)
            if invitee && !@group.users.include?(invitee)
                @user.invite_to_group(@group, invitee)
            end
        end

        flash[:success] = "Successfully invited users!"
        respond_to_invite_members
    end

    def accept_invite
        group = Group.find(params[:id])
        return unless current_user.pending_groups.include?(group)
        current_user.accept_group_invite(group)
        flash[:success] = "Joined group \"#{group.name}\""
        redirect_back_or_refresh_messages
    end

    def decline_invite
        group = Group.find(params[:id])
        return unless current_user.pending_groups.include?(group)
        current_user.decline_group_invite(group)
        flash[:info] = "Declined group invite for \"#{group.name}\""
        redirect_back_or_refresh_messages
    end

    def remove_member
        group = Group.find(params[:id])
        user = User.find(params[:user])
        if group.owner == current_user && user.groups.include?(group)
            GroupMember.find_by(group_id: group.id, user_id: user.id).destroy
            flash[:info] = "Removed user \"#{user.username}\" from \"#{group.name}\""
        end
        redirect_to :back
    end

    def leave_group
        group = Group.find(params[:id])
        redirect_to :back unless current_user.active_groups.include?(group)
        current_user.leave_group(group)
        flash[:info] = "Left the group \"#{group.name}\""
        redirect_to show_user_groups_path(username: current_user.username)
    end

    def disband_group
        group = Group.find(params[:id])
        redirect_to :back unless group.owner == current_user
        group.destroy
        flash[:info] = "Disbanded the group \"#{group.name}\""
        redirect_to show_user_groups_path(username: current_user.username)
    end

    # If javascript enabled, refresh messages, else redirect user to same page
    def redirect_back_or_refresh_messages
        respond_to do |format|
            format.html { redirect_to :back }
            format.js { render 'shared/refresh_message' }
        end
    end

    private
    def respond_to_invite_members
        respond_to do |format|
            format.html { redirect_to :back }
            format.js { render 'refresh_group_profile' }
        end
    end

    private
    def group_params
        params.require(:group).permit(:name)
    end
end
