class JsonWebToken
  SECRET_KEY = Rails.application.secrets.secret_key_base.freeze

  class << self
    def encode payload, exp = Time.zone.now + 24.hours.to_i
      payload[:exp] = exp.to_i
      JWT.encode(payload, SECRET_KEY)
    end

    def decode token
      HashWithIndifferentAccess.new JWT.decode(token, SECRET_KEY)[0]
    end
  end
end
