
Gem::Specification.new do |s|
  s.name = %q{limited-red}
  s.version = "0.2.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Joseph Wilk"]
  s.date = %q{2010-09-14}
  s.description = %q{Run tests priorited by those that are most likely to fail}
  s.email = %q{joe@josephwilk.net}
  s.extra_rdoc_files = [
    "LICENSE",
     "README.rdoc"
  ]
  s.files = []
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{Run tests priorited by those that are most likely to fail}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<httparty>, ["= 0.5.2"])
      s.add_runtime_dependency(%q<cucumber>, [">= 0.8.0"])
    else
      s.add_dependency(%q<httparty>, ["= 0.5.2"])
      s.add_dependency(%q<cucumber>, [">= 0.8.0"])
    end
  else
    s.add_dependency(%q<httparty>, ["= 0.5.2"])
    s.add_dependency(%q<cucumber>, [">= 0.8.0"])
  end
end

