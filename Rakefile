require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "cukemax"
    gem.summary = %Q{Run tests priorited by those that are most likely to fail}
    gem.description = %Q{Run tests priorited by those that are most likely to fail}
    gem.email = "joe@josephwilk.net"
    gem.homepage = "http://www.josephwilk.net"
    gem.authors = ["Joseph Wilk"]

    gem.add_dependency 'httparty', '= 0.5.2'
    gem.add_dependency 'cucumber', '>= 0.8.0'
 
    gem.post_install_message = <<-POST_INSTALL_MESSAGE
POST_INSTALL_MESSAGE
  end

  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: sudo gem install jeweler"
end

Dir['tasks/**/*.rake'].each { |rake| load rake }

task :default => [:specs, :boot, :features]