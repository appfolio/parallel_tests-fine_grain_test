require 'test_helper'
require 'bundler'

module ParallelTests
  module FineGrainTest
    class IntegationTest < Minitest::Test
      def test_activesupport_3_2
        Bundler.with_clean_env do
          result = `appraisal activesupport_3_2 #{cmd} 2>&1`
          assert_result(result)
        end
      end

      private

      def assert_result(result)
        # two process started?
        assert_includes result, 'test_env_number:1'
        assert_includes result, 'test_env_number:2'

        # all tests run?
        assert_includes result, "\none\n"
        assert_includes result, "\ntwo\n"
        assert_includes result, "\nthree\n"
        assert_includes result, "\nfour\n"

        # each process run at least one test?
        one_and_three = result.include?('1 tests') && result.include?('3 tests')
        two_and_two = result.split(/^2 tests,/).size == 3 # silly way to count 2 occurrences
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
