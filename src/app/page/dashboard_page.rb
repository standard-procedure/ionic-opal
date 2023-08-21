class DashboardPage < Element
  self.observed_attributes = %i[]

  def render
    inner_dom do |dom|
      dom.e "ui-header", title: "Application"
      dom.e "ion-content", class: "ion-padding" do
        dom.e "ion-item", href: "/profile" do
          dom.e "ion-label" do
            "Profile"
          end
        end
      end
    end
  end

  custom_element "dashboard-page"
end
