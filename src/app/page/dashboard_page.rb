class DashboardPage < Element
  self.observed_attributes = %i[]

  def render
    inner_dom do |dom|
      dom.e "ui-header", title: "Application"
      dom.e "ion-content", class: "ion-padding" do
        dom.e "ion-item", href: "/accounts" do
          dom.e("ion-label") { "Accounts" }
        end
        dom.e "ion-item", href: "/assessments" do
          dom.e("ion-label") { "Assessments" }
        end
        dom.e "ion-item", href: "/products" do
          dom.e("ion-label") { "Products" }
        end
        dom.e "ion-item", href: "/profile" do
          dom.e("ion-label") { "Profile" }
        end
      end
    end
  end

  custom_element "dashboard-page"
end
