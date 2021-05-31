require 'rails_helper'

RSpec.describe "Api::V1::Requests", type: :request do
  let!(:user) {FactoryBot.create :user}
  let(:book) {FactoryBot.create :book}
  # let(:)
  describe "GET #index" do
    before :each do
      FactoryBot.create :request
      get api_v1_requests_path
    end

    it "returns http success" do
      expect(response).to have_http_status(:success)
    end

    it "JSON body response contains requests" do
      expect(response.parsed_body["requests"].size).to eq(1)
    end
  end

  describe "POST #create" do
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

  describe "Get|Post #search" do
    let(:request1) {FactoryBot.create :request}
    let(:request2) {FactoryBot.create :request}

    context "when valid params" do
      after :each do
        expect(response).to have_http_status(:success)
        expect(response.parsed_body["requests"].size).to eq 1
        expect(response.parsed_body["requests"][0]["id"]).to eq request1.id
      end

      context "search by status" do
        it "render JSON response with request valid" do
          request1.approved!
          request2.cancel!
          get search_api_v1_requests_path, params: {q: {status_eq: Request.statuses[:approved]}}
        end
      end

      context "search by title book" do
        it "render JSON response with request valid" do
          Book.update_all(title: "test")
          request1.request_books.first.book.update(title: "rspec")
          get search_api_v1_requests_path, params: {q: {books_title_cont: "rspec"}}
        end
      end

      context "search by created_at" do
        it "render JSON response with request valid" do
          request1.update(created_at: DateTime.parse("15-09-2019 15:09:19"))
          request2.update(created_at: DateTime.parse("17-09-2019 15:09:19"))
          get search_api_v1_requests_path, params: {q: {created_at_gteq: "14-09-2019", created_at_lteq: "16-09-2019"}}
        end
      end
    end

    context "when date range invalid" do
      it "render JSON response with message errors" do
        get search_api_v1_requests_path, params: {q: {created_at_gteq: "17-09-2019", created_at_lteq: "16-09-2019"}}
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.parsed_body["message"]).to eq(I18n.t("errors.date_range", name1: :created_at_gteq, name2: :created_at_gteq))
      end
    end

    context "when date invalid" do
      it "render JSON response with message errors" do
        get search_api_v1_requests_path, params: {q: {created_at_gteq: "17-19-2019"}}
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.parsed_body["message"]).to eq(I18n.t("errors.date", name: :created_at_gteq))
      end
    end
  end
end
