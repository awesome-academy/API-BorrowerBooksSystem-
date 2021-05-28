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
end
