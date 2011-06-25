require "rubygems"
require "bundler/setup"
require "csv"

class LitReview
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
      @tests = []
      @records = []

      steps = Dir.new("./steps")

      steps.each do |step|
        if not File.directory?(step)
          @tests << generate_test_from_step(step)
        end
      end

      CSV.read(data_file, :headers => HEADERS).each do |row|
        @records << LitSearchRecord.new(row)
      end

      @records.map! do |record|
        if not record.rejected
          @tests.each do |test|
            test.call(record)
          end
        end
      end
    end

  private
    def generate_test_from_step(step)
      rule = YAML::load(File.open(step))

      lambda do |record|
        match = false

        rule['words'].each do |word|
          rule['fields'].each do |field|
            if record.test(field, word).nil?
              match = false
            else
              match = true
            end
          end
        end

        if match
          if rule['decision'] === 'include'
            record.accept
          end

          if rule['decision'] === 'exclude'
            record.reject(rule['reason'])
          end
        end
      end
    end
end

class LitSearchRecord
  attr_accessor :rejected

  def initialize(row)
    @row = row
    @rejected = false
  end

  def test(field, word)
    @row[field].match(word)
  end

  def rejected
    @rejected
  end

  def accept
    puts "Accepted #{@row['Ref ID']}" unless @rejected
  end

  def reject(reason = 'unspecified')
    @rejected = true
    puts "Rejected #{@row['Ref ID']} because #{reason}"
  end
end

ARGV.each do |data_file|
  LitReview.new(data_file)
end
