class SleepRecord < ApplicationRecord
  BEHAVIORS = ["start", "finish"].freeze

  belongs_to :user

  scope :valid, -> { where("start_at is not NULL OR finish_at is not NULL")}

  validate :time_validation

  def duration
    return '00:00:00' if finish_at.nil? || start_at.nil?

    sec = finish_at - start_at
    min, sec = sec.divmod(60)
    hour, min = min.divmod(60)
    "%02d:%02d:%02d" % [hour, min, sec]
  end

  private

  def time_validation
    return if (start_at.nil? && finish_at.nil?) # New record
    return if (start_at.present? && finish_at.nil?) # Set up start

    if (start_at.nil? && finish_at.present?)
      errors.add(:base, "Start at is missing.")
    elsif start_at > finish_at
      errors.add(:base, "Finish at should be after start at.")
    end
  end
end