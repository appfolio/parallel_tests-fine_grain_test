require 'parallel_tests/fine_grain_test/test_case'

module ParallelTests
  module FineGrainTest
    class FileQueue
      FILE_NAME = '.test.queue'.freeze
      MARKER = '--POPULATE--'.freeze

      def initialize(file_name = FILE_NAME)
        @file_name = file_name
      end

      def reset
        lock do |file|
          rewrite(file, [ MARKER ])
        end
      end

      def enq_all(test_cases)
        lock do |file|
          return if already_populated?(file)

          test_cases = yield(test_cases) if block_given?

          lines = test_cases.map { |test_case| TestCase.encode(test_case) }.reverse
          rewrite(file, lines)
        end
      end

      def deq
        lock do |file|
          contents = file.read
          lines = contents.split(/\n/)
          return nil if lines.empty? || lines[0].chomp == MARKER

          new_size = contents.bytesize - lines.last.bytesize - 1
          file.truncate new_size

          return TestCase.decode(lines.last.chomp)
        end
      end

      def size
        lock do |file|
          lines = file.read.split(/\n/)
          if lines.empty? || lines[0].chomp == MARKER
            return 0
          else
            return lines.size
          end
        end
      end

      private

      def rewrite(file, lines)
        file.pos = 0
        file.truncate(0)
        lines.each do |line|
          file.puts(line)
        end
      end

      def already_populated?(file)
        lines = file.read.split(/\n/)
        return true if lines.empty?

        lines[0].chomp != MARKER
      end

      def lock
        File.open(@file_name, File::RDWR|File::CREAT) do |f|
          begin
            f.flock File::LOCK_EX
            yield(f)
          ensure
            f.flock File::LOCK_UN
          end
        end
      end
    end
  end
end
