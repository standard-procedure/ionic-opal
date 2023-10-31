require_relative "../assessments/list"

class Accounts
  class Page < Element
    property :account_id, type: :integer
    property :name
    property :parent_id, type: :integer
    property :header, type: :ruby
    attr_reader :account

    def render
      inner_dom do |dom|
        dom.ui_header title: name, back_href: "/"
        dom.ion_content class: "ion-padding" do
          dom.assessments_list.created do |list|
            list.account = account
          end
        end
      end
    end

    def on_attached
      application.accounts.get(account_id).then do |account|
        @account = account
        load_account
      end
    end

    def load_account
      account.observe do
        self.name = account.name
        self.parent_id = account.parent_id
        redraw
      end
    end

    custom_element "account-page"
  end
end
