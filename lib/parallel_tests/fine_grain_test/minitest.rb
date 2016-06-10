require 'minitest/autorun'
require_relative 'minitest/extension'

Minitest.singleton_class.prepend ::ParallelTests::FineGrainTest::Minitest::Extension

