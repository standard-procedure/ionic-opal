module Login
  class Page < Element
    property :email
    property :password
    property :error

    def render
      inner_dom do |dom|
        dom.e "ui-header", title: "Application"
        dom.e "ion-content", class: "ion-padding" do
          form = dom.form class: "ion-align-self-stretch" do
            dom.e "ion-item" do
              dom.e("ion-input", id: "email", type: "email", label: "Email", "label-placement": "floating", autocomplete: "email", inputmode: "email", value: self[:email], required: true).on "ionChange" do |event|
                self.email = event.target.value
              end
            end
            dom.e "ion-item" do
              dom.e("ion-input", id: "password", label: "Password", "label-placement": "floating", type: "password", autocomplete: "current-password", value: self[:password], required: true, "error-text": self[:error]).on "ionChange" do |event|
                self.password = event.target.value
              end
            end
            dom.e "ion-item" do
              dom.e "ion-button", type: "submit", color: "success", size: "medium", slot: "end" do
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
    end

    def do_login
      Application.current.login_as self[:email], self[:password]
    rescue Application::LoginFailed => error
      self.error = error.message
    end

    custom_element "login-page"
  end
end
