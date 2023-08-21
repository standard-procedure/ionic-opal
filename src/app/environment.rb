require "opal"
require "native"
require "promise/v2"
Promise = defined?(PromiseV2) ? PromiseV2 : ::Promise
require "browser/setup/full"
require "lib/extensions"
require "lib/element"
require "application"
