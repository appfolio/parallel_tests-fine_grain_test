require 'test_helper'
require 'bundler'

module ParallelTests
  module FineGrainTest
    class MinitestIntegationTest < Minitest::Test
      def setup
        @runtime_logger = "/tmp/runtime_logger_#{$$}"
        FileUtils.rm_rf(@runtime_logger)
      end

      def teardown
        FileUtils.rm_rf(@runtime_logger)
      end

      def test_activesupport_4_2
        Bundler.with_clean_env do
          result = `appraisal activesupport_4_2 #{cmd} 2>&1`
          assert_minitest_result(result)
        end
      end

      def test_activesupport_4_2__with_runtime_logger
        Bundler.with_clean_env do
          result = `appraisal activesupport_4_2 #{cmd} FINE_GRAIN_TEST_RUNTIME_LOGGER=#{@runtime_logger} 2>&1`
          assert_minitest_result(result)
          assert_runtime_logger(@runtime_logger)
        end
      end

      private

      def assert_runtime_logger(file)
        File.exists?(file)
      end

      def assert_minitest_result(result)
        # two process started?
        assert_includes result, 'test_env_number:1'
        assert_includes result, 'test_env_number:2'

        # all tests run?
        assert_includes result, "\none\n"
        assert_includes result, "\ntwo\n"
        assert_includes result, "\nthree\n"
        assert_includes result, "\nfour\n"

        # each process run at least one test?
        one_and_three = result.include?("\n1 runs,") && result.include?("\n3 runs,")
        two_and_two = result.split(/^2 runs,/).size == 3 # silly way to count 2 occurrences
        assert(one_and_three || two_and_two, result)
      end

      def cmd
        command = [ 'rake' ]
        command << %{-E "require 'parallel_tests/fine_grain_test/tasks'"}
        command << %{parallel:fine_grain_test[2,^test/fixtures/test]}
        command << %{PARALLEL_TEST_FIRST_IS_1=true}
        command.join(' ')
      end
    end
  end
end
