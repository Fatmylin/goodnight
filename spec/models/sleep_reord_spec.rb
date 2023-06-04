require 'spec_helper'

RSpec.describe SleepRecord, type: :model do
  let!(:valid_sleep_recrod) { create(:sleep_record, start_at: Time.now - 8.hours, finish_at: Time.now) }
  let!(:sleep_recrod_without_start_at_and_finish_at) { create(:sleep_record) }
  let!(:sleep_recrod_without_finish_at) { create(:sleep_record, start_at: Time.now - 8.hours) }

  describe ".valid" do
    it "returns sleep records with start_at and end_at" do
      expect(SleepRecord.valid.include?(valid_sleep_recrod)).to eq(true)
    end

    it "does not return sleep records without start_at and finish at" do
      expect(SleepRecord.valid.exclude?(sleep_recrod_without_start_at_and_finish_at)).to eq(true)
    end
  end

  describe ".time_validation" do
    it "returns true when start_at and finish at are null" do
      expect(sleep_recrod_without_start_at_and_finish_at.valid?).to eq(true)
    end

    it "returns true when start_at is not null and finish at is null" do
      expect(sleep_recrod_without_finish_at.valid?).to eq(true)
    end

    it "returns errors when start_at is null and finish at is not null" do
      sleep_recrod_without_start_at = build(:sleep_record, finish_at: Time.now)
      expect(sleep_recrod_without_start_at.valid?).to eq(false)
      expect(sleep_recrod_without_start_at.errors.full_messages.join(",")).to eq("Start at is missing.")
    end

    it "returns errors when start_at is null and finish at is not null" do
      sleep_recrod_finish_at_before_start_at = build(:sleep_record, start_at: Time.now + 8.hours, finish_at: Time.now)
      expect(sleep_recrod_finish_at_before_start_at.valid?).to eq(false)
      expect(sleep_recrod_finish_at_before_start_at.errors.full_messages.join(",")).to eq("Finish at should be after start at.")
    end
  end

  describe "#duration" do
    it "returns finish_at - start_at in format of hour:minute:second" do
      expect(valid_sleep_recrod.duration).to eq("08:00:00")
    end

    it "returns 00:00:00 when sleep record is invalid" do
      expect(sleep_recrod_without_start_at_and_finish_at.duration).to eq("00:00:00")
    end
  end
end
