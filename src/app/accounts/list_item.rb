module Accounts
  class ListItem < Element
    property :id
    property :account_id, type: :integer
    property :name
    property :parent_id, type: :integer

    def render
      inner_dom do |dom|
        dom.ion_item href: "/accounts/#{account_id}" do
          dom.ion_label { name }
        end
      end
    end

    def on_attached
      self.id = "account-list-item-#{account_id}"
    end

    custom_element "account-list-item"
  end
end
