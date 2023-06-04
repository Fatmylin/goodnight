require 'rails_helper'

RSpec.describe API::RankingsController, type: :request do
  before do
    Timecop.freeze(Time.zone.local(2023, 6, 4))
  end

  let!(:user_a) { create(:user) }
  let!(:followed_user) { create(:user) }
  let!(:friendship_to_user_b) { create(:friendship, user: user_a, friend: followed_user) }
  let!(:not_followed_user) { create(:user) }
  let!(:user_a_sleep_record) { create(:sleep_record, user: user_a, start_at: Time.now, finish_at: Time.now + 8.hours) }
  let!(:followed_user_sleep_record) { create(:sleep_record, user: followed_user, start_at: Time.now, finish_at: Time.now + 6.hours) }
  let!(:not_followed_user_sleep_record) { create(:sleep_record, user: not_followed_user, start_at: Time.now, finish_at: Time.now + 4.hours) }

  describe "GET /api/rankings" do
    context "without auth token" do
      it "gets unaitherized response" do
        get "/api/rankings"
        expect(response).to have_http_status(:unauthorized)
        expect(response.body).to eq("Access denied.")
      end
    end

    context "with auth token" do
      it "gets all sleep records and sort by duration" do
        get "/api/rankings", headers: { Authorization: "Bearer #{user_a.token}" }
        expect(response).to have_http_status(:ok)
        expect(json_response).to eq(
          "sleep_records" => [
            {
              "duration" => "08:00:00", 
              "finish_at" => "2023-06-04T08:00:00.000Z", 
              "start_at" => "2023-06-04T00:00:00.000Z", 
              "user_id" => user_a.id,
              "id" => user_a_sleep_record.id
            }, 
            {
              "duration" => "06:00:00", 
              "finish_at" => "2023-06-04T06:00:00.000Z", 
              "start_at" => "2023-06-04T00:00:00.000Z", 
              "user_id" => followed_user.id,
              "id" => followed_user_sleep_record.id
            }
          ]
        )
      end

      it "does not return record from unfollowed friends" do
        get "/api/rankings", headers: { Authorization: "Bearer #{user_a.token}" }
        expect(response).to have_http_status(:ok)
        expect(json_response["sleep_records"].find { |s| s["id"] == not_followed_user_sleep_record.id }).to eq(nil)
      end
    end
  end
end