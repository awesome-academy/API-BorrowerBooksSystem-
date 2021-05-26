require 'rails_helper'

RSpec.describe Request, type: :model do
  describe "Associations" do
    it "belong to user" do
      should belong_to(:user)
    end

    it "has many request books" do
      should have_many(:request_books).dependent(:destroy)
    end

    it "has many books through request books" do
      should have_many(:books).through(:request_books).source(:book).dependent(:destroy)
    end
  end

  describe "Enum" do
    it { should define_enum_for(:status).with_values(pending: 0, approved: 1, rejected: 2, paid: 3, cancel: 4) }
  end

  describe "Validations" do
    context "validates start_date attribute" do
      it { should validate_presence_of(:start_date) }
    end

    context "validates end_date attribute" do
      it { should validate_presence_of(:end_date) }
    end

    context "validates request_books attribute" do
      it { should validate_presence_of(:request_books) }
    end

    let(:book) {FactoryBot.create :book, category: FactoryBot.create(:category)}
    let(:request) {FactoryBot.create :request, user: FactoryBot.create(:user), request_books_attributes: [{book: book, amount: 10}]}
    context "when valid" do
      it "have a valid data" do
        expect(request).to be_valid
      end
    end

    context "when invalid date" do
      it "start date before today" do
        request.update(start_date: 1.day.ago)
        expect(request.errors[:start_date]).to include(I18n.t("request.errors.start_date_before_today"))
      end

      it "end date before start date" do
        request.update(end_date: request.start_date - 1.day)
        expect(request.errors[:end_date]).to include(I18n.t("request.errors.end_date_before_start_date"))
      end
    end
  end
end
