class Api::V1::RequestsController < ApplicationController
  def create
    @request = User.all.sample.requests.new request_params
    if @request.save
      return handle_resonse(
        {message: I18n.t("request.message.create_success")}, :created
      )
    end

    handle_resonse @request.errors.messages, :unprocessable_entity
  end

  private

  def request_params
    params.require(:request)
          .permit(:start_date, :end_date,
                  request_books_attributes: [:book_id, :amount])
  end
end
