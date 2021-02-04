class CategoriesController < ApplicationController

    def new
        @category = Category.new
    end

    def create
        @category = Category.create(category_params)
        
        if @category.valid? 
            flash[:notice] = "Category successfully created"
            redirect_to @category 
        else
            flash[:alert] = "Error creating category"
            redirect_to 'new'
        end
    end

    def show
        @category = Category.find(params[:id])
    end

    def category_params
        params.require(:category).permit(:name) 
    end
end
