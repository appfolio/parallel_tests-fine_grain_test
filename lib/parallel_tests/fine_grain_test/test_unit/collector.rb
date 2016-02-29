require 'parallel_tests/fine_grain_test/test_case'
require 'parallel_tests/fine_grain_test/file_queue'
require 'parallel_tests/fine_grain_test/runtime_logger'
require 'parallel_tests/fine_grain_test/test_unit/test_suite'

module ParallelTests
  module FineGrainTest
    module TestUnit
      class Collector
        def collect(auto_runner)
          runtime_logger = RuntimeLogger.new
          test_suite = collect_test_suite(auto_runner)
          file_queue = create_file_queue_from_test_suite(test_suite, runtime_logger)
          create_test_suite_from_file_queue(file_queue, runtime_logger)
        end

        private

        def collect_test_suite(auto_runner)
          auto_runner.send(:default_collector)[auto_runner]
        end

        def create_file_queue_from_test_suite(test_suite, runtime_logger)
          file_queue = FileQueue.new

          test_cases = Set.new
          test_suite_to_test_cases(test_suite, test_cases)

          file_queue.enq_all(test_cases) do |tcs|
            runtimes = runtime_logger.runtimes
            runtime_logger.reset
            tcs.sort_by { |test_case| runtimes[test_case] || 0 }.reverse
          end

          file_queue
        end

        def test_suite_to_test_cases(test_suite, test_cases)
          if test_suite.is_a?(Test::Unit::TestSuite)
            test_suite.tests.each do |test|
              test_suite_to_test_cases(test, test_cases)
            end
          else
            test_cases << TestCase.new(test_suite.class, test_suite.method_name)
          end
        end

        def create_test_suite_from_file_queue(file_queue, runtime_logger)
          TestSuite.new(file_queue, runtime_logger)
        end
      end
    end
  end
end
