class ReposController < ApplicationController
    before_action :find_repo, only: [:show, :edit, :update, :destroy]

    def show
        render json: @repo
    end

    def new 
        @repo = repo.new
    end

    def create 
        @repo = Repo.create(name: params[:name])
    end

    def destroy 
        @repo.destroy
    end

    def index 
        @repos = Repo.all 
        render json: @repos
    end

    private 

	def find_repo
		@repo = Repo.find(params[:id])
	end
end
