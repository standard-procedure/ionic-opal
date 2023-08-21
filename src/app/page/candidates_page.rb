class CandidatesPage < Element
  self.observed_attributes = %i[]

  def initialize node
    super node
    @candidates = []
  end

  def render
    inner_dom do |dom|
      dom.e "ui-header", title: "Candidates"
      dom.e "ion-content", class: "ion-padding" do
        dom.e "ion-list" do
          @candidates.each do |candidate|
            dom.e "ion-item", href: "/candidates/#{candidate["id"]}" do
              dom.e "ion-label" do
                candidate["name"].to_s
              end
            end
          end
        end
      end
    end
  end

  def on_attached
    Application.current.send(:get, "/candidates.json").then do |response|
      @candidates = response.json
      redraw
    end
  end

  custom_element "candidates-page"
end
