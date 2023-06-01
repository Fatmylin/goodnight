class User < ApplicationRecord
  has_many :sleep_records
  has_many :friendships
  has_many :friends, through: :friendships

  before_create :create_token

  private

  def create_token
    self.token = SecureRandom.urlsafe_base64
  end
end
