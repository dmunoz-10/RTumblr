class AuthenticateUser
  prepend SimpleCommand

  def initialize(email, password)
    @email = email
    @password = password
  end

  def call
    # Calls the encode method passing the user id if the user was found
    JsonWebToken.encode(user_id: user.id) if user
  end

  private

  attr_accessor :email, :password

  def user
    # Finds the user with the email
    user = User.find_by_email(email)
    # Returns the user if was found and if the password is correct.
    return user if user&.authenticate(password)
    # Adds an error with a message
    errors.add :user_authentication, 'Invalid credentials'
    nil
  end
end
