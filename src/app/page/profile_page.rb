class ProfilePage < Element
  self.observed_attributes = %i[]

  def render
    document.at("#page-title").text = "Profile"
    inner_dom do |dom|
      dom.e "ion-item", button: true do
        "Log out"
      end.on "click" do |event|
        Application.current.logout
      end
    end
  end

  custom_element "profile-page"
end
