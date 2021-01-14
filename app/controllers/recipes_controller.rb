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
            render 'new'       
        end  
    end

    def edit
        @recipe = Recipe.all.find_by(id: params[:id])
    end

    def update
        @recipe = Recipe.all.find_by(id: params[:id])
        @recipe.update(recipe_params)
        redirect_to recipe_path(@recipe)
    end

    def show
        @recipe = Recipe.all.find_by(id: params[:id])
        if @recipe
            @comment = Comment.new

            @comments = @recipe.comments.order("created_at DESC")
        
            # binding.pry
        end
        
    end
    
    def search_my_recipes
        @recipes = current_user.recipes.all.select { |recipe|  recipe.name.downcase.include?(params[:recipe].downcase) || recipe.ingredients.downcase.include?(params[:recipe].downcase)}         # @recipes = current_user.recipes.where('lower(name) = ?' LIKE params[:recipe].downcase)
        # binding.pry
        if @recipes.empty?
            
            flash[:alert] = "No matching recipes found"
            redirect_to '/my_recipes'
        else
            render :'recipes/search'
        end
    end

    def search_all_recipes
        @recipes = Recipe.all.select { |recipe|  recipe.name.downcase.include?(params[:recipe].downcase) || recipe.ingredients.downcase.include?(params[:recipe].downcase)} 
        if @recipes.empty?
            flash[:alert] = "No matching recipes found"
            redirect_to '/recipes'
        else
            render :'recipes/search'
        end
    end

    def destroy
        if @recipe.destroy
            flash[:notice]= "Recipe successfully deleted"
            redirect_to root_path
          else
            flash[:alert] = @recipe.errors.full_messages
            render 'show'
          end
        # redirect_to '/my_recipes'
    end 

    private
 
    def recipe_params
      params.require(:recipe).permit(:name, :ingredients, :instructions, :user_id)
    end

    def find_recipe
        @recipe = Recipe.find(params[:id])
      end
end
