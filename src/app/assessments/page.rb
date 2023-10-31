require_relative "../candidates/list"

class Assessments
  class Page < Element
    property :account_id, type: :integer
    property :assessment_id, type: :integer
    property :title
    property :starting_on, tyoe: :date
    property :ending_on, tyoe: :date
    property :status

    def render
      inner_dom do |dom|
        dom.ui_header title: title, back_href: "/accounts/#{account_id}"
        dom.ion_content class: "ion-padding" do
          dom.ion_card do
            dom.ion_card_header do
              dom.ion_card_title { assessment.title }
            end
            dom.ion_card_content do
              dom.ion_grid do
                dom.ui_attribute name: "Starting on", value: starting_on
                dom.ui_attribute name: "Ending on", value: ending_on
                dom.ui_attribute name: "Status", value: status
              end
            end
          end
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
        self.starting_on = assessment.starting_on
        self.ending_on = assessment.ending_on
        self.status = assessment.status
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
