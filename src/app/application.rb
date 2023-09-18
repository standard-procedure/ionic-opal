require "base64"
require_relative "ui/header"
require_relative "ui/menu"
require_relative "ui/icon"
require_relative "account"
require_relative "login/page"
require_relative "dashboard/page"
require_relative "accounts/page"
require_relative "assessments/page"

class Application < Element
  property :token
  property :href
  property :name

  def initialize node
    super node
    @accounts = {}
  end

  def render
    self.inner_html = <<~HTML
      <ion-menu content-id="application-frame" side="start" swipe-gesture="true">
        <ui-menu></ui-menu>
      </ion-menu>
      <ion-router-outlet id="application-frame" swipe-gesture></ion-router-outlet>
    HTML
  end

  def fetch method, uri, **params
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
    fetch(:post, "/logins.json", email: email, password: password).then do |response|
      self.token = response.json["reference"]
      on_token_changed nil, token
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

  def account id, auto_load: true
    id = id.to_i
    if @accounts[id].nil?
      @accounts[id] = Account.new id: id
      if auto_load
        next_tick do
          fetch(:get, "/account/#{id}.json").then do |response|
            @accounts[id].set response.json
          end
        end
      end
    end
    @accounts[id]
  end

  def accounts page: 1
    promise do
      fetch(:get, "/accounts.json?page=#{page}").then do |response|
        response.json.collect do |data|
          account(data["id"], auto_load: false).set data
        end
      end
    end
  end

  custom_element "application-frame"

  class << self
    attr_reader :current

    def current= value
      @current = value
      $window.to_n.JS[:application] = value # standard:disable Style/GlobalVars
    end
  end

  class LoginFailed < StandardError
  end
end
