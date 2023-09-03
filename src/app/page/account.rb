module Page
  class Account < Element
    self.observed_attributes = [:account_id, :name, :parent_id]

    def render
      inner_dom do |dom|
        dom.e "ui-header", title: self[:name]
        dom.e "ion-content", class: "ion-padding" do
          "Stuff goes here"
        end
      end
    end

    def on_changed attribute, old_value, new_value
      puts "on_changed: #{attribute} #{old_value} -> #{new_value}: #{attributes}"
    end

    def on_attached
      puts "on_attached - #{attributes.collect { |k, v| k }.join(", ")}"
    end

    def account_id_changed old_value, new_value
      puts "account_id_changed: #{old_value} -> #{new_value}: #{attributes}"
      return if new_value.nil?
      Application.current.send(:get, "/accounts/#{self[:account_id]}.json").then do |response|
        puts response.json
        redraw
      end
    end

    custom_element "account-page"
  end
end
