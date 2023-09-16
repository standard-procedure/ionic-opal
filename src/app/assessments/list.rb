module Assessments
  class List < Element
    property :account_id, type: :integer
    property :assessments, type: :array, default: []
    property :page_number, type: :integer, default: 1

    def render
      inner_dom do |dom|
        dom.ion_content class: "ion-padding" do
          dom.ion_list id: "assessments-list" do
            if assessments.any?
              dom.ion_list_header do
                dom.ion_label { "Assesssments" }
              end
              assessments.each do |assessment|
                render_item assessment, dom
              end
            else
              dom.ion_list_header do
                dom.ion_label { "No Assesssments" }
              end
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

    def on_attached
      load_assessments.then do
        redraw
      end
    end

    def render_item assessment, dom
      dom.ion_item href: "/assessments/#{assessment["id"]}" do
        dom.ion_label do
          assessment["title"].to_s
        end
      end
    end

    def load_assessments
      promise do
        application.fetch(:get, "/accounts/#{account_id}/assessments.json?page=#{page_number}").then do |response|
          self.assessments = response.json
          response.json
        end
      end
    end

    def load_next_page
      self.page_number = page_number + 1
      load_assessments.then do |data|
        at_css("#assessments-list").add_child do |dom|
          data.each do |item|
            render_item item, dom
          end
        end
        data
      end
    end

    custom_element "assessments-list"
  end
end
