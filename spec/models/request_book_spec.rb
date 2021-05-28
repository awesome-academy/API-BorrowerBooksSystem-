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

    let(:request) {FactoryBot.create :request}
    context "when invalid amount" do
      it "greater number books remaining" do
        request_book = request.request_books.first
        books_remaining = request_book.book.amount - Book.books_borrowed(request_book.book)
        request_book.update(amount: books_remaining + 1)
        expect(request_book.errors[:amount]).to include(I18n.t("request.errors.amount", book: request_book.book.title, number: books_remaining))
      end
    end

    context "when invalid book" do
      it "book don't exist" do
        request_book = request.request_books.first
        request_book.update(book_id: Book.last.id + 1)
        expect(request_book.errors[:book]).to include(I18n.t("request.errors.book.required", id: request_book.book_id))
      end
    end
  end
end
