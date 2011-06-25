require_relative 'test'

module Flitter
  class TestSet
    include Enumerable

    def initialize(test_dir)
      @tests = []

      Dir.entries(test_dir).each do |file|
        if not File.directory?(file)
          file = File.read(File.join(test_dir, file))

          file.split("\n\n").each do |yaml|
            @tests << Flitter::Test.new(yaml)
          end
        end
      end
    end

    def each
      @tests.each { |t| yield t }
    end
  end
end
