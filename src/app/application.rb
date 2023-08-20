require_relative "page/login_page"
require_relative "page/dashboard_page"

class Application < Element
  self.observed_attributes = %i[token href name]

  def render
    inner_dom do |dom|
      dom.e "ion-app" do
        if self[:token].nil?
          dom.e "login-page"
        else
          dom.e "ion-router-outlet"
        end
      end
    end
  end

  def login_as email, password
    Browser::HTTP.post("#{self[:href]}/logins.json", email: email, password: password).then do |response|
      self[:token] = response.json["reference"]
      window.storage[:login_token] = self[:token]
    end.fail do |error|
      puts error.inspect
    end
  end

  def on_attached
    Application.current = self
    self[:token] = window.storage[:login_token]
  end

  def on_detached
    Application.current = nil
  end

  def on_changed attribute, old_value, new_value
    redraw
  end

  custom_element "application-frame"

  class << self
    attr_accessor :current
  end
end
