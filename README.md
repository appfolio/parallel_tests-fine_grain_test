# ParallelTests::FineGrainTest

Normally the `parallel_tests` divvies up the test files between parallel test processes at the
beginning. This causes uneven runtimes as some test processes end up with faster test files while others end up with slower test files. Utilizing past execution times when divving up the tests helps, however, due to differences in test agents and varied execution times (i'm looking at you selenium) it still results in uneven runtimes.

This gem extends the `parallel_tests` gem to enable parallel test processes to pull tests from a global queue until there are no more tests. This results in all parallel test processes being
utilized much more optimally which leads to faster tests.

Tested with,
test-unit / activesupport 3.x
minitest / activesupport 4.x
minitest / activesupport 5.x

## Installation

Add this lines to your application's Gemfile:

```ruby
gem 'parallel_tests'
gem 'parallel_tests-fine_grain_test'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install parallel_tests-fine_grain_test

## Usage

The usage is much like `parallel:test` task.

Example,
```
%> rake parallel:fine_grain_test[^test/selenium]
```

The FINE_GRAIN_TEST_RUNTIME_LOGGER can be optionally set to the location of the file where the test times should be read from / written to. Although optional, it is highly recommended to set FINE_GRAIN_TEST_RUNTIME_LOGGER as it helps the tests complete faster.

## Development

After checking out the repo, run `bundle` to install dependencies. Then, run `rake test` to run the tests.

Note, this gem uses Minitest framework for its own tests but uses the Appraisal gem to test against potentially different version of test-unit and minitest. See the integration tests.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/parallel_tests-fine_grain_test.

