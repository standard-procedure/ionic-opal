require_relative "ui/header"
require_relative "page/login_page"
require_relative "page/dashboard_page"
require_relative "page/profile_page"

class Application < Element
  self.observed_attributes = %i[token href name]

  def render
    self.inner_html = <<~HTML
      <ion-nav root="dashboard-page">
      </ion-nav>
    HTML
  end

  def login_as email, password
    Browser::HTTP.post("#{self[:href]}/logins.json", email: email, password: password).then do |response|
      self[:token] = response.json["reference"]
      on_token_changed nil, self[:token]
    end.fail do |error|
      raise LoginFailed.new(error)
    end
  end

  def logout
    self[:token] = nil
    window.storage[:login_token] = nil
    on_token_changed nil, nil
  end

  def on_attached
    Application.current = self
    self[:token] = window.storage[:login_token]
  end

  def on_detached
    Application.current = nil
  end

  def on_token_changed old_value, new_value
    window.storage[:login_token] = new_value
    if new_value.present?
      document["login-guard"][:from] = "/login"
      document["login-guard"][:to] = "/"
    else
      document["login-guard"][:from] = "*"
      document["login-guard"][:to] = "/login"
    end
    redraw
  end

  custom_element "application-frame"

  class << self
    attr_accessor :current
  end

  class LoginFailed < StandardError
  end
end
