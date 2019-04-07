
module ParallelTests
  module FineGrainTest
    class TestCase < Struct.new(:suite, :name)
      def self.encode(test_case)
        [ test_case.suite.name, test_case.name.gsub("\\", "\\\\\\").gsub("\n", "\\n") ].join(' ')
      end

      def self.decode(string)
        suite, name = string.split(/ /, 2)
        name = name.gsub("\\n", "\n").gsub("\\\\", "\\")
        suite_object = begin
                         Object.module_eval("::#{suite}", __FILE__, __LINE__)
                       rescue NameError
                         nil
                       end
        new(suite_object, name) if suite_object
      end

      def ==(other)
        other.suite == suite && other.name == name
      end
    end
  end
end
