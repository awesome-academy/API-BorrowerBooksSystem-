require 'rails_helper'

RSpec.describe RequestBook, type: :model do
  describe "Associations" do
    it "belong to request" do
      should belong_to(:request)
    end

    it "belong to book" do
      should belong_to(:book)
    end
  end

  describe "Validations" do
    context "validates amount attribute" do
      it { should validate_presence_of(:amount) }
      it { should validate_numericality_of(:amount).only_integer }
      it { should validate_numericality_of(:amount).is_greater_than_or_equal_to(Settings.request.amount.min) }
    end

    let(:book) {FactoryBot.create :book, category: FactoryBot.create(:category)}
    let(:request) {FactoryBot.create :request, user: FactoryBot.create(:user)}
    context "when invalid amount" do
      it "greater number books remaining" do
        request_book = FactoryBot.create :request_book, request: request, book: book, amount: 10
        books_remaining = request_book.book.amount - Book.books_borrowed(book)
        request_book.update(amount: books_remaining + 1)
        expect(request_book.errors[:amount]).to include(I18n.t("request.errors.amount", number: books_remaining))
      end
    end
  end
end
