require 'rails_helper'

RSpec.describe API::FriendshipsController, type: :request do
  let!(:user_a) { create(:user) }
  let!(:user_b) { create(:user) }

  describe "GET /api/friendships" do
    let!(:friendship_to_user_b) { create(:friendship, user: user_a, friend: user_b) }

    context "without auth token" do
      it "gets unaitherized response" do
        get "/api/friendships"
        expect(response).to have_http_status(:unauthorized)
        expect(response.body).to eq("Access denied.")
      end
    end

    context "with auth token" do
      it "gets all friendships" do
        get "/api/friendships", headers: { Authorization: "Bearer #{user_a.token}" }
        expect(response).to have_http_status(:ok)
        expect(json_response).to eq(
          "friendships" => [
            {
              "friend" => {
                "email" => user_b.email,
                "id" => user_b.id,
                "name" => user_b.name,
              },
              "friend_id" => friendship_to_user_b.friend_id,
              "id" => friendship_to_user_b.id,
              "user_id" => friendship_to_user_b.user_id
            }
          ]
        )
      end
    end
  end

  describe "POST /api/friendships" do
    context "without auth token" do
      it "gets unaitherized response" do
        post "/api/friendships"
        expect(response).to have_http_status(:unauthorized)
        expect(response.body).to eq("Access denied.")
      end
    end

    context "with auth token" do
      it "create a new friendship" do
        expect{ 
          post "/api/friendships",
               params: { friend_id: user_b.id },
               headers: { Authorization: "Bearer #{user_a.token}" }
        }.to change { user_a.friendships.count }.by(1)
      end
    end
  end

  describe "DELETE /api/friendships/{:id}" do
    let!(:friendship_to_user_b) { create(:friendship, user: user_a, friend: user_b) }

    context "without auth token" do
      it "gets unaitherized response" do
        delete "/api/friendships/#{friendship_to_user_b.id}"
        expect(response).to have_http_status(:unauthorized)
        expect(response.body).to eq("Access denied.")
      end
    end

    context "with auth token" do
      it "destroy a new friendship" do
        expect{ 
          delete "/api/friendships/#{friendship_to_user_b.id}",
                 headers: { Authorization: "Bearer #{user_a.token}" }
        }.to change { user_a.friendships.count }.by(-1)
      end
    end
  end
end