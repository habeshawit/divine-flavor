class RecipesController < ApplicationController
    before_action :find_recipe, only: [:show, :edit, :update, :destroy]
    before_action :authenticate_user!

    def new 
        @recipe = Recipe.new
    end

    def create
        @recipe = current_user.recipes.build(recipe_params)
       
        if @recipe.save
            flash[:notice]= "Recipe successfully saved"
            redirect_to recipe_path(@recipe)
        else
            flash.now[:alert] = @recipe.errors.full_messages[0]          
            render 'new'       
        end  
    end

    def edit        
    end

    def update      
        if @recipe.update(recipe_params)
            flash[:notice]= "Recipe successfully updated"
            redirect_to recipe_path(@recipe)
        else
            flash[:alert] = @recipe.errors.full_messages[0]
            redirect_to edit_recipe_path(@recipe)
        end
    end

    def show    
        if @recipe
            @comment = Comment.new
            @comments = @recipe.comments.order("created_at ASC")
        end        
    end
    
    def index
        @recipes = Recipe.all
        if params[:recipe]
            @recipes = @recipes.search(params[:recipe])
            if !@recipes
                flash[:alert] = "No matching recipes found"
                redirect_back(fallback_location: root_path)
            end
        end
    end

    def add_recipe(params)
        @recipe = current_user.recipes.build(params)
        if @recipe.save
            flash[:notice]= "Recipe successfully saved"
            redirect_back(fallback_location: root_path)
        else
            flash.now[:alert] = @recipe.errors.full_messages[0]          
            render 'new'       
        end
    end

    def destroy
        if @recipe.destroy
          flash[:notice]= "Recipe successfully deleted"
          redirect_back(fallback_location: root_path)
        else
          flash[:alert] = @recipe.errors.full_messages
          render 'show'
        end
    end 

    def delete_image_attachment
        @image = ActiveStorage::Blob.find_signed(params[:id])
        @image.attachments.first.purge
        redirect_back(fallback_location: recipes_path)
    end

    private
 
    def recipe_params
        params.require(:recipe).permit(:name, :description, :prep_time, :cook_time, :category_name, :user_id, images: [], ingredients_attributes:[:id, :name, :quantity, :_destroy], steps_attributes:[:id, :instructions, :_destroy])
    end

    def find_recipe
        @recipe = Recipe.find(params[:id])
    end
end
