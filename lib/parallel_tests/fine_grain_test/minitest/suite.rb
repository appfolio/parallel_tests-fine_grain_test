require 'parallel_tests/fine_grain_test/test_case'
require 'parallel_tests/fine_grain_test/file_queue'
require 'parallel_tests/fine_grain_test/runtime_logger'

module ParallelTests
  module FineGrainTest
    module Minitest
      class Suite
        def initialize(file_queue = FileQueue.new, runtime_logger = RuntimeLogger.new)
          @test_cases = []
          @file_queue = file_queue
          @runtime_logger = runtime_logger
        end

        def add(klass, method_name)
          @test_cases << TestCase.new(klass, method_name)
        end

        def run(reporter, _)
          @file_queue.enq_all(@test_cases) do |tcs|
            runtimes = @runtime_logger.runtimes
            @runtime_logger.reset
            tcs.sort_by { |test_case| runtimes[test_case] || 0 }.reverse
          end

          until (test_case = @file_queue.deq).nil?
            @runtime_logger.log_runtime(test_case) do
              reporter.record ::Minitest.run_one_method(test_case.suite, test_case.name)
            end
          end
        end
      end
    end
  end
end
