require_relative "../candidates/list"

class Assessments
  class Page < Element
    property :account_id, type: :integer
    property :assessment_id, type: :integer
    property :title

    def render
      inner_dom do |dom|
        dom.ui_header title: title
        dom.ion_content class: "ion-padding" do
          dom.candidates_list.created do |l|
            l.assessment = assessment
            l.account = account
          end
        end
      end
    end

    def on_attached
      load_assessment
    end

    def load_assessment
      Signal.observe do
        self.title = assessment.title
        redraw
      end
    end

    def account
      @account ||= application.accounts.find account_id
    end

    def assessment
      @assessment ||= application.assessments.find assessment_id
    end

    custom_element "assessment-page"
  end
end
