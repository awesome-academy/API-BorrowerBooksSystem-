class Api::V1::RequestsController < ApplicationController
  before_action :load_requests, only: %i(index search)
  before_action :valid_params_date, :vaild_date_range, only: :search

  def index
    @requests = paginate @requests
    render json: @requests, meta: pagination_meta(@requests)
  end

  def create
    @request = User.all.sample.requests.new request_params
    if @request.save
      return handle_resonse(
        {message: I18n.t("request.message.create_success")}, :created
      )
    end

    handle_resonse @request.errors.messages, :unprocessable_entity
  end

  def search
    @requests = @requests.ransack(params[:q]).result
    index
  end

  private

  def load_requests
    @requests = User.last.requests
                    .includes(request_books: {book: :category})
                    .order_by_created
  end

  def request_params
    params.require(:request)
          .permit(:start_date, :end_date,
                  request_books_attributes: [:book_id, :amount])
  end

  def vaild_date_range
    return if params[:q][:created_at_gteq].blank? ||
              params[:q][:created_at_lteq].blank?

    return if params[:q][:created_at_gteq] <= params[:q][:created_at_lteq]

    handle_resonse(
      {message: I18n.t("errors.date_range",
                       name1: :created_at_gteq, name2: :created_at_gteq)},
      :unprocessable_entity
    )
  end

  def valid_params_date
    params[:q][:created_at_gteq] =
      if params[:q][:created_at_gteq].present?
        parse_date(:created_at_gteq, params[:q][:created_at_gteq])
      end

    params[:q][:created_at_lteq] =
      if params[:q][:created_at_lteq].present?
        date = parse_date(:created_at_lteq, params[:q][:created_at_lteq])
        DateTime.parse("#{date} 23:59:59")
      end
  end
end
