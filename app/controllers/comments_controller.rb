class CommentsController < ApplicationController
    before_action :find_recipe, except: [:user_comments]
    before_action :authenticate_user!
  
    def new
        @comment = Comment.new
    end

    def create
      @comment = @recipe.comments.build(comment_params)
      @comment.user = current_user
    #   binding.pry
      if @comment.save
        redirect_to @recipe
      else
        flash[:alert] = @comment.errors.full_messages
        redirect_to recipe_path(@recipe)
      end
    end
  
    def index
      if params[:recipe_id]
        @recipe = Recipe.find_by(id: params[:recipe_id])
        @comments = @recipe.comments
        render :index
      end
    end
  
    def user_comments
      if params[:user_id]
        @user = User.find_by_id(params[:user_id])  
        @comments = @user.comments.all
      end
    end
  
    private
  
    def comment_params
      params.require(:comment).permit(:content, :recipe_id)
    end
  
    def find_recipe
      @recipe = Recipe.find(params[:recipe_id])
    end
end
