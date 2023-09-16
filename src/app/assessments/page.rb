require_relative "../candidates/list"

module Assessments
  class Page < Element
    property :assessment_id, type: :integer
    property :title

    def render
      inner_dom do |dom|
        dom.ui_header title: title
        dom.ion_content class: "ion-padding" do
          dom.candidates_list assessment_id: assessment_id
        end
      end
    end

    def on_attached
      load_assessment
      redraw
    end

    def load_assessment
      application.fetch(:get, "/assessments/#{assessment_id}.json").then do |response|
        self.title = response.json["title"]
      end
    end

    custom_element "assessment-page"
  end
end
