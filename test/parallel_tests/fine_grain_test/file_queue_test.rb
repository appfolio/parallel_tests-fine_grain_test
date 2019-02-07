require 'test_helper'
require 'parallel_tests/fine_grain_test/test_case'
require 'parallel_tests/fine_grain_test/file_queue'

module ParallelTests
  module FineGrainTest
    class FileQueueTest < Minitest::Test
      def setup
        super

        @file_name = File.join(Dir.tmpdir, "file_queue_#{$$}")
        @file_queue = FileQueue.new(@file_name)
        File.unlink(@file_name) if File.exist?(@file_name)
      end

      def test_reset__should_create_file_if_it_does_not_exist
        @file_queue.reset

        assert File.exist?(@file_name)
        assert_equal FileQueue::MARKER, File.read(@file_name).chomp
      end

      def test_reset__should_truncate_file_if_it_exists
        File.write(@file_name, "blah\nblah\nblah")

        @file_queue.reset

        assert File.exist?(@file_name)
        assert_equal FileQueue::MARKER, File.read(@file_name).chomp
      end

      def test_size__should_return_0_when_file_does_not_exist
        assert_equal 0, @file_queue.size
      end

      def test_size__should_return_0_when_empty_file
        File.write(@file_name, "")

        assert_equal 0, @file_queue.size
      end

      def test_size__should_return_0_when_reset
        @file_queue.reset

        assert_equal 0, @file_queue.size
      end

      def test_size__should_return_number_of_lines_in_file
        File.write(@file_name, "one\ntwo\nthree")

        assert_equal 3, @file_queue.size
      end

      def test_enq_all__should_enque_only_after_reset
        test_cases = [
          TestCase.new(self, "one"),
          TestCase.new(self, "two"),
          TestCase.new(self, "three"),
        ]

        @file_queue.reset
        @file_queue.enq_all(test_cases)

        assert_equal 3, @file_queue.size
      end

      def test_enq_all__should_not_enque_when_file_empty
        test_cases = [
          TestCase.new(self, "one"),
          TestCase.new(self, "two"),
          TestCase.new(self, "three"),
        ]

        @file_queue.enq_all(test_cases)

        assert_equal 0, @file_queue.size
      end

      def test_enq_all__should_not_enque_file_already_enqued
        test_cases = [
          TestCase.new(self, "one"),
          TestCase.new(self, "two"),
          TestCase.new(self, "three"),
        ]

        File.write(@file_name, "one\n")
        @file_queue.enq_all(test_cases)

        assert_equal 1, @file_queue.size
      end

      def test_deq__should_return_nil_when_empty
        assert_equal nil, @file_queue.deq
      end

      def test_deq__should_return_nil_when_reset
        @file_queue.reset

        assert_equal nil, @file_queue.deq
      end

      def test_deq__should_remove_and_return_last_case
        File.write(@file_name, "#{self.class.name} one\n#{self.class.name} two\n")

        test_case = @file_queue.deq

        assert_equal self.class, test_case.suite
        assert_equal 'two', test_case.name
        assert_equal 1, @file_queue.size

        test_case = @file_queue.deq

        assert_equal self.class, test_case.suite
        assert_equal 'one', test_case.name
        assert_equal 0, @file_queue.size
      end
    end
  end
end
