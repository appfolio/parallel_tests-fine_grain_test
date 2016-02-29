require 'test/unit/testsuite'

module ParallelTests
  module FineGrainTest
    module TestUnit
      class TestSuite < Test::Unit::TestSuite

        def initialize(file_queue = nil, runtime_logger = nil)
          super("Fine Grain Test")
          @file_queue = file_queue
          @runtime_logger = runtime_logger

          @tests = self
        end

        def <<(test)
          raise NotImplementedError
        end

        def delete(test)
          raise NotImplementedError
        end

        def delete_tests(tests)
          raise NotImplementedError
        end

        def size
          @file_queue ? @file_queue.size : 0
        end

        def shift
          test_case = @file_queue ? @file_queue.deq : nil
          if test_case
            test_suite = Test::Unit::TestSuite.new(test_case.suite.name)
            test_suite << test_case.suite.new(test_case.name)
            test_suite
          end
        end

        protected

        def run_test(test_suite, result)
          if @runtime_logger
            test_case = test_suite.tests.first
            test_case = TestCase.new(test_case.class, test_case.method_name)

            @runtime_logger.log_runtime(test_case) do
              super(test_suite, result)
            end
          else
            super(test_suite, result)
          end
        end

      end
    end
  end
end
