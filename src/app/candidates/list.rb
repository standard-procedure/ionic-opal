class Candidates
  class List < Element
    property :account_id, type: :integer
    property :assessment_id, type: :integer
    property :page_number, type: :integer, default: 1
    property :candidates, type: :array, default: []

    def render
      inner_dom do |dom|
        dom.ion_content class: "ion-padding" do
          dom.ion_list id: "candidates-list" do
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
            dom.ion_infinite_scroll do
              dom.ion_infinite_scroll_content
            end.on "ionInfinite" do |event|
              load_next_page.then do |data|
                event.target.complete
                event.target[:disabled] = data.empty?
              end
            end
          end
        end
      end
    end

    def render_candidate candidate, dom
      dom.candidate_list_item assessment_id: assessment.id, candidate_id: candidate.id
    end

    def on_attached
      load_candidates.then do
        redraw
      end
    end

    def load_candidates
      promise do
        assessment.candidates.where(page: page_number).then do |results|
          self.candidates = candidates + results
          results
        end
      end
    end

    def load_next_page
      self.page_number = page_number + 1
      load_candidates.then do |results|
        at_css("#candidates-list").add_child do |dom|
          results.each do |candidate|
            render_candidate candidate, dom
          end
        end
        results
      end
    end

    def account
      @account ||= application.accounts.find account_id
    end

    def assessment
      @assessment ||= account.assessments.find assessment_id
    end

    custom_element "candidates-list"
  end
end
