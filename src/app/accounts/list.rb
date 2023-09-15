module Accounts
  class List < Element
    property :accounts, type: :array, default: []

    def render
      inner_dom do |dom|
        dom.e "ion-content", class: "ion-padding" do
          dom.e "ion-list" do
            if accounts.any?
              dom.e "ion-list-header" do
                dom.e "ion-label" do
                  "Accounts"
                end
              end
              accounts.map(&:get).each do |account|
                dom.e "ion-item", href: "/accounts/#{account["id"]}" do
                  dom.e "ion-label" do
                    account["name"].to_s
                  end
                end
              end
            else
              dom.e "ion-list-header" do
                dom.e "ion-label" do
                  "No accounts"
                end
              end
            end
          end
        end
      end
    end

    def on_attached
      load_accounts
    end

    def load_accounts
      Application.current.fetch(:get, "/accounts.json").then do |response|
        self.accounts = response.json
        redraw
      end
    end

    custom_element "accounts-list"
  end
end
