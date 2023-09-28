require_relative "list_item"

class Candidates
  class ReportsList < Element
    property :candidate, type: :ruby
    property :reports, type: :array, default: []

    def render
      inner_dom do |dom|
        dom.ion_list do
          if reports.any?
            dom.ion_list_header do
              dom.ion_label { "Reports" }
            end
            reports.each do |report|
              dom.ion_item do
                dom.ion_label { report[:title] }
                dom.ion_button slot: "end", download: true, href: report_url_for(report) do
                  dom.ion_icon slot: "icon-only", name: "download-outline"
                end
              end
            end
          else
            dom.ion_list_header do
              dom.ion_label { "No reports" }
            end
          end
        end
      end
    end

    def report_url_for report
      "https://www.aqrtest.com/course/participants/#{candidate.token}/reports/#{report[:id]}.pdf"
    end

    custom_element "reports-list"
  end
end
