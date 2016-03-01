require 'rake'

namespace :parallel do
  desc "run test in parallel (fine grain parallelism) with parallel:fine_grain_test[num_cpus]"
  task :fine_grain_test, [:count, :pattern, :options] do |t, args|
    require 'parallel_tests/tasks'
    ParallelTests::Tasks.check_for_pending_migrations

    $LOAD_PATH << File.expand_path(File.join(File.dirname(__FILE__), '..'))
    require 'parallel_tests/fine_grain_test'

    count, pattern, options = ParallelTests::Tasks.parse_args(args)
    executable = File.join(File.dirname(__FILE__), '../../../bin/parallel_fine_grain_test')

    command = "#{Shellwords.escape executable} test --type fine_grain_test " \
      "-n #{count} --pattern '#{pattern}' --verbose " \
      "--test-options '#{options}'"
    abort unless system(command) # allow to chain tasks e.g. rake parallel:spec parallel:features
  end
end

