require 'test_helper'
require 'parallel_tests/fine_grain_test/test_case'

module ParallelTests
  module FineGrainTest
    class TestCaseTest < Minitest::Test
      def test_encode__should_handle_spaces
        test_case = TestCase.new(self.class, 'hello there')

        expected = 'ParallelTests::FineGrainTest::TestCaseTest hello there'
        assert_equal expected, TestCase.encode(test_case)
      end

      def test_decode__should_handle_spaces
        str = 'ParallelTests::FineGrainTest::TestCaseTest hello there'

        test_case = TestCase.decode(str)
        assert_equal self.class, test_case.suite
        assert_equal 'hello there', test_case.name
      end

      def test_encode__should_handle_newlines
        test_case = TestCase.new(self.class, "hello\nthere")

        expected = "ParallelTests::FineGrainTest::TestCaseTest hello\\nthere"
        assert_equal expected, TestCase.encode(test_case)
      end

      def test_decode__should_handle_newlines
        str = "ParallelTests::FineGrainTest::TestCaseTest hello\\nthere"

        test_case = TestCase.decode(str)
        assert_equal self.class, test_case.suite
        assert_equal "hello\nthere", test_case.name
      end

      def test_encode__should_handle_backslashes
        test_case = TestCase.new(self.class, "hello\\there")

        expected = "ParallelTests::FineGrainTest::TestCaseTest hello\\\\there"
        assert_equal expected, TestCase.encode(test_case)
      end

      def test_decode__should_handle_backslashes
        str = "ParallelTests::FineGrainTest::TestCaseTest hello\\\\there"

        test_case = TestCase.decode(str)
        assert_equal self.class, test_case.suite
        assert_equal "hello\\there", test_case.name
      end
    end
  end
end
