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
    DEFAULT_METRICS = {
      memory_used:        true,
      memory_utilization: true,
      swap_used:          true,
      swap_utilization:   true,
      load_average_1min:  false,
      load_average_5min:  true,
      load_average_15min: false,
    }.freeze

    class << self
      private

      def parse_arguments(args)
        {}.tap do |options|
          option_parser.parse(args, into: options)
          Util.convert_symbol_keys_from_dash_to_underscore!(options)
          options[:metrics] = Util.delete_keys!(options, DEFAULT_METRICS.keys)
        end
      end

      def option_parser
        OptionParser.new do |opt|
          Util.accept_hash(opt)
          opt.on('--namespace <namespace>', String)
          opt.on('--dimensions <name1=value1,name2=value2,...>', Hash)

          DEFAULT_METRICS.each_key do |key|
            opt.on("--[no-]#{key.to_s.tr('_', '-')}", TrueClass)
          end

          opt.on('--interval <seconds>', Float)
          opt.on('--dry-run', TrueClass)
        end
      end
    end

    def initialize(
      namespace:  DEFAULT_NAMESPACE,
      dimensions: {},
      metrics:    {},
      interval:   nil,
      dry_run:    false
    )
      @namespace = namespace
      @dimensions = dimensions
      @metrics = DEFAULT_METRICS.merge(metrics)
      @interval = interval
      @dry_run = dry_run
    end

    private

    def run_once
      metric_data = builder.build(MemInfo.new, LoadAvg.new)
      Util.put_metric_data(@namespace, metric_data, dry_run: @dry_run)
    end

    def builder
      @_builder ||= Builder.new(@dimensions, @metrics)
    end
  end
end
