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

  def my_friends
    @friends = current_user.friends
  end

  def show
    @user = User.find(params[:id])
  end

  def edit
  end

  def update
        if current_user.update(user_params)
            flash[:notice]= "Profile successfully updated"
            redirect_to user_path(current_user)
        else
            flash[:alert] = current_user.errors.full_messages[0]
            redirect_to user_path(current_user)
        end
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
  
  def user_params
    params.require(:user).permit(:bio, :avatar)
    end
end
