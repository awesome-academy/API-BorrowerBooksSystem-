require 'rails_helper'

RSpec.describe Book, type: :model do
  describe "Associations" do
    it "belong to category" do
      should belong_to(:category)
    end

    it "has many request books" do
      should have_many(:request_books).dependent(:destroy)
    end

    it "has many book followers" do
      should have_many(:book_followers).dependent(:destroy)
    end

    it "has many followers through book followers" do
      should have_many(:followers).through(:book_followers).source(:user).dependent(:destroy)
    end
  end

  describe "Validations" do
    context "validates title attribute" do
      it { should validate_presence_of(:title) }
      it { should validate_length_of(:title).is_at_most(Settings.book.title.max_length) }
    end

    context "validates author attribute" do
      it { should validate_presence_of(:author) }
      it { should validate_length_of(:author).is_at_most(Settings.book.author.max_length) }
    end

    context "validates amount attribute" do
      it { should validate_presence_of(:amount) }
      it { should validate_numericality_of(:amount).only_integer }
      it { should validate_numericality_of(:amount).is_greater_than_or_equal_to(Settings.book.amount.min) }
    end
  end

  describe "#books_borrowed" do
    let(:request) {FactoryBot.create :request, status: Request.statuses[:approved]}
    it "returns number of books borrowed " do
      book = request.request_books.first.book
      expect(Book.books_borrowed(book)).to eq request.request_books.first.amount
    end
  end
end
