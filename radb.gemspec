# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'radb/version'

Gem::Specification.new do |spec|
    spec.name          = "radb"
    spec.version       = Radb::VERSION
    spec.authors       = ["tieubao"]
    spec.email         = ["nntruonghan@gmail.com"]
    spec.summary       = %q{A cli utilities which wrap Android Debug Bridge}
    spec.description   = %q{radb provides some tool that help non-geeks take advantage on android devices}
    spec.homepage      = "https://github.com/tieubao/radb"
    spec.license       = "MIT"

    spec.files         = `git ls-files -z`.split("\x0")
    spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
    spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
    spec.require_paths = ["lib"]

    spec.add_development_dependency "bundler", "~> 1.6"
    spec.add_development_dependency "rake"
    spec.add_dependency 'thor', '>= 0.18'
    spec.add_dependency 'ADB', '>= 0.5'
end
