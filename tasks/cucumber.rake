begin
  require 'cucumber'
  require 'cucumber/rake/task'

  desc "Run all features"
  Cucumber::Rake::Task.new(:features) do |t|
    t.cucumber_opts = "features --format pretty"
  end
rescue
end