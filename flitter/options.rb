require "optparse"
require "ostruct"

module Flitter
  class Options
    def self.parse(args)
      options = OpenStruct.new

      options.data_file = ''
      options.test_dir = ''

      opts = OptionParser.new do |opts|
        opts.on('-t', '--tests TESTDIRECTORY',
          'Specify the directory containing your tests') do |test_dir|
          options.test_dir = test_dir
        end

        opts.on('-d', '--data DATAFILE',
          'Specify the CSV file containing the data') do |data_file|
          options.data_file = data_file
        end

      end

      opts.parse!(args)

      options
    end
  end
end


