class ProfilePage < Element
  self.observed_attributes = %i[]

  def render
    inner_dom do |dom|
      dom.e "ui-header", title: "Profile"
      dom.e "ion-content", class: "ion-padding" do
        dom.e "ion-item", href: "/" do
          dom.e "ion-label" do
            "Dashboard"
          end
        end
        dom.e "ion-item", button: true do
          "Log out"
        end.on "click" do |event|
          Application.current.logout
        end
      end
    end
  end

  custom_element "profile-page"
end
