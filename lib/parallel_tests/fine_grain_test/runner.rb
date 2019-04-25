require 'parallel_tests/test/runner'
require 'parallel_tests/fine_grain_test/file_queue'

module ParallelTests
  module FineGrainTest
    class Runner < ParallelTests::Test::Runner
      class << self
        def run_tests(_, process_number, num_processes, options)
          require_list = @@tests.map { |file| file.sub(" ", "\\ ") }.join(" ")
          test_helper = File.expand_path("../test_helper", __FILE__)
          cmd = "#{executable} -Itest -e '%w[#{require_list}].each { |f| " \
                "require %{./\#{f}}; require %{#{test_helper}}; " \
                "}' -- #{options[:test_options]}"
          execute_command(cmd, process_number, num_processes, options)
        end

        def tests_in_groups(tests, num_groups, options={})
          ParallelTests::FineGrainTest::FileQueue.new.reset

          results = super
          @@tests = results.flatten
          (1..num_groups).map { |group_number| ["fake_test_#{group_number}.rb"] }
        end
      end
    end
  end
end