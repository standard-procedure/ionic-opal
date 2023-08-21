class DashboardPage < Element
  self.observed_attributes = %i[]

  def render
    inner_dom do |dom|
      dom.e "ion-item", href: "/profile" do
        dom.e("ion-label") { "Profile" }
      end
    end
  end

  custom_element "dashboard-page"
end
