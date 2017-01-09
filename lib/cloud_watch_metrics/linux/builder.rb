# frozen_string_literal: true

module CloudWatchMetrics
  class Linux
    class Builder
      def initialize(dimensions)
        @dimensions_array = [Dimensions.new(InstanceId: MetaData.instance_id)]
        @dimensions_array << Dimensions.new(dimensions) unless dimensions.empty?
      end

      def build(meminfo, loadavg)
        build_without_dimensions(meminfo, loadavg).flat_map do |metric_datum|
          @dimensions_array.map do |dimensions|
            metric_datum.merge(dimensions: dimensions.to_cloudwatch)
          end
        end
      end

      private

      def build_without_dimensions(meminfo, loadavg)
        metric_data = [memory_used(meminfo), memory_utilization(meminfo)]

        if meminfo.swap?
          metric_data << swap_used(meminfo) << swap_utilization(meminfo)
        end

        metric_data << load_average_1min(loadavg)
      end

      def memory_used(meminfo)
        {
          metric_name: 'MemoryUsed',
          timestamp:   meminfo.time,
          value:       meminfo.mem_used / 1024,
          unit:        'Megabytes',
        }
      end

      def memory_utilization(meminfo)
        {
          metric_name: 'MemoryUtilization',
          timestamp:   meminfo.time,
          value:       (meminfo.mem_util * 100).round(3),
          unit:        'Percent',
        }
      end

      def swap_used(meminfo)
        {
          metric_name: 'SwapUsed',
          timestamp:   meminfo.time,
          value:       meminfo.swap_used / 1024,
          unit:        'Megabytes',
        }
      end

      def swap_utilization(meminfo)
        {
          metric_name: 'SwapUtilization',
          timestamp:   meminfo.time,
          value:       (meminfo.swap_util * 100).round(3),
          unit:        'Percent',
        }
      end

      def load_average_1min(loadavg)
        {
          metric_name: 'LoadAverage1Min',
          timestamp:   loadavg.time,
          value:       loadavg.loadavg1,
          unit:        'Count',
        }
      end
    end
  end
end
