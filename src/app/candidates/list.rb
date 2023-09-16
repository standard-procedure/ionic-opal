module Candidates
  class List < Element
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
      dom.ion_item href: "/candidates/#{candidate["id"]}" do
        dom.ion_label do
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
      promise do
        application.fetch(:get, "/assessments/#{assessment_id}/candidates.json?page=#{page_number}").then do |response|
          self.candidates = candidates + response.json
          response.json
        end
      end
    end

    def load_next_page
      self.page_number = page_number + 1
      load_candidates.then do |data|
        at_css("#candidates-list").add_child do |dom|
          data.each do |candidate|
            render_candidate candidate, dom
          end
        end
        data
      end
    end

    custom_element "candidates-list"
  end
end
