class ApplicationController < ActionController::API
  before_action :set_locale

  private

  def handle_resonse message, status
    render json: message, status: status
  end

  def set_locale
    locale = params[:locale].to_s.strip.to_sym
    I18n.locale = if I18n.available_locales.include?(locale)
                    locale
                  else
                    I18n.default_locale
                  end
  end

  def pagination_meta collection
    return unless collection

    {
      per_page: collection.per_page,
      current_page: collection.current_page,
      next_page: collection.next_page,
      previous_page: collection.previous_page,
      total_pages: collection.total_pages,
      total_entries: collection.total_entries
    }
  end

  def paginate collection
    collection.paginate(page: params[:page],
      per_page: params[:per_page] || Settings.paginate.per_page)
  end
end
