module Candidates
  class List < Element
    property :assessment_id, type: :integer
    property :page_number, type: :integer, default: 1
    property :candidates, type: :array, default: []

    def render
      inner_dom do |dom|
        dom.e "ion-content", class: "ion-padding" do
          @candidate_list = dom.e "ion-list", id: "candidates-list" do
            if candidates.any?
              dom.e "ion-list-header" do
                dom.e "ion-label" do
                  "Candidates"
                end
              end
              candidates.map(&:get).each do |candidate|
                render_candidate candidate, dom
              end
            else
              dom.e "ion-list-header" do
                dom.e "ion-label" do
                  "No candidates"
                end
              end
            end
            dom.e "ion-infinite-scroll" do
              dom.e "ion-infinite-scroll-content"
            end.on "ionInfinite" do |event|
              load_next_page(event)
            end
          end
        end
      end
    end

    def render_candidate candidate, dom
      dom.e("ion-item", href: "/candidates/#{candidate["id"]}") do
        dom.e "ion-label" do
          candidate["name"].to_s
        end
      end
    end

    def on_attached
      load_candidates.then do
        redraw
      end
    end

    def load_candidates
      Promise.new.tap do |promise|
        Application.current.fetch(:get, "/assessments/#{assessment_id}/candidates.json?page=#{page_number}").then do |response|
          self.candidates = candidates + response.json
          promise.resolve response.json
        end
      end
    end

    def load_next_page event
      self.page_number = page_number + 1
      load_candidates.then do |data|
        at_css("#candidates-list").add_child do |dom|
          data.each do |candidate|
            render_candidate candidate, dom
          end
        end
        Native.call event.target.to_n, :complete
        event.target[:disabled] = (data.count == 0)
      end
    end

    custom_element "candidates-list"
  end
end
