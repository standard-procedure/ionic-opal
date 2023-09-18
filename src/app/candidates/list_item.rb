class Candidates
  class ListItem < Element
    property :account, type: :ruby
    property :assessment, type: :ruby
    property :candidate, type: :ruby
    property :name

    def render
      inner_dom do |dom|
        dom.ion_item href: "/accounts/#{account.id}/assessments/#{assessment.id}/candidates/#{candidate.id}" do
          dom.ion_label { name }
        end
      end
    end

    def on_attached
      self.id = "candidate-list-item-#{candidate.id}"
      candidate.observe do
        self.name = candidate.name
        redraw
      end
    end

    custom_element "candidate-list-item"
  end
end
