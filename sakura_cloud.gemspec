# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sakura_cloud/version'

Gem::Specification.new do |spec|
  spec.name          = "sakura_cloud"
  spec.version       = SakuraCloud::VERSION
  spec.authors       = ["Takeyuki FUJIOKA", "Yasuharu OZAKI"]
  spec.email         = ["xibbar@gmail.com"]
  spec.description   = %q{Sakura Cloud API Tool}
  spec.summary       = %q{Sakura Cloud API Tool}
  spec.homepage      = "http://github.com/xibbar/sakura_cloud"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "multi_json"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake", "~> 10.1"
  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency "webmock", "~> 1.12"
end
