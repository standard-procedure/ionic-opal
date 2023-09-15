module Assessments
  class List < Element
    property :account_id, type: :integer
    property :assessments, type: :array, default: []

    def render
      inner_dom do |dom|
        dom.e "ion-content", class: "ion-padding" do
          dom.e "ion-list" do
            if assessments.any?
              dom.e "ion-list-header" do
                dom.e "ion-label" do
                  "Assesssments"
                end
              end
              assessments.each do |assessment|
                dom.e "ion-item", href: "/assessments/#{assessment.peek["id"]}" do
                  dom.e "ion-label" do
                    assessment.peek["title"].to_s
                  end
                end
              end
            else
              dom.e "ion-list-header" do
                dom.e "ion-label" do
                  "No Assesssments"
                end
              end
            end
          end
        end
      end
    end

    def on_attached
      load_assessments
    end

    def load_assessments
      Application.current.fetch(:get, "/accounts/#{account_id}/assessments.json").then do |response|
        self.assessments = response.json
        redraw
      end
    end

    custom_element "assessments-list"
  end
end
