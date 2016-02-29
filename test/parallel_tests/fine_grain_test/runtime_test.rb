require 'test_helper'
require 'parallel_tests/fine_grain_test/runner'

module ParallelTests
  module FineGrainTest
    class RunnerTest < Minitest::Test
      def test_tests_in_groups__should_capture_all_tests_files
        Dir.chdir('test/fixtures') do
          Runner.tests_in_groups(['test'], 2)

          expected = ['test/one_test.rb', 'test/two_test.rb',
                      'test/three_test.rb', 'test/four_test.rb']
          assert_equal expected.sort, Runner.class_variable_get(:@@tests).sort
        end
      end

      def test_run_tests__should_require_all_captured_test_files_despite_of_files_passed_in
        all_files = ['test/one_test.rb', 'test/two_test.rb',
                     'test/three_test.rb', 'test/four_test.rb']
        two_files = ['test/one_test.rb', 'test/two_test.rb']
        Runner.class_variable_set(:@@tests, all_files)

        root_path = File.expand_path('../../../..', __FILE__)
        cmd = "ruby -Itest -e '" \
              "%w[test/one_test.rb test/two_test.rb test/three_test.rb test/four_test.rb]" \
              ".each { |f| require %{./\#{f}}; " \
              "require %{#{root_path}/lib/parallel_tests/fine_grain_test/test_helper}; }" \
              "' -- -v"
        Runner.expects(:execute_command).with(cmd, 0, 2, { test_options: '-v' })
        Runner.run_tests(two_files, 0, 2, { test_options: '-v' })
      end
    end
  end
end
