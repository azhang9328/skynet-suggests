class ReposController < ApplicationController
<<<<<<< HEAD
    before_action :find_repo, only: [:show, :edit, :update, :destroy, :analysis]

    def analysis
        if !@repo.bundle_id
            @repo.bundle
        else 
            @repo.analysis_status
        end
    end
=======
    before_action :find_repo, only: [:edit, :update, :destroy]
>>>>>>> 3b1efb244dee1623dc25b249e5f3618415c05d2a

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

    private 

	def find_repo
		@repo = Repo.find(params[:id])
    end
    
     def repo_params
         params.require(:repo).permit(:nickname, :url, :analyzed, :user_id)
     end
end
