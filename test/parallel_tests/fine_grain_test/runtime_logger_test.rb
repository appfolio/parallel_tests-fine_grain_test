require 'test_helper'
require 'parallel_tests/fine_grain_test/runtime_logger'
require 'parallel_tests/fine_grain_test/test_case'

module ParallelTests
  module FineGrainTest
    class RuntimeLoggerTest < Minitest::Test
      def setup
        super

        @file_name = File.join(Dir.tmpdir, "runtime_logger_#{$$}")
        @logger = RuntimeLogger.new(@file_name)
        File.unlink(@file_name) if File.exist?(@file_name)
      end

      def test_reset__should_create_empty_file_when_one_does_not_exist
        @logger.reset

        assert_equal 0, File.size(@file_name)
      end

      def test_reset__should_create_empty_file_when_one_exists
        File.write(@file_name, "something here")

        @logger.reset

        assert_equal 0, File.size(@file_name)
      end

      def test_log_runtime__should_return_result_of_block
        test_case = TestCase.new(self.class, 'one')

        result = @logger.log_runtime(test_case) { 'hello' }

        assert_equal 'hello', result
      end

      def test_log_runtime__should_time_the_block_and_write_to_file
        test_case = TestCase.new(self.class, 'one')
        RuntimeLogger.stubs(:delta).returns(1.5)

        @logger.log_runtime(test_case) { 'hello' }

        expected = "1.5 ParallelTests::FineGrainTest::RuntimeLoggerTest one\n"
        assert_equal expected, File.read(@file_name)
      end

      def test_log_runtime__should_append_runtimes_to_existing_ones
        File.write(@file_name, "1.5 ParallelTests::FineGrainTest::RuntimeLoggerTest one\n")
        test_case = TestCase.new(self.class, 'two')
        RuntimeLogger.stubs(:delta).returns(2.5)

        @logger.log_runtime(test_case) { 'hello' }

        expected = "1.5 ParallelTests::FineGrainTest::RuntimeLoggerTest one\n" \
                   "2.5 ParallelTests::FineGrainTest::RuntimeLoggerTest two\n"
        assert_equal expected, File.read(@file_name)
      end

      def test_runtime__should_return_empty_when_file_empty
        result = @logger.runtimes

        assert result.empty?
      end

      def test_runtime__should_return_test_cases_to_times_from_file
        test_case_one = TestCase.new(self.class, 'one')
        test_case_two = TestCase.new(self.class, 'two')
        File.write(@file_name,
                   "1.5 ParallelTests::FineGrainTest::RuntimeLoggerTest one\n" \
                   "2.5 ParallelTests::FineGrainTest::RuntimeLoggerTest two\n")

        result = @logger.runtimes

        assert_equal 2, result.size
        assert_equal 1.5, result[test_case_one]
        assert_equal 2.5, result[test_case_two]
      end
    end
  end
end
