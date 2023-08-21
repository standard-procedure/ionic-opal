require_relative "page/login_page"
require_relative "page/dashboard_page"
require_relative "page/profile_page"

class Application < Element
  self.observed_attributes = %i[token href name]

  def render
    inner_dom do |dom|
      if self[:token].blank?
        dom.e "login-page"
      else
        dom.e "ion-router-outlet"
      end
    end
  end

  def login_as email, password
    Browser::HTTP.post("#{self[:href]}/logins.json", email: email, password: password).then do |response|
      self[:token] = response.json["reference"]
    end.fail do |error|
      raise LoginFailed.new(error)
    end
  end

  def logout
    self[:token] = nil
    window.storage[:login_token] = nil
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
