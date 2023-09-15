require_relative "../accounts/list"

module Page
  class Dashboard < Element
    property :accounts, type: :array

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
