class Candidates
  class Page < Element
    property :assessment_id, type: :integer
    property :candidate_id, type: :integer
    property :name
    property :full_name
    property :first_name
    property :last_name
    property :email

    def render
      inner_dom do |dom|
        dom.ui_header title: candidate.full_name.to_s
        dom.ion_content class: "ion-padding" do
          dom.ion_card do
            dom.ion_card_header do
              dom.ion_card_title { candidate.full_name }
            end

            dom.ion_card_content do
              candidate.email.to_s
            end
          end
        end
      end
    end

    def on_attached
      load_candidate
    end

    def load_candidate
      Signal.observe do
        self.full_name = candidate.full_name
        self.first_name = candidate.first_name
        self.last_name = candidate.last_name
        self.email = candidate.email
        redraw
      end
    end

    def account
      assessment.account
    end

    def assessment
      @assessment ||= application.assessments.find assessment_id
    end

    def candidate
      @candidate ||= application.candidates.find candidate_id
    end

    custom_element "candidate-page"
  end
end
