require "opal"
require "native"
require "promise/v2"
Promise = defined?(PromiseV2) ? PromiseV2 : ::Promise
require "browser/setup/full"
require "dry/inflector"
require "standard_procedure/signal"

require "lib/extensions"
require "lib/browser_extensions"
require "lib/element"
require "lib/async"
require "lib/view_model"
require "application"
