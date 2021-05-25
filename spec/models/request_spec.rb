require 'rails_helper'

RSpec.describe Request, type: :model do
  describe "Associations" do
    it "belong to user" do
      should belong_to(:user)
    end

    it "belong to book" do
      should belong_to(:book)
    end
  end

  describe "Enum" do
    it { should define_enum_for(:status).with_values(pending: 0, approved: 1, rejected: 2, paid: 3, cancel: 4) }
  end

  describe "Validations" do
    context "validates amount attribute" do
      it { should validate_presence_of(:amount) }
      it { should validate_numericality_of(:amount).only_integer }
      it { should validate_numericality_of(:amount).is_greater_than_or_equal_to(Settings.request.amount.min) }
    end

    context "validates start_date attribute" do
      it { should validate_presence_of(:start_date) }
    end

    context "validates end_date attribute" do
      it { should validate_presence_of(:end_date) }
    end

    let(:user) {FactoryBot.create :user}
    let(:book) {FactoryBot.create :book, category: FactoryBot.create(:category)}
    let(:request) {FactoryBot.create :request, user: user, book: book}
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

    context "when invalid amount" do
      it "greater number books remaining" do
        number_books_remaining = request.book.amount - request.book.requests.approved.sum(:amount)
        request.update(amount: number_books_remaining + 1)
        expect(request.errors[:amount]).to include(I18n.t("request.errors.amount", number: number_books_remaining))
      end
    end
  end
end
