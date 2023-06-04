require 'rails_helper'

RSpec.describe API::SleepRecordsController, type: :request do
  let!(:user_a) { create(:user) }

  describe "GET /api/sleep_records" do
    let!(:sleep_record) { create(:sleep_record, user: user_a) }

    context "without auth token" do
      it "gets unaitherized response" do
        get "/api/sleep_records"
        expect(response).to have_http_status(:unauthorized)
        expect(response.body).to eq("Access denied.")
      end
    end

    context "with auth token" do
      it "gets all sleep records" do
        get "/api/sleep_records", headers: { Authorization: "Bearer #{user_a.token}" }
        expect(response).to have_http_status(:ok)
        expect(json_response).to eq(
          "sleep_records" => [
            { 
              "created_at" => sleep_record.as_json["created_at"], 
              "finish_at" => sleep_record.as_json["finish_at"], 
              "id" => sleep_record.id, 
              "start_at" => sleep_record.as_json["start_at"], 
              "updated_at" => sleep_record.as_json["updated_at"], 
              "user_id" => sleep_record.user_id
            }
          ]
        )
      end
    end
  end

  describe "POST /api/sleep_records" do
    context "without auth token" do
      it "gets unaitherized response" do
        post "/api/sleep_records"
        expect(response).to have_http_status(:unauthorized)
        expect(response.body).to eq("Access denied.")
      end
    end

    context "with auth token" do
      it "create a new sleep record" do
        expect{ 
          post "/api/sleep_records",
               headers: { Authorization: "Bearer #{user_a.token}" }
        }.to change { user_a.sleep_records.count }.by(1)
      end
    end
  end

  describe "PUT /api/sleep_records/{:id}" do
    let!(:sleep_record) { create(:sleep_record, user: user_a) }

    context "without auth token" do
      it "gets unaitherized response" do
        put "/api/sleep_records/#{sleep_record.id}"
        expect(response).to have_http_status(:unauthorized)
        expect(response.body).to eq("Access denied.")
      end
    end

    context "with auth token" do
      it "update a sleep_record start_at" do
        Timecop.freeze(Time.zone.local(2023, 6, 4)) do
          put "/api/sleep_records/#{sleep_record.id}",
              params: { clock_action: "start" },
              headers: { Authorization: "Bearer #{user_a.token}" }
          expect(sleep_record.reload.start_at&.strftime("%Y-%m-%d %H:%M")).to eq("2023-06-04 00:00")
        end
      end

      it "update a sleep_record start_at" do
        Timecop.freeze(Time.zone.local(2023, 6, 4)) do
          # Update sleep record
          sleep_record.update(start_at: Time.now)
          # 2 hours later
          Timecop.travel 2.hours do
            put "/api/sleep_records/#{sleep_record.id}",
                    params: { clock_action: "finish" },
                    headers: { Authorization: "Bearer #{user_a.token}" }
            expect(sleep_record.reload.finish_at&.strftime("%Y-%m-%d %H:%M")).to eq("2023-06-04 02:00")
          end
        end
      end

      it "raise error when clock action not support" do
        put "/api/sleep_records/#{sleep_record.id}",
              params: { clock_action: "other" },
              headers: { Authorization: "Bearer #{user_a.token}" }
        expect(json_response).to eq("errors" => "Not supported action." )
      end
    end
  end
end