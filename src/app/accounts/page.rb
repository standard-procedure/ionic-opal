require_relative "../assessments/list"

module Accounts
  class Page < Element
    property :account_id, type: :integer
    property :name
    property :parent_id, type: :integer

    def render
      inner_dom do |dom|
        dom.e "ui-header", title: name
        dom.e "ion-content", class: "ion-padding" do
          dom.e "assessments-list", account_id: account_id unless account_id == 0
        end
      end
    end

    def on_attached
      load_account
      redraw
    end

    def load_account
      Application.current.fetch(:get, "/accounts/#{account_id}.json").then do |response|
        self.name = response.json["name"]
        self.parent_id = response.json["parent_id"]
        redraw
      end
    end

    custom_element "account-page"
  end
end
