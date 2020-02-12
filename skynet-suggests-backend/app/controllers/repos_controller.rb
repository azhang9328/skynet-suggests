class ReposController < ApplicationController
    before_action :find_repo, only: [:show, :edit, :update, :destroy, :analysis]

    def analysis
        if !@repo.bundle_id
            @repo.bundle
            render json: {message: "bundle created"}
        else 
            @repo.analysis_status
            render json: @repo
        end
    end

    def show
        render json: @repo
    end

    def new 
        @repo = repo.new
    end

    def create 
        @repo = Repo.create(repo_params)
        render json: @repo
    end

    def destroy 
        @repo.destroy
    end

    def index 
        @repos = Repo.all 
        render json: @repos
    end
    def update
        @repo.update(repo_params)
        render json: @repo
    end

    private 

	def find_repo
		@repo = Repo.find(params[:id])
    end
    def repo_params
        params.require(:repo).permit(:nickname, :url, :analyzed, :user_id)
    end
end
