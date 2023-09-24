require_relative "list_item"

class Candidates
  class List < Element
    property :account, type: :ruby
    property :assessment, type: :ruby
    property :page_number, type: :integer, default: 1
    property :candidates, type: :array, default: []
    property :list, type: :ruby

    def render
      inner_dom do |dom|
        dom.ion_list do
          if candidates.any?
            dom.ion_list_header do
              dom.ion_label { "Candidates" }
            end
            candidates.each do |candidate|
              render_candidate candidate, dom
            end
          else
            dom.ion_list_header do
              dom.ion_label { "No candidates" }
            end
          end
        end.created do |list|
          self.list = list
        end

        dom.ion_infinite_scroll do
          dom.ion_infinite_scroll_content
        end.on "ionInfinite" do |event|
          load_next_page.then do |results|
            event.target.complete
            event.target[:disabled] = results.empty?
          end
        end
      end
    end

    def render_candidate candidate, dom
      dom.candidate_list_item.created do |i|
        i.candidate = candidate
      end
    end

    def on_attached
      load_candidates
    end

    def load_candidates
      Signal.observe do
        self.candidates = assessment.candidates.get
        redraw
      end
    end

    def load_next_page
      self.page_number = page_number + 1
      application.candidates.where(assessment: assessment, page: page_number).then do |results|
        list.add_child do |dom|
          results.each do |candidate|
            render_candidate candidate, dom
          end
        end
        results
      end
    end

    custom_element "candidates-list"
  end
end
