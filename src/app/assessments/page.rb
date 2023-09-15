require_relative "../candidates/list"

module Assessments
  class Page < Element
    property :assessment_id, type: :integer
    property :title

    def render
      inner_dom do |dom|
        dom.e "ui-header", title: title
        dom.e "ion-content", class: "ion-padding" do
          dom.e "candidates-list", assessment_id: assessment_id
        end
      end
    end

    def on_attached
      load_assessment
      redraw
    end

    def load_assessment
      Application.current.fetch(:get, "/assessments/#{assessment_id}.json").then do |response|
        self.title = response.json["title"]
      end
    end

    custom_element "assessment-page"
  end
end
