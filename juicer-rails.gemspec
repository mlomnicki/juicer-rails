# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "juicer-rails/version"

Gem::Specification.new do |s|
  s.name        = "juicer-rails"
  s.version     = JuicerRails::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Michał Łomnicki"]
  s.email       = ["michal.lomnicki@gmail.com"]
  s.homepage    = "https://github.com/mlomnicki/juicer-rails"
  s.summary     = "Rails helpers for Juicer"
  s.description = "Juicer-rails adds helpers for easy embedding juicer-packaged assets"

  s.rubyforge_project = "juicer-rails"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency("juicer", "~> 1.0")
  s.add_dependency("actionpack", ">= 2")
end
