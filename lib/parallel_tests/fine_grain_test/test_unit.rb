require 'test/unit/autorunner'

Test::Unit::AutoRunner.register_collector(:fine_grain) do |auto_runner|
  require 'parallel_tests/fine_grain_test/test_unit/collector'

  collector = ParallelTests::FineGrainTest::TestUnit::Collector.new
  collector.collect(auto_runner)
end

# Tell auto runner to use our collector.
ARGV << "--collector=fine_grain"
