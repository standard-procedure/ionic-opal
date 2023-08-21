class UiHeader < Element
  self.observed_attributes = %i[title]

  def render
    self.inner_html = <<~HTML
      <ion-header>
        <ion-toolbar>
          <ion-back-button></ion-back-button>
          <ion-title id="page-title">#{self[:title]}</ion-title>
        </ion-toolbar>
      </ion-header>
    HTML
  end

  def on_changed attribute, old_value, new_value
    redraw
  end

  custom_element "ui-header"
end
