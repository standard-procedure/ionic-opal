module Page
  class Assessments < Element
    property :assessments, type: :array

    def render
      inner_dom do |dom|
        dom.e "ui-header", title: "Assessments"
        dom.e "ion-content", class: "ion-padding" do
          dom.e "ion-list" do
            assessments.each do |assessment|
              dom.e "ion-item", href: "/assessments/#{assessment["id"]}" do
                dom.e "ion-label" do
                  assessment["title"].to_s
                end
              end
            end
          end
        end
      end
    end

    def on_attached
      Application.current.send(:get, "/assessments.json").then do |response|
        self.assessments = response.json
        redraw
      end
    end

    custom_element "assessments-page"
  end
end