require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) {FactoryBot.build :user}
  subject {user}

  describe "Associations" do
    it "has many requests" do
      should have_many(:requests).dependent(:destroy)
    end

    it "has many book followers" do
      should have_many(:book_followers).dependent(:destroy)
    end

    it "has many followed books through book followers" do
      should have_many(:followed_books).through(:book_followers).source(:book).dependent(:destroy)
    end
  end

  describe "Enum" do
    it { should define_enum_for(:role).with_values(user: 0, admin: 1) }
  end

  describe "Validations" do
    context "validates name attribute" do
      it { should validate_presence_of(:name) }
      it { should validate_length_of(:name).is_at_most(Settings.user.name.max_length) }
    end

    context "validates email attribute" do
      it { should validate_presence_of(:email) }
      it { should validate_length_of(:email).is_at_most(Settings.user.email.max_length) }
      it { should allow_value('mail@gmail.com').for(:email) }
      it { should_not allow_value('mail@@@gmail.com').for(:email) }
      it { should validate_uniqueness_of(:email).case_insensitive }
    end

    context "validates password attribute" do
      it { expect(User.new).to validate_presence_of(:password) }
      it { should have_secure_password }
      it { should validate_length_of(:password).is_at_least(Settings.user.password.min_length) }
    end
  end

  describe "instance methods" do
    describe "#downcase_email" do
      it "return a downcase email" do
        user.email = "Email@gmail.com"
        expect(user.send(:downcase_email)).to eq("email@gmail.com")
      end
    end
  end
end
