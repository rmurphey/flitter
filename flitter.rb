require "rubygems"
require "bundler/setup"
require_relative "flitter/dataset"
require_relative "flitter/testset"

ARGV.each do |data_file|
  test_dir = './steps'
  data = Flitter::DataSet.new(data_file)
  data.tests = Flitter::TestSet.new(test_dir)
  data.test
  data.report
end
