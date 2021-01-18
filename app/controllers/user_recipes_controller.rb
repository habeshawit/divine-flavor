class UserRecipesController < ApplicationController

    def index
        @recipes = current_user.added_recipes
    end

    def create
        recipe = Recipe.where(id: params[:recipe])
        current_user.added_recipes << recipe
        # @fav_recipe = UserRecipe.create(user: current_user, recipe: recipe)
        # binding.pry
        @recipes = current_user.added_recipes
        redirect_to '/my_favorites'
    end

    def destroy


    end

    def destroy       
        @fav_recipe = current_user.added_recipes.find(params[:id])
        if current_user.added_recipes.delete(@fav_recipe)
            flash[:notice]= "Recipe successfully removed from favorites"
            redirect_to '/my_favorites'
          else
            flash[:alert] = @fav_recipe.errors.full_messages
            redirect_to '/my_favorites'
          end
    end 


end
