require_relative "list_item"

class Assessments
  class List < Element
    property :account, type: :ruby
    property :assessments, type: :array
    property :page_number, type: :integer, default: 1
    property :list, type: :ruby

    def render
      inner_dom do |dom|
        dom.ion_content class: "ion-padding" do
          dom.ion_list do
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
          end.created do |l|
            self.list = l
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
      load_assessments
    end

    def load_assessments
      Signal.observe do
        self.assessments = account.assessments.get
        redraw
      end
    end

    def render_item assessment, dom
      dom.assessment_list_item.created do |i|
        i.account = account
        i.assessment = assessment
      end
    end

    def load_next_page
      self.page_number = page_number + 1
      load_assessments.then do |results|
        list.add_child do |dom|
          results.each do |assessment|
            render_item assessment, dom
          end
        end
        data
      end
    end

    custom_element "assessments-list"
  end
end
