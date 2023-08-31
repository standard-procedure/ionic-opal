module Page
  class Accounts < Element
    self.observed_attributes = %i[]

    def initialize node
      super node
      @accounts = []
    end

    def render
      inner_dom do |dom|
        dom.e "ui-header", title: "Accounts"
        dom.e "ion-content", class: "ion-padding" do
          dom.e "ion-list" do
            @accounts.each do |account|
              dom.e "ion-item", href: "/accounts/#{account["id"]}" do
                dom.e "ion-label" do
                  account["name"].to_s
                end
              end
            end
          end
        end
      end
    end

    def on_attached
      Application.current.send(:get, "/accounts.json").then do |response|
        @accounts = response.json
        redraw
      end
    end

    custom_element "accounts-page"
  end
end
