

module SignInHelper
  def login_user(user)
    post login_url, params: { email_address: user.email_address, password: "password" }
  end
end
