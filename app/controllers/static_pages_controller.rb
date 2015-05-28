class StaticPagesController < ApplicationController
    def index
        render :layout => 'fullwidth'
    end
end
