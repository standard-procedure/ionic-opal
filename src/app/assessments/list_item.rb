class Assessments
  class ListItem < Element
    property :account_id, type: :integer
    property :assessment_id, type: :integer
    property :title

    def render
      inner_dom do |dom|
        dom.ion_item href: "/accounts/#{account_id}/assessments/#{assessment_id}" do
          dom.ion_label { title }
        end
      end
    end

    def on_attached
      self.id = "assessment-list-item-#{assessment_id}"
      load_assessment
    end

    def load_assessment
      assessment.observe do
        self.title = assessment.title
        redraw
      end
    end

    def account
      @account ||= application.accounts.find account_id
    end

    def assessment
      @assessment ||= account.assessments.find assessment_id
    end

    custom_element "account-list-item"
  end
end
