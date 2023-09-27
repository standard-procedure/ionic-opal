module Ui
  class Attribute < Element
    property :name
    property :value

    def render
      inner_dom do |d|
        d.ion_row do
          d.ion_col { name }
          d.ion_col(class: "ion-text-end") { value }
        end
      end
    end

    custom_element "ui-attribute"
  end
end
