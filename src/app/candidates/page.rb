class Candidates
  class Page < Element
    property :name
    property :full_name
    property :first_name
    property :last_name
    property :email

    def render
      inner_dom do |dom|
        dom.e "ui-header", title: "Candidates"
        dom.e "ion-content", class: "ion-padding" do
          dom.e "ion-list" do
            candidates.each do |candidate|
              dom.e "ion-item", href: "/candidates/#{candidate["id"]}" do
                dom.e "ion-label" do
                  candidate.full_name.to_s
                end
              end
            end
          end
        end
      end
    end

    def on_attached
      redraw
    end

    custom_element "candidates-page"
  end
end
