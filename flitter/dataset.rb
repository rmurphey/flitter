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
      File.open("report.csv", "w") do |file|

        file.write(@headers.to_csv)

        @records.each do |r|
          if r.rejected
            puts "Rejected #{r.id}: #{r.reject_reasons}"
          else
            puts "Accepted #{r.id}: #{r.accept_reasons}"
          end

          file.write(r.to_csv)
        end

        file.close

        accepted = @records.count{ |r| !r.rejected }
        rejected = @records.count - accepted

        puts "#{accepted} accepted / #{rejected} rejected / #{@records.length} total"

      end
    end
  end
end
