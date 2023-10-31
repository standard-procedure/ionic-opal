module Ui
  class Header < Element
    property :title
    property :back_href

    def render
      self.inner_html = <<~HTML
        <ion-header>
          <ion-toolbar>
            <ion-buttons slot="start">
              #{"<ion-back-button default-href='#{back_href}'></ion-back-button>" unless back_href.blank?}
            </ion-buttons>
            <ion-title id="page-title">#{title}</ion-title>
            <ion-buttons slot="end">
              <ion-menu-button></ion-menu-button>
            </ion-buttons>
          </ion-toolbar>
        </ion-header>
      HTML
    end

    custom_element "ui-header"
  end
end
