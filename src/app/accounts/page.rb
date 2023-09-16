require_relative "../assessments/list"

module Accounts
  class Page < Element
    property :account_id, type: :integer
    property :name
    property :parent_id, type: :integer

    def render
      inner_dom do |dom|
        dom.ui_header title: name
        dom.ion_content class: "ion-padding" do
          if account_id.present?
            dom.assessments_list account_id: account_id
          end
        end
      end
    end

    def on_attached
      load_account
    end

    def load_account
      application.fetch(:get, "/accounts/#{account_id}.json").then do |response|
        self.name = response.json["name"]
        self.parent_id = response.json["parent_id"]
        redraw
      end
    end

    custom_element "account-page"
  end
end
