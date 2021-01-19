class UsersController < ApplicationController
  before_action :authenticate_user!


  def my_recipes
    @recipes = current_user.recipes.all
    if params[:recipe]
      @recipes = @recipes.search(params[:recipe])
      if !@recipes
        flash[:alert] = "No matching recipes found"
        redirect_to '/my_recipes'
      end
  end
  end

  def show
    @user = User.find(params[:id])
    # binding.pry 
  end

  def destroy
    if current_user.destroy
      flash[:notice]= "Account successfully deleted"
      redirect_to root_path
    else
      flash[:alert] = current_user.errors.full_messages
      render 'show'
    end
  end

end
