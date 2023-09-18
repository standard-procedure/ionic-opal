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
      account.observe do
        self.name = account[:name]
        self.parent_id = account[:parent_id]
        redraw
      end
    end

    def account
      @account ||= application.account(account_id)
    end

    custom_element "account-page"
  end
end
