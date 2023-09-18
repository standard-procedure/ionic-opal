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
          dom.candidates_list assessment_id: assessment_id
        end
      end
    end

    def on_attached
      load_assessment
      redraw
    end

    def load_assessment
      assessment.observe do
        self.title = assessment.title
      end
    end

    def account
      application.accounts.find account_id
    end

    def assessment
      account.assessments.find assessment_id
    end

    custom_element "assessment-page"
  end
end
