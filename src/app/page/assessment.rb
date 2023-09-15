require_relative "../assessments/list"

module Page
  class Assessment < Element
    property :assessment_id, type: :integer
    property :title
    property :candidates, type: :array

    def render
      inner_dom do |dom|
        dom.e "ui-header", title: title
        dom.e "ion-content", class: "ion-padding" do
          "Candidates"
        end
      end
    end

    def on_attached
      load_assessment
      redraw
    end

    def load_assessment
      Application.current.send(:get, "/assessments/#{assessment_id}.json").then do |response|
        self.title = response.json["title"]
      end
    end

    def load_candidates
      Application.current.send(:get, "/assessments/#{assessment_id}/candidates.json").then do |response|
        self[:candidates] = response.json
      end
    end

    custom_element "assessment-page"
  end
end
