require 'rake'

Rake::Task["parallel:test"].clear

namespace :parallel do
  ['test'].each do |type|
    desc "run #{type} in parallel with parallel:#{type}[num_cpus]"
    task type.to_sym, [:count, :pattern, :options] do |t, args|
      ParallelTests::Tasks.check_for_pending_migrations

      $LOAD_PATH << File.expand_path(File.join(File.dirname(__FILE__), '..'))
      require 'parallel_tests/fine_grain_test'

      count, pattern, options = ParallelTests::Tasks.parse_args(args)
      executable = File.join(File.dirname(__FILE__), '../../../bin/parallel_fine_grain_test')

      command = "#{Shellwords.escape executable} #{type} --type fine_grain_test " \
        "-n #{count} --pattern '#{pattern}' --verbose " \
        "--test-options '#{options}'"
      abort unless system(command) # allow to chain tasks e.g. rake parallel:spec parallel:features
    end
  end
end

