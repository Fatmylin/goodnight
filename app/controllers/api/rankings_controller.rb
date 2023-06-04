module API
  class RankingsController < ApplicationController
    def index
      sleep_records = current_user.sleep_records.or(SleepRecord.where(user: current_user.friends))
                                  .valid
                                  .sort { |a, b| b.duration <=> a.duration }
      render json: { 
        sleep_records: sleep_records.map do |sleep_record|
          sleep_record.as_json(only: %i[id start_at finish_at user_id]).merge(duration: sleep_record.duration)
        end
      }
    end
  end
end
