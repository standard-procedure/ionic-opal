require "bundler"
Bundler.require
require "opal"

require "opal-browser"
Opal.append_path "src/app"
Opal.use_gem "standard-procedure-signal"
require "opal/rspec/rake_task"
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
  File.binwrite "www/application.js", Opal::Builder.build("environment").to_s
  `cp src/index.html www/index.html`
  `cp src/styles.css www/styles.css\ncp -r src/assets www/ `
end

Opal::RSpec::RakeTask.new(:spec) do |server, task|
  server.append_path "src/app"
  task.default_path = "spec"
  task.requires = ["spec_helper"]
  task.files = FileList["spec/**/*_spec.rb"]
  task.runner = :server
end
