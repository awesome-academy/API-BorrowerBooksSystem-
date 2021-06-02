class Api::V1::RequestsController < ApplicationController
  def index
    @requests = @current_user.requests
                             .includes(request_books: {book: :category})
                             .order_by_created
    @requests = paginate @requests
    render json: @requests, meta: pagination_meta(@requests)
  end

  def create
    @request = @current_user.requests.new request_params
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
