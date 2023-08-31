module Ui
  class Header < Element
    self.observed_attributes = %i[title]

    def render
      self.inner_html = <<~HTML
        <ion-header>
          <ion-toolbar>
            <ion-buttons slot="start">
              <ion-menu-button></ion-menu-button>
            </ion-buttons>
            <ion-title id="page-title">#{self[:title]}</ion-title>
          </ion-toolbar>
        </ion-header>
      HTML
    end

    custom_element "ui-header"
  end
end
