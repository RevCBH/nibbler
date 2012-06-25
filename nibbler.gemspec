# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "nibbler/version"

Gem::Specification.new do |s|
  s.name        = "rm-nibbler"
  s.version     = Nibbler::VERSION
  s.authors     = ["Bennett Hoffman"]
  s.email       = ["benn.hoffman@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{Nibbler lets you easily consume .nib files with RubyMotion}
  s.description = %q{Nibbler lets you easily consume .nib files with RubyMotion}

  s.rubyforge_project = "nibbler"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  # s.add_development_dependency "rspec"
  # s.add_runtime_dependency "rest-client"
end
