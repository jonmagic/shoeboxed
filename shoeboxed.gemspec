# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "shoeboxed/version"

Gem::Specification.new do |s|
  s.name        = "shoeboxed"
  s.version     = Shoeboxed::VERSION
  s.authors     = ["Jonathan Hoyt"]
  s.email       = ["jonmagic@gmail.com"]
  s.homepage    = "http://github.com/jonmagic/shoeboxed"
  s.summary     = %q{Wrap the http://shoeboxed.com API and make it not hurt.}
  s.description = %q{Shoeboxed is a simple ruby client for the http://shoeboxed.com API, handy for storing and processing documents like receipts and business cards.}

  s.rubyforge_project = "shoeboxed"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_runtime_dependency "httmultiparty"
end
