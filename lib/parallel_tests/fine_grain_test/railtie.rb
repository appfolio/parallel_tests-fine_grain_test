# rake tasks for Rails 3+
module ParallelTests
  class Railtie < ::Rails::Railtie
    rake_tasks do
      require 'parallel_tests/fine_grain_test/tasks'
    end
  end
end
