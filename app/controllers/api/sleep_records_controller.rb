module API
  class SleepRecordsController < ApplicationController
    def index
      render json: { sleep_records: current_user.sleep_records.order(created_at: :desc) }
    end

    def create
      sleep_record = current_user.sleep_records.create
      render json: { id: sleep_record.id }
    end

    def update
      sleep_record = current_user.sleep_records.find(params[:id])
      if sleep_record.update(sleep_record_params)
        render json: { id: sleep_record.id }
      else
        render json: { errors: sleep_record.errors.full_messages.join(",") }
      end
    end

    private

    def sleep_record_params
      if (params[:clock_action] == "start")
        {
          start_at: Time.now
        }
      else
        {
          finish_at: Time.now
        }
      end
    end
  end
end