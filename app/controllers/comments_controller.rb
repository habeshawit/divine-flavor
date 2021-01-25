class CommentsController < ApplicationController
    before_action :find_recipe, except: [:index, :user_comments, :all_comments]
    before_action :authenticate_user!
    before_action :find_comment, only: [:destroy]
  
    def new
        @comment = Comment.new
    end

    def create
      @comment = @recipe.comments.build(comment_params)
      @comment.user = current_user
      if @comment.save
        redirect_to @recipe
      else
        flash[:alert] = @comment.errors.full_messages[0]
        redirect_to recipe_path(@recipe)
      end
    end
  
    def index
      if params[:recipe_id] && @recipe = Recipe.find_by(id: params[:recipe_id])
        @comments = @recipe.comments
        render :index
      else
        flash[:alert] = "Unable to find recipe" if params[:recipe_id]
        @comments = Comment.all
      end
    end

  
    def user_comments
      if params[:user_id]
        @user = User.find_by_id(params[:user_id])  
        @comments = @user.comments.all
      end
    end
  
    def destroy
      if @comment.destroy
          flash[:notice]= "Comment successfully deleted"
        else
          flash[:alert] = @comment.errors.full_messages
        end
      redirect_to @recipe
    end 

    private
  
    def comment_params
      params.require(:comment).permit(:content, :recipe_id)
    end
  
    def find_recipe
      @recipe = Recipe.find(params[:recipe_id])
    end

    def find_comment
      @comment = Comment.find(params[:id])
    end
end
