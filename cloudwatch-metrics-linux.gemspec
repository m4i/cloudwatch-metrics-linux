# frozen_string_literal: true

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cloud_watch_metrics/linux/version'

Gem::Specification.new do |spec|
  spec.name          = 'cloudwatch-metrics-linux'
  spec.version       = CloudWatchMetrics::Linux::VERSION
  spec.authors       = ['Masaki Takeuchi']
  spec.email         = ['m.ishihara@gmail.com']

  spec.summary       = 'Send meminfo and loadavg to CloudWatch Metrics'
  spec.homepage      = 'https://github.com/m4i/cloudwatch-metrics-linux'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.13'
  spec.add_development_dependency 'rake', '~> 12.0'
  spec.add_development_dependency 'rubocop', '>= 0.46'
end
