class UserRecipesController < ApplicationController

    def index
        @recipes = current_user.added_recipes
    end

    def create
        recipe = Recipe.where(id: params[:recipe])
        current_user.added_recipes << recipe
        @recipes = current_user.added_recipes
        flash[:notice]= "Recipe successfully added to favorites"
        redirect_back(fallback_location: root_path)
    end

    def destroy       
        @fav_recipe = current_user.added_recipes.find(params[:id])
        if current_user.added_recipes.delete(@fav_recipe)
            flash[:notice]= "Recipe successfully removed from favorites"
            redirect_back(fallback_location: root_path)
        else
            flash[:alert] = @fav_recipe.errors.full_messages
            redirect_to '/recipes'
        end
    end 

end
