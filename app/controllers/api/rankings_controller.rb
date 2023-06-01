module API
  class RankingsController < ApplicationController
    def index
      sleep_records = current_user.sleep_records.or(SleepRecord.where(user: current_user.friends))
                                  .valid
                                  .sort { |a, b| b.duration <=> a.duration }
      render json: { sleep_records: sleep_records.map { |sleep_record| sleep_record.as_json.merge(duration: sleep_record.duration) } }
    end
  end
end
