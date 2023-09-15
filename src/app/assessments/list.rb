module Assessments
  class List < Element
    property :account_id, type: :integer
    property :assessments, type: :array, default: []
    property :page_number, type: :integer, default: 1

    def render
      inner_dom do |dom|
        dom.e "ion-content", class: "ion-padding" do
          dom.e "ion-list", id: "assessments-list" do
            if assessments.any?
              dom.e "ion-list-header" do
                dom.e "ion-label" do
                  "Assesssments"
                end
              end
              assessments.map(&:peek).each do |assessment|
                render_item assessment, dom
              end
            else
              dom.e "ion-list-header" do
                dom.e "ion-label" do
                  "No Assesssments"
                end
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

    def on_attached
      load_assessments.then do
        redraw
      end
    end

    def render_item assessment, dom
      dom.e "ion-item", href: "/assessments/#{assessment["id"]}" do
        dom.e "ion-label" do
          assessment["title"].to_s
        end
      end
    end

    def load_assessments
      Promise.new.tap do |promise|
        Application.current.fetch(:get, "/accounts/#{account_id}/assessments.json?page=#{page_number}").then do |response|
          self.assessments = response.json
          promise.resolve response.json
        end
      end
    end

    def load_next_page event
      self.page_number = page_number + 1
      load_assessments.then do |data|
        at_css("#assessments-list").add_child do |dom|
          data.each do |item|
            render_item item, dom
          end
        end
        Native.call event.target.to_n, :complete
        event.target[:disabled] = (data.count == 0)
      end
    end

    custom_element "assessments-list"
  end
end
