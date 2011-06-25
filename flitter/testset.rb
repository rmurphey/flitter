require_relative 'test'

module Flitter
  class TestSet
    include Enumerable

    def initialize(test_dir)
      @tests = []

      Dir.entries(test_dir).each do |file|
        file = File.join(test_dir, file)
        @tests << Flitter::Test.new(file) unless File.directory?(file)
      end
    end

    def each
      @tests.each { |t| yield t }
    end
  end
end
