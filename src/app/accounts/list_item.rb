class Accounts
  class ListItem < Element
    property :id
    property :account, type: :ruby
    property :name
    property :parent_id, type: :integer

    def render
      inner_dom do |dom|
        dom.ion_item href: "/accounts/#{account.id}" do
          dom.ion_label { name }
        end
      end
    end

    def on_attached
      self.id = "account-list-item-#{account.id}"
      load_account
    end

    def load_account
      account.observe do
        self.name = account.name
        self.parent_id = account.parent_id
        redraw
      end
    end

    custom_element "account-list-item"
  end
end
