require 'fileutils'
require 'parallel_tests/fine_grain_test/test_case'

module ParallelTests
  module FineGrainTest
    class RuntimeLogger
      class << self
        def now
          if Time.respond_to?(:now_without_mock_time) # Timecop
            Time.now_without_mock_time
          else
            Time.now
          end
        end

        def delta
          before = now.to_f
          yield
          now.to_f - before
        end
      end

      def initialize(file_name = ENV['FINE_GRAIN_TEST_RUNTIME_LOGGER'])
        @file_name = file_name
      end

      def reset
        lock do |f|
          f.pos = 0
          f.truncate(0)
        end
      end

      def runtimes
        times = {}
        lock do |f|
          lines = f.read.split(/\n/)
          lines.each do |line|
            time, test_case = line.split(/ /, 2)
            next unless time and test_case

            time = time.to_f
            test_case = TestCase.decode(test_case)
            times[test_case] = time
          end
        end
        times
      end

      def log_runtime(test_case)
        result = nil
        time = self.class.delta { result = yield }
        log(test_case, time)
        result
      end

      private

      def log(test_case, time)
        lock do |f|
          f.seek(0, :END)
          f.puts [ time, TestCase.encode(test_case) ].join(' ')
        end
      end

      def lock
        return unless @file_name

        FileUtils.mkdir_p(File.dirname(@file_name))
        File.open(@file_name, File::RDWR|File::CREAT) do |f|
          begin
            f.flock File::LOCK_EX
            yield(f)
          ensure
            f.flock File::LOCK_UN
          end
        end
      end
    end
  end
end
