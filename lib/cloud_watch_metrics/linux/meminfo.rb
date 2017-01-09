# frozen_string_literal: true

module CloudWatchMetrics
  class Linux
    class MemInfo
      PATH = '/proc/meminfo'

      attr_reader :time

      def initialize
        @time = Time.now
        @data = File.readlines(PATH)
          .map { |line| /^([^:]+):\s+(\d+)/.match(line)&.captures }
          .compact
          .map { |key, value| [key, value.to_i] }
          .to_h
      end

      def mem_total
        @data.fetch('MemTotal')
      end

      def mem_free
        @data.fetch('MemFree')
      end

      def cached
        @data.fetch('Cached')
      end

      def buffers
        @data.fetch('Buffers')
      end

      def swap_total
        @data.fetch('SwapTotal')
      end

      def swap_free
        @data.fetch('SwapFree')
      end

      def mem_avail
        mem_free + cached + buffers
      end

      def mem_used
        mem_total - mem_avail
      end

      def mem_util
        mem_used.to_f / mem_total
      end

      def swap?
        swap_total.positive?
      end

      def swap_used
        swap_total - swap_free
      end

      def swap_util
        swap_used.to_f / swap_total
      end
    end
  end
end
