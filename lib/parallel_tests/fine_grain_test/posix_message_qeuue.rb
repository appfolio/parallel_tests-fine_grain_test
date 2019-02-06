require 'parallel_tests/fine_grain_test/test_case'
require 'posix/mqueue'

module ParallelTests
  module FineGrainTest
    QUEUE_NAME = '/parallel_tests-fine_grain'
    class PosixMessageQueue
      def reset
        message_queue.unlink
      end

      def enq_all(test_cases)
        messages = test_cases.map { |test_case| TestCase.encode(test_case) }
        messages.each_with_index { |message, i| puts i; message_queue.send message }
      end

      def deq
        message_qeuue.timedreceive.force_encoding('utf8')
      rescue POSIX::Mqueue::QueueEmpty
        nil
      end

      private

      def message_queue
        @message_queue ||= POSIX::Mqueue.new(QUEUE_NAME, msgsize: 8192, maxmsg: 65536)
      end
    end
  end
end
