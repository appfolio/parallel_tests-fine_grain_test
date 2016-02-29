# ParallelTests::FineGrainTest

Normally the `parallel_tests` divvies up the test files between parallel test processes at the
beginning. This causes uneven runtimes as some test processes end up with faster test files while others end up with slower test files. Utilizing past execution times when divving up the tests helps, however, due to differences in test agents and varied execution times (i'm looking at you selenium) it still results in uneven runtimes.

This gem extends the `parallel_tests` gem to enable parallel test processes to pull tests from a global queue until there are no more tests. This results in all parallel test processes being
utilized much more optimally which leads to faster tests.

Currently, only test-unit / activesupport 3.2 is supported.

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

Since this gem overrides the normal `parallel:test` task, there really isn't much to it. However,
one should set the FINE_GRAIN_TEST_RUNTIME_LOGGER to the location of the file in which to record
test times.

Example,
```
%> FINE_GRAIN_TEST_RUNTIME_LOGGER=test/profiles/seleium.log rake parallel:test[^test/selenium]
%> FINE_GRAIN_TEST_RUNTIME_LOGGER=test/profiles/unit.log rake parallel:test[^test/unit]
```

Setting FINE_GRAIN_TEST_RUNTIME_LOGGER is optional, but it highly recommended.

## Development

After checking out the repo, run `bundle` to install dependencies. Then, run `rake test` to run the tests.

Note, this gem uses Minitest framework for its own tests but uses the Appraisal gem to test against potentially different version of test-unit and minitest. See integration_test.rb.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/parallel_tests-fine_grain_test.

