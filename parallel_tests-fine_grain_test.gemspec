# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'parallel_tests/fine_grain_test/version'

Gem::Specification.new do |spec|
  spec.name          = "parallel_tests-fine_grain_test"
  spec.version       = ParallelTests::FineGrainTest::VERSION
  spec.authors       = ["Paul Kmiec"]
  spec.email         = ["paul.kmiec@appfolio.com"]

  spec.summary       = %q{Parallelizes tests dynamically at runtime based on test cases.}
  spec.description   = %q{Parallelizes tests dynamically at runtime based on test cases.}

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
  spec.add_dependency 'parallel_tests', '~> 2.4'

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
end
