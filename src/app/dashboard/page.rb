require_relative "../accounts/list"

module Dashboard
  class Page < Element
    property :accounts, type: :array, default: []

    def render
      inner_dom do |dom|
        dom.e "ui-header", title: "Accounts"
        dom.e "ion-content", class: "ion-padding" do
          dom.e "accounts-list"
        end
      end
    end

    custom_element "dashboard-page"
  end
end
