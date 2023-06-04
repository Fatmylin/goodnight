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
      if SleepRecord::BEHAVIORS.exclude?(params[:clock_action])
        return render json: { errors: "Not supported action." }
      end

      sleep_record = current_user.sleep_records.find(params[:id])
      if sleep_record.update(sleep_record_params)
        render json: { id: sleep_record.id }
      else
        render json: { errors: sleep_record.errors.full_messages.join(",") }
      end
    end

    private

    def sleep_record_params
      case params[:clock_action]
      when "start"
        { start_at: Time.now }
      when "finish"
        { finish_at: Time.now }
      end
    end
  end
end