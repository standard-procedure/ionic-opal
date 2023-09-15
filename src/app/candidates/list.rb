module Candidates
  class List < Element
    property :assessment_id, type: :integer
    property :page_number, type: :integer, default: 1
    property :candidates, type: :array, default: []
    attr_reader :list

    def render
      inner_dom do |dom|
        dom.e "ion-content", class: "ion-padding" do
          dom.e "ion-list" do
            if candidates.any?
              dom.e "ion-list-header" do
                dom.e "ion-label" do
                  "Candidates"
                end
              end
              candidates.map(&:get).each do |candidate|
                dom.e "ion-item", href: "/candidates/#{candidate["id"]}" do
                  dom.e "ion-label" do
                    candidate["name"].to_s
                  end
                end
              end
              dom.e "ion-infinite-scroll" do
                dom.e "ion-infinite-scroll-content"
              end.on "ionInfinite" do |event|
                self.page_number = page_number + 1
                load_candidates.then do |count|
                  Native.call event.target.to_n, :complete
                  event.target[:disabled] = (count == 0)
                end
              end
            else
              dom.e "ion-list-header" do
                dom.e "ion-label" do
                  "No candidates"
                end
              end
            end
          end
        end
      end
    end

    def on_attached
      load_candidates
    end

    def load_candidates
      Promise.new.tap do |promise|
        Application.current.fetch(:get, "/assessments/#{assessment_id}/candidates.json?page=#{page_number}").then do |response|
          self.candidates = candidates + response.json
          redraw
          promise.resolve response.json.count
        end
      end
    end

    custom_element "candidates-list"
  end
end
