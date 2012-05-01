$LOAD_PATH.unshift File.expand_path("../lib", __FILE__)
require "limited_red/version"

Gem::Specification.new do |s|
  s.name = %q{limited_red}
  s.version = LimitedRed::Version::STRING
  s.platform    = Gem::Platform::RUBY
  s.license     = "MIT"
  s.authors = ["Joseph Wilk"]
  s.homepage = "http://www.limited-red.com"
  s.description = %q{Learn and adapt from you test metrics. Used with the www.limited-red.com service. Tests are priorited by the probability of failure}
  s.summary = %q{Client for www.limited-red.com service}
  s.email = %q{joe@josephwilk.net}
  s.extra_rdoc_files = [
    "LICENSE",
     "README.md"
  ]
  s.files        = Dir.glob("{lib}/**/*")   
  s.rdoc_options     = ["--charset=UTF-8"]
  s.require_paths = ["lib"]

  s.add_runtime_dependency(%q<httparty>, ["= 0.8.1"])
  s.add_runtime_dependency(%q<cucumber>, [">= 1.1.4"])
end

