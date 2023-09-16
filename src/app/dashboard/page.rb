require_relative "../accounts/list"

module Dashboard
  class Page < Element
    property :accounts, type: :array, default: []

    def render
      inner_dom do |dom|
        dom.ui_header title: "Accounts"
        dom.ion_content class: "ion-padding" do
          dom.accounts_list
        end
      end
    end

    custom_element "dashboard-page"
  end
end
