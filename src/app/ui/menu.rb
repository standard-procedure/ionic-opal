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
        dom.e "ion-content", class: "ion-align-self-stretch" do
          dom.e "ion-list" do
            dom.e "ion-item", href: "/" do
              dom.e "ion-label" do
                "Dashboard"
              end
            end.on "click" do |event|
              parent.to_n.JS.close
            end
          end
        end
        dom.e "ion-footer" do
          dom.e "ion-toolbar" do
            dom.e "ion-title" do
              "Log out"
            end.on "click" do |event|
              Application.current.logout
              parent.to_n.JS.close
            end
          end
        end
      end
    end

    custom_element "ui-menu"
  end
end
