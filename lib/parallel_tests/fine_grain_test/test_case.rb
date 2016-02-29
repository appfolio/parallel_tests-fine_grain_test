
module ParallelTests
  module FineGrainTest
    class TestCase < Struct.new(:suite, :name)
      def self.encode(test_case)
        [ test_case.suite.name, test_case.name.gsub("\\", "\\\\\\").gsub("\n", "\\n") ].join(' ')
      end

      def self.decode(string)
        suite, name = string.split(/ /, 2)
        name = name.gsub("\\n", "\n").gsub("\\\\", "\\")
        new(Object.module_eval("::#{suite}", __FILE__, __LINE__), name)
      end

      def ==(other)
        other.suite == suite && other.name == name
      end
    end
  end
end
