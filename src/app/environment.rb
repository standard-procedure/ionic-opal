require "opal"
require "native"
require "promise/v2"
Promise = defined?(PromiseV2) ? PromiseV2 : ::Promise
require "browser/setup/full"

class Browser::DOM::Node
  def value
    `#{@native}.value || nil`
  end
end

require "lib/element"
require "lib/await"
require "application"
