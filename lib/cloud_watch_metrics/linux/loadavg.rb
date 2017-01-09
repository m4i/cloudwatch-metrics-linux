# frozen_string_literal: true

module CloudWatchMetrics
  class Linux
    class LoadAvg
      PATH = '/proc/loadavg'

      attr_reader :time

      def initialize
        @time = Time.now
        @data = File.read(PATH).split(/\s+/)
      end

      def loadavg1
        @data.fetch(0).to_f
      end

      def loadavg5
        @data.fetch(1).to_f
      end

      def loadavg15
        @data.fetch(2).to_f
      end
    end
  end
end
