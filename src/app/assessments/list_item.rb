class Assessments
  class ListItem < Element
    property :account, type: :ruby
    property :assessment, type: :ruby
    property :title

    def render
      inner_dom do |dom|
        dom.ion_item href: "/accounts/#{account.id}/assessments/#{assessment.id}" do
          dom.ion_label { title }
        end
      end
    end

    def on_attached
      self.id = "assessment-list-item-#{assessment.id}"
      observe_assessment
    end

    def observe_assessment
      Signal.observe do
        self.title = assessment.title
        redraw
      end
    end

    custom_element "assessment-list-item"
  end
end
