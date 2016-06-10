require_relative 'suite'

module ParallelTests
  module FineGrainTest
    module Minitest
      module Runnable
        def run_one_method(klass, method_name, reporter)
          ::Minitest.fine_grain_suite.add(klass, method_name)
        end
      end

      module Extension
        attr_reader :fine_grain_suite

        def __run(reporter, options)
          ::Minitest::Runnable.singleton_class.prepend Runnable

          @fine_grain_suite = Suite.new
          super(reporter, options)
          @fine_grain_suite.run(reporter, options)
        ensure
          @fine_grain_suite = nil
        end
      end
    end
  end
end
