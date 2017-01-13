# frozen_string_literal: true

module CloudWatchMetrics
  class Linux
    class Builder
      def initialize(dimensions, metrics)
        @dimensions_array = [Dimensions.new(InstanceId: MetaData.instance_id)]
        @dimensions_array << Dimensions.new(dimensions) unless dimensions.empty?

        @metric_names = metrics.select { |_, v| v }.keys
      end

      def build(meminfo, loadavg)
        @meminfo = meminfo
        @loadavg = loadavg

        build_without_dimensions.flat_map do |metric_datum|
          @dimensions_array.map do |dimensions|
            metric_datum.merge(dimensions: dimensions.to_cloudwatch)
          end
        end
      end

      private

      def build_without_dimensions
        @metric_names.map { |key| __send__(key) }.compact
      end

      def memory_used
        {
          metric_name: 'MemoryUsed',
          timestamp:   @meminfo.time,
          value:       @meminfo.mem_used / 1024,
          unit:        'Megabytes',
        }
      end

      def memory_utilization
        {
          metric_name: 'MemoryUtilization',
          timestamp:   @meminfo.time,
          value:       (@meminfo.mem_util * 100).round(3),
          unit:        'Percent',
        }
      end

      def swap_used
        return unless @meminfo.swap?
        {
          metric_name: 'SwapUsed',
          timestamp:   @meminfo.time,
          value:       @meminfo.swap_used / 1024,
          unit:        'Megabytes',
        }
      end

      def swap_utilization
        return unless @meminfo.swap?
        {
          metric_name: 'SwapUtilization',
          timestamp:   @meminfo.time,
          value:       (@meminfo.swap_util * 100).round(3),
          unit:        'Percent',
        }
      end

      def load_average_1min
        {
          metric_name: 'LoadAverage1Min',
          timestamp:   @loadavg.time,
          value:       @loadavg.loadavg1,
          unit:        'Count',
        }
      end

      def load_average_5min
        {
          metric_name: 'LoadAverage5Min',
          timestamp:   @loadavg.time,
          value:       @loadavg.loadavg5,
          unit:        'Count',
        }
      end

      def load_average_15min
        {
          metric_name: 'LoadAverage15Min',
          timestamp:   @loadavg.time,
          value:       @loadavg.loadavg15,
          unit:        'Count',
        }
      end
    end
  end
end
