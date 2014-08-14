$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|
  s.name        = "pearl_epg_to_xmltv"
  s.version     = "0.0.1"
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Stephen Kenworthy"]
  s.email       = ["steveyken@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{Grabs PearlTV listing and outputs XMLTV file}
  s.description = %q{Produces an XMLTV file of Hong Kong Pearl TV's schedule.}

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {spec}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency('nokogiri')
  s.add_dependency('rake')

  s.add_development_dependency("rspec")
  s.add_development_dependency("awesome_print")
  s.add_development_dependency("debugger")
end
