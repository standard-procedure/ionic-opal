module Ui
  class Icon < Element
    self.observed_attributes = %i[name]

    def render
      self.inner_html = <<~HTML
        <ion-icon src="#{icon_path}"></ion-icon>
      HTML
    end

    def icon_path
      "/assets/icons/#{MAP[self[:name]]}.svg"
    end

    MAP = {
      dashboard: "diagram-3-fill",
      log_out: "box-arrow-in-left"
    }.freeze

    custom_element "ui-icon"
  end
end
