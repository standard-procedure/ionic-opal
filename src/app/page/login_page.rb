class LoginPage < Element
  self.observed_attributes = %i[email password error]

  def render
    inner_dom do |dom|
      form = dom.form class: "ion-align-self-stretch" do
        dom.e "ion-item" do
          field = dom.e("ion-input", id: "email", type: "email", placeholder: "Email", autocomplete: "email", value: self[:email], required: true)
          field.on "ionChange" do |event|
            self[:email] = event.target.value
          end
        end
        dom.e "ion-item" do
          field = dom.e("ion-input", id: "password", placeholder: "Password", type: "password", autocomplete: "current-password", value: self[:password], required: true, "error-text": self[:error])
          field.on "ionChange" do |event|
            self[:password] = event.target.value
          end
        end
        dom.e "ion-item" do
          dom.e "ion-button", type: "submit", expand: "block" do
            "Log in"
          end
        end
      end
      form.on "submit" do |event|
        event.prevent
        do_login
      end
    end
  end

  def do_login
    Application.current.login_as self[:email], self[:password]
  rescue Application::LoginFailed => error
    self[:error] = error.message
  end

  custom_element "login-page"
end
