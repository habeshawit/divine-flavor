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

end
