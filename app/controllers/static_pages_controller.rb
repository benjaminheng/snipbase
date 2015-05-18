class StaticPagesController < ApplicationController
    def index
        render :layout => 'landing'
    end
end
