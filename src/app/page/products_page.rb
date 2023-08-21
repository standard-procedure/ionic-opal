class ProductsPage < Element
  self.observed_attributes = %i[]

  def initialize node
    super node
    @products = []
  end

  def render
    inner_dom do |dom|
      dom.e "ui-header", title: "Products"
      dom.e "ion-content", class: "ion-padding" do
        dom.e "ion-list" do
          @products.each do |product|
            dom.e "ion-item", href: "/products/#{product["id"]}" do
              dom.e "ion-label" do
                product["name"].to_s
              end
            end
          end
        end
      end
    end
  end

  def on_attached
    Application.current.send(:get, "/products.json").then do |response|
      @products = response.json
      redraw
    end
  end

  custom_element "products-page"
end
