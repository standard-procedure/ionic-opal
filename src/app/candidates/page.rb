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
      puts "Page attached - #{candidate_id}"
      load_candidate
    end

    def load_candidate
      Signal.observe do
        self.full_name = candidate.full_name
        self.first_name = candidate.first_name
        self.last_name = candidate.last_name
        self.email = candidate.email
        redraw
      end
    end

    def account
      assessment.account
    end

    def assessment
      candidate.assessment
    end

    def candidate
      @candidate ||= application.candidates.find candidate_id
    end

    custom_element "candidates-page"
  end
end
