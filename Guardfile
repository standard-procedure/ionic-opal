directories %w[src]

guard :standardrb, fix: true, all_on_start: false, progress: true do
  watch /.+\.rb$/
end

guard :livereload do
  watch /.+\.rb$/
  watch /.+\.html$/
  watch /.+\.css$/
end
