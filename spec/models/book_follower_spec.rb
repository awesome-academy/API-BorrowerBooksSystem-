require 'rails_helper'

RSpec.describe BookFollower, type: :model do
  describe "Associations" do
    it "belong to user" do
      should belong_to(:user)
    end

    it "belong to book" do
      should belong_to(:book)
    end
  end
end
