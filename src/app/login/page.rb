module Login
  class Page < Element
    property :email
    property :password
    property :error

    def render
      inner_dom do |dom|
        dom.ui_header title: "Application"
        dom.ion_content class: "ion-padding" do
          dom.form class: "ion-align-self-stretch" do
            dom.ion_item do
              dom.ion_input(id: "email", type: "email", label: "Email", label_placement: "floating", autocomplete: "email", inputmode: "email", value: email, required: true).on "ionChange" do |event|
                self.email = event.target.value
              end
            end
            dom.ion_item do
              dom.ion_input(id: "password", label: "Password", label_placement: "floating", type: "password", autocomplete: "current-password", value: password, required: true, "error-text": error, class: class_map(ion_invalid: error.present?, ion_touched: error.present?)).on "ionChange" do |event|
                self.password = event.target.value
              end
            end
            dom.ion_item do
              dom.ion_button type: "submit", color: "success", size: "medium", slot: "end" do
                "Log in"
              end
            end
          end.on "submit" do |event|
            event.prevent
            do_login
          end
        end
      end
    end

    def do_login
      Application.current.login_as(self[:email], self[:password]).fail do
        self.error = "Unable to log in"
        redraw
      end
    end

    custom_element "login-page"
  end
end
