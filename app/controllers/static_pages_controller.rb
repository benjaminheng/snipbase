class StaticPagesController < ApplicationController
    def index
        if logged_in?
            @snippets = Snippet.permission(current_user).order_desc
            render 'index'
        else
            render 'landing', :layout => 'fullwidth'
        end
    end
end
