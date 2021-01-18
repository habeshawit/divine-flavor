class RecipesController < ApplicationController
    before_action :find_recipe, only: [:show, :edit, :update, :destroy]


    def new 
        @recipe = Recipe.new
    end

    def create
        @recipe = current_user.recipes.build(recipe_params)
       
        # binding.pry
        if @recipe.save
            # binding.pry
            flash[:notice]= "Recipe successfully saved"
            redirect_to '/my_recipes'
        else
            flash.now[:alert] = @recipe.errors.full_messages[0]          
            render 'new'       
        end  
    end

    def edit
        @recipe = Recipe.all.find_by(id: params[:id])
    end

    def update
        @recipe = Recipe.all.find_by(id: params[:id])
        if @recipe.update(recipe_params)
            flash[:notice]= "Recipe successfully updated"
            redirect_to recipe_path(@recipe)
        else
            flash[:alert] = @recipe.errors.full_messages[0]
            redirect_to edit_recipe_path(@recipe)
        end
    end

    def show
        @recipe = Recipe.all.find_by(id: params[:id])
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
            #   @recipes = []
              flash[:alert] = "No matching recipes found"
              redirect_to '/recipes'
            end
        end
    end

    def add_recipe(params)
        @recipe = current_user.recipes.build(params)
       
        # binding.pry
        if @recipe.save
            # binding.pry
            flash[:notice]= "Recipe successfully saved"
            redirect_to '/my_recipes'
        else
            flash.now[:alert] = @recipe.errors.full_messages[0]          
            render 'new'       
        end

    end
    


    def destroy
        # binding.pry
        if @recipe.destroy
            flash[:notice]= "Recipe successfully deleted"
            redirect_to '/my_recipes'
          else
            flash[:alert] = @recipe.errors.full_messages
            render 'show'
          end
        # redirect_to '/my_recipes'
    end 

    def delete_image_attachment
        @image = ActiveStorage::Blob.find_signed(params[:id])
        @image.attachments.first.purge
        redirect_back(fallback_location: recipes_path)
      end

    private
 
    def recipe_params
      params.require(:recipe).permit(:name, :description, :user_id, images: [], ingredients_attributes:[:id, :name, :quantity, :_destroy], steps_attributes:[:id, :instructions, :_destroy])
    end

    def find_recipe
        @recipe = Recipe.find(params[:id])
      end
end
