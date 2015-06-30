class StaticPagesController < ApplicationController
    before_filter :ensure_authenticated, only: ["groups", "group", "following"]
    def index
        if logged_in?
            @snippets = current_user.snippets.order_desc
            render 'index', locals: {active: 'default'}
        else
            render 'landing', layout: 'fullwidth'
        end
    end

    def groups
        unless current_user.active_groups.empty?
            @snippets = current_user.active_groups.first.snippets.order_desc
        end
        render 'index', locals: {active: 'groups'}
    end

    def group 
        group = Group.find(params[:id])
        unless current_user.active_groups.include?(group)
            redirect_to groups_path
        end
        @snippets = group.snippets.order_desc
        render 'index', locals: {active: 'groups', active_group: group.id}
    end

    def following
        @snippets = current_user.following_snippets.order_desc
        render 'index', locals: {active: 'following'}
    end
end
