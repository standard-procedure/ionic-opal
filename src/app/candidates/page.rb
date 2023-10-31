require_relative "reports_list"

class Candidates
  class Page < Element
    property :assessment_id, type: :integer
    property :candidate_id, type: :integer
    property :name
    property :full_name
    property :first_name
    property :last_name
    property :email
    property :scores, type: :hash

    def render
      inner_dom do |dom|
        dom.ui_header title: candidate.full_name.to_s, back_href: "/accounts/#{account.id}/assessments/#{assessment.id}"
        dom.ion_content class: "ion-padding" do
          dom.ion_card do
            dom.ion_card_header do
              dom.ion_card_title { full_name }
            end

            dom.ion_card_content do
              dom.ion_grid do
                scores.each do |scale, score|
                  dom.ui_attribute name: scale, value: score.to_s
                end
                dom.ui_attribute name: "Email", value: email
              end
            end
          end
          dom.reports_list.created do |l|
            l.candidate = candidate
            l.reports = candidate.reports
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
        self.scores = candidate.scores
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
