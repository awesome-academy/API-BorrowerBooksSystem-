require 'rails_helper'

RSpec.describe "Api::V1::Requests", type: :request do
  describe "POST #create" do
    let!(:user) {FactoryBot.create :user}
    let(:book) {FactoryBot.create :book}

    context "when valid parameters" do
      before :each do
        valid_params = {request: {start_date: Date.today, end_date: Date.today + 1.day,
          request_books_attributes: [{book_id: book.id, amount: 1}, {book_id: book.id, amount: 2}]}}
        post api_v1_requests_path, params: valid_params
      end

      it "create new request" do
        expect(Request.count).to eq(1)
        expect(RequestBook.count).to eq(2)
      end

      it "return http created" do
        expect(response).to have_http_status(:created)
      end

      it "render JSON response with message" do
        expect(response.parsed_body["message"]).to eq(I18n.t("request.message.create_success"))
      end
    end

    context "when invalid params" do
      before :each do
        invalid_params = {request: {start_date: Date.today - 10.day, end_date: Date.today - 20.day,
          request_books_attributes: [{book_id: book.id, amount: book.amount + 1}, {book_id: Book.last.id + 1}]}}
        post api_v1_requests_path, params: invalid_params
        @request_clone = FactoryBot.build(:request, invalid_params[:request])
        @request_clone.valid?
      end

      it "no new request record is created" do
        expect(Request.count).to eq(0)
        expect(RequestBook.count).to eq(0)
      end

      it "return http unprocessable_entity" do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "has start_date errors message" do
        expect(response.parsed_body["start_date"]).to eq(@request_clone.errors[:start_date])
      end

      it "has end_date errors message" do
        expect(response.parsed_body["end_date"]).to eq(@request_clone.errors[:end_date])
      end

      it "has book errors message" do
        expect(response.parsed_body["request_books.book"]).to eq(@request_clone.errors[:"request_books.book"])
      end

      it "has amount errors message" do
        expect(response.parsed_body["request_books.amount"]).to eq(@request_clone.errors[:"request_books.amount"])
      end
    end
  end
end
