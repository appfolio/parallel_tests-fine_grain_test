msg = "FineGrainTest pid:#{$$} " \
      "tid:#{Thread.current.object_id} " \
      "test_env_number:#{ENV['TEST_ENV_NUMBER']}"

puts msg
Rails.logger.info msg if defined?(Rails)

if defined?(Minitest::Runnable) # Minitest 5
  require 'parallel_tests/fine_grain_test/minitest'
elsif defined?(MiniTest::Unit) # Minitest 4
  raise NotImplementedError.new("FineGrainTest does not currently support Minitest 4")
elsif defined?(Test::Unit)
  require 'parallel_tests/fine_grain_test/test_unit'
else # WAT?
  raise "Count not detect Minitest or TestUnit"
end
