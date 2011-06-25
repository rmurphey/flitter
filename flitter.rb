require "rubygems"
require "bundler/setup"
require_relative "flitter/options"
require_relative "flitter/dataset"
require_relative "flitter/testset"

options = Flitter::Options.parse(ARGV)
data = Flitter::DataSet.new(options.data_file, options.header_file)
data.tests = Flitter::TestSet.new(options.test_dir)

data.test
data.report
