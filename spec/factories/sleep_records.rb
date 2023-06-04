FactoryBot.define do
  factory :sleep_record do
    user { create(:user) }
  end
end
