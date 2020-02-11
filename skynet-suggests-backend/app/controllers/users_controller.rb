class UsersController < ApplicationController
    before_action :find_user, only: [:show, :edit, :update, :destroy]

    def show
        render json: @user
    end

    def new 
        @user = User.new
    end

    def create 
        @user = User.create(name: params[:name])
    end

    def destroy 
        @user.destroy
    end

    def index 
        @users = User.all 
        render json: @users
    end

    private 

	def find_user
		@user = User.find(params[:id])
	end
end
