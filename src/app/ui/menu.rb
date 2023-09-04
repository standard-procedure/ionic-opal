module Ui
  class Menu < Element
    self.observed_attributes = %i[]

    def render
      inner_dom do |dom|
        dom.e "ion-header" do
          dom.e "ion-toolbar" do
            dom.e "ion-title" do
              "AQR"
            end
          end
        end
        if Application.current&.logged_in?
          dom.e "ion-list" do
            dom.e "ion-item", href: "/", detail: "false", lines: "none" do
              dom.e "ion-label" do
                "Dashboard"
              end
            end.on "click" do |event|
              parent.to_n.JS.close
            end
            dom.e "ion-item-divider"
            dom.e("ion-item", class: "ion-justify-content-center", href: "/login", "router-direction": "backward", detail: "false") { "Log out" }.on "click" do |event|
              Application.current.logout
              parent.to_n.JS.close
            end
          end
        else
          dom.e "ion-list" do
            dom.e("ion-item", class: "ion-justify-content-center", href: "/login", color: "success", "router-direction": "backward") { "Log in" }.on "click" do |event|
              parent.to_n.JS.close
            end
          end
        end
      end
    end

    custom_element "ui-menu"
  end
end
