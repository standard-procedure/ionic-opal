class Candidates
  class ListItem < Element
    property :candidate, type: :ruby
    property :name

    def render
      inner_dom do |dom|
        dom.ion_item href: "/candidates/#{candidate.id}" do
          dom.ion_label { name }
        end
      end
    end

    def on_attached
      self.id = "candidate-list-item-#{candidate.id}"
      observe_candidate
    end

    def observe_candidate
      Signal.observe do
        self.name = candidate.name
        redraw
      end
    end

    custom_element "candidate-list-item"
  end
end
