class JsonWebToken
  class << self
    def encode(payload, exp = 24.hours.from_now)
      # Adds the expiration time
      payload[:exp] = exp.to_i
      # Encodes user ID, expiration time and the unique base key to create a JWT
      JWT.encode(payload, Rails.application.secrets.secret_key_base)
    end

    def decode(token)
      # Decodes the JWT using the secret key
      body = JWT.decode(token, Rails.application.secrets.secret_key_base)[0]
      # Creates a new hash with the body data with indifferent access
      HashWithIndifferentAccess.new body
    rescue
      nil
    end
  end
end
