class FriendshipsController < ApplicationController

    def create
      friend = User.find(params[:friend])
      current_user.friendships.build(friend_id: friend.id)
      if current_user.save
        flash[:notice] = "Friend successfully added"
      else
        flash[:alert] = "Oops! Looks like something went wrong!"
      end
      redirect_back(fallback_location: root_path)
    end
  
    def destroy
      friendship = current_user.friendships.where(friend_id: params[:id]).first
      friendship.destroy
      flash[:notice] = "Stopped following"
      redirect_back(fallback_location: root_path)
    end
  end