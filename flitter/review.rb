require "csv"
require "flitter/record"
require "flitter/test"

module Flitter
  class LitReview
      def initialize(data_file)
        @tests = []
        @records = []

        read_tests
        read_data
        do_tests
      end

    private
      def read_data(data_file)
        CSV.read(data_file, :headers => HEADERS).each do |row|
          @records << Flitter::Record.new(row)
        end
      end

      def read_tests(dir = "./steps")
        steps = Dir.new(dir)

        steps.each do |step|
          if not File.directory?(step)
            @tests << Flitter::Test.new(step)
          end
        end
      end

      def do_tests
        @records.each { |r| r.run_tests(@tests) }
      end
  end
end
