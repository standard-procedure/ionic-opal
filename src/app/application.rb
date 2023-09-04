require "base64"
require_relative "ui/header"
require_relative "ui/menu"
require_relative "ui/icon"
require_relative "page/login"
require_relative "page/dashboard"
require_relative "page/account"
require_relative "page/assessments"
require_relative "page/products"

class Application < Element
  property :token
  property :href
  property :name

  def render
    self.inner_html = <<~HTML
      <ion-menu content-id="application-frame">
        <ui-menu></ui-menu>
      </ion-menu>
      <ion-nav id="application-frame" swipe-gesture></ion-nav>
    HTML
  end

  def send method, uri, **params
    Browser::HTTP.send(method, "#{href}#{uri}", **params) do |request|
      if logged_in?
        encoded = Base64.encode64 "USER:#{token}"
        request.headers["Authorization"] = "Basic #{encoded}"
      end
    end
  end

  def logged_in?
    token.present?
  end

  def login_as email, password
    send(:post, "/logins.json", email: email, password: password).then do |response|
      self.token = response.json["reference"]
      on_token_changed nil, token
    end.fail do |error|
      raise LoginFailed.new(error)
    end
  end

  def logout
    self.token = nil
    window.storage[:login_token] = nil
    on_token_changed nil, nil
  end

  def on_attached
    Application.current = self
    self.token = window.storage[:login_token]
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
