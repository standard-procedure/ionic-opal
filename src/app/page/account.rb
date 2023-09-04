module Page
  class Account < Element
    property :account_id, type: :integer
    property :name
    property :parent_id, type: :integer

    def render
      inner_dom do |dom|
        dom.e "ui-header", title: self[:name]
        dom.e "ion-content", class: "ion-padding" do
          "Stuff goes here"
        end
      end
    end

    def on_attached
      Application.current.send(:get, "/accounts/#{account_id}.json").then do |response|
        self[:name] = response.json["name"]
        self[:parent_id] = response.json["parent_id"]
        redraw
      end
    end

    custom_element "account-page"
  end
end
