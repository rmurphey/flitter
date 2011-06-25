require 'csv'
require_relative 'record'

module Flitter
  class DataSet
    HEADERS = [
      "Ref Type",
      "Ref ID",
      "Title",
      "Authors",
      "Pub Date",
      "Notes",
      "Keywords",
      "Reprint",
      "Start Page",
      "End Page",
      "Journal",
      "unk1",
      "unk2",
      "Volume",
      "unk3",
      "unk4",
      "Issue",
      "unk5",
      "unk6",
      "unk7",
      "unk8",
      "unk9",
      "unk10",
      "unk11",
      "unk12",
      "unk13",
      "Abstract"
    ]

    def initialize(data_file)
      @records = CSV.read(data_file, :headers => HEADERS).map do |row|
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
      @records.each do |r|
        if r.rejected
          puts "Rejected #{r.id}: #{r.reason}"
        else
          puts "Accepted #{r.id}"
        end
      end
    end
  end
end
