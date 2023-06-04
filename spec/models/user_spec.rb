require 'spec_helper'

RSpec.describe User, type: :model do
  describe "#create_token" do
    it "automatically generates token after create" do
      user = build(:user)
      expect(user.token.nil?).to eq(true)
      user.save
      expect(user.reload.token.nil?).to eq(false)
    end
  end
end
