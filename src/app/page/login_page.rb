class LoginPage < Element
  self.observed_attributes = %i[email password]

  def render
    inner_dom do |dom|
      dom.e "ion-header" do
        dom.e "ion-toolbar" do
          dom.e "ion-title" do
            "Login"
          end
        end
        dom.e "ion-content", class: "ion-padding" do
          form = dom.form do
            dom.e "ion-item" do
              field = dom.e("ion-input", id: "email", type: "email", required: true)
              field.on "ionChange" do |event|
                self[:email] = event.target.value
              end
            end
            dom.e "ion-item" do
              field = dom.e("ion-input", id: "password", placeholder: "Password", type: "password", autocomplete: "current-password", value: @password, required: true)
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
            Application.current.login_as self[:email], self[:password]
          end
        end
      end
    end
  end

  custom_element "login-page"
end
