# frozen_string_literal: true

require 'optparse'
require 'irb'

require 'cloud_watch_metrics'
require 'cloud_watch_metrics/linux/builder'
require 'cloud_watch_metrics/linux/loadavg'
require 'cloud_watch_metrics/linux/meminfo'
require 'cloud_watch_metrics/linux/version'

module CloudWatchMetrics
  class Linux
    include Base

    DEFAULT_NAMESPACE = 'System/Linux'

    class << self
      private

      def parse_arguments(args)
        {}.tap do |options|
          option_parser.parse(args, into: options)
          Util.convert_symbol_keys_from_dash_to_underscore!(options)
        end
      end

      def option_parser
        OptionParser.new do |opt|
          Util.accept_hash(opt)
          opt.on('--namespace <namespace>', String)
          opt.on('--dimensions <name1=value1,name2=value2,...>', Hash)
          opt.on('--interval <seconds>', Float)
          opt.on('--dry-run', TrueClass)
        end
      end
    end

    def initialize(
      namespace:  DEFAULT_NAMESPACE,
      dimensions: {},
      interval:   nil,
      dry_run:    false
    )
      @namespace = namespace
      @dimensions = dimensions
      @interval = interval
      @dry_run = dry_run
    end

    private

    def run_once
      metric_data = builder.build(MemInfo.new, LoadAvg.new)
      Util.put_metric_data(@namespace, metric_data, dry_run: @dry_run)
    end

    def builder
      @_builder ||= Builder.new(@dimensions)
    end
  end
end
