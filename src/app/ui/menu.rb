module Ui
  class Menu < Element
    self.observed_attributes = %i[]

    def render
      inner_dom do |dom|
        dom.e "ion-content", class: "ion-padding" do
          dom.e "ion-list" do
            dom.e "ion-item", href: "/" do
              dom.e "ui-icon", name: "dashboard", slot: "start"
              dom.e "ion-label" do
                "Dashboard"
              end
            end
            dom.e "ion-item" do
              dom.e "ui-icon", name: "log_out", slot: "start"
              dom.e "ion-label" do
                "Log out"
              end
            end.on "click" do |event|
              Application.current.logout
            end
          end
        end
      end
    end

    custom_element "ui-menu"
  end
end
