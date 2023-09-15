require "base64"
require_relative "ui/header"
require_relative "ui/menu"
require_relative "ui/icon"
require_relative "page/login"
require_relative "page/dashboard"
require_relative "page/account"
require_relative "page/assessment"

class Application < Element
  property :token
  property :href
  property :name

  def render
    self.inner_html = <<~HTML
      <ion-menu content-id="application-frame" side="start" swipe-gesture="true">
        <ui-menu></ui-menu>
      </ion-menu>
      <ion-router-outlet id="application-frame" swipe-gesture></ion-router-outlet>
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
    on_token_changed nil, nil
  end

  def on_attached
    Application.current = self
    self.token = window.storage[:login_token]
    on_token_changed nil, token
  end

  def on_detached
    off "login-changed"
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
    trigger "login-changed"
    redraw if logged_in?
  end

  custom_element "application-frame"

  class << self
    attr_accessor :current
  end

  class LoginFailed < StandardError
  end
end
