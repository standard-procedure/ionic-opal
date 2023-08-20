require "bundler"
Bundler.require
require "opal"
require "opal-browser"

Opal::Config.source_map_enabled = true
Opal::Config.esm = false

desc "Lint the app"
task :lint do
  `bundle exec standardrb src\/**\/*.rb --fix`
  `bundle exec standardrb Gemfile --fix`
  `bundle exec standardrb Rakefile --fix`
  `bundle exec standardrb config.ru --fix`
end

desc "Build the app"
task :build do
  Opal.append_path "src/app"
  File.binwrite "www/index.js", Opal::Builder.build("environment").to_s
  `cp src/index.html www/index.html`
  `cp src/styles.css www/styles.css\ncp -r src/assets www/ `
end
