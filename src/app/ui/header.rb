module Ui
  class Header < Element
    property :title

    def render
      self.inner_html = <<~HTML
        <ion-header>
          <ion-toolbar>
            <ion-buttons slot="start">
              <ion-menu-button></ion-menu-button>
            </ion-buttons>
            <ion-title id="page-title">#{title}</ion-title>
          </ion-toolbar>
        </ion-header>
      HTML
    end

    custom_element "ui-header"
  end
end
