require 'csv'
require_relative 'record'

module Flitter
  class DataSet
    def initialize(data_file, header_file)
      @headers = File.read(header_file).split("\n")
      @records = CSV.read(data_file, :headers => @headers).map do |row|
        Flitter::Record.new(row)
      end
    end

    def tests=(tests)
      @tests = tests
    end

    def test
      @records.map { |r| r.run_tests(@tests) }
    end

    def report
      accepted = @records.count{ |r| !r.rejected }
      rejected = @records.count - accepted
      sorted_tests = @tests.sort { |x, y| y.matches <=> x.matches }

      File.open("report.csv", "w") do |file|
        file.write(@headers.to_csv)

        @records.each { |r| file.write(r.to_csv) }
        @records.each { |r| puts "#{r.id} #{r.reject_reason}" }

        puts "\n"

        puts "#{accepted} accepted / #{rejected} rejected / #{@records.length} total"

        puts "\n"
        file.write("\n")

        sorted_tests.each do |test|
          puts "#{test.matches} #{test.reason}"
          file.write([ test.matches, test.reason ].to_csv)
        end

        file.close
      end
    end
  end
end
