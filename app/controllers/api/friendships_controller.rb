module API
  class FriendshipsController < ApplicationController
    def index
      render json: { 
        friendships: current_user.friendships.map do |friendship|
          friend = friendship.friend
          friendship.as_json.merge(friend: friend.as_json)
        end
      }
    end

    def create
      friend = User.find(params[:friend_id])
      friendship = current_user.friendships.new(friend:)
      if friendship.save
        render json: { id: friendship.id }
      else
        render json: { errors: friendship.errors.full_messages.join(",") }
      end
    end

    def destroy
      friendship = current_user.friendships.find_by(id: params[:id])
      raise ActiveRecord::RecordNotFound if friendship.nil?

      if friendship.destroy
        render json: { messages: "Unfollowed" }
      else
        render json: { errors: friendship.errors.full_messages.join(",") }
      end
    end
  end
end