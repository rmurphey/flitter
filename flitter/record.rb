module Flitter
  class Record
    attr_reader :rejected, :reason

    def initialize(row)
      @row = row
      @rejected = false
      @reason = []
    end

    def run_tests(tests)
      tests.each { |t| run_test(t) }
    end

    def rejected
      @rejected
    end

    def run_test(test)
      match = false

      test.words.each do |word|
        test.fields.each do |field|
          if not self.test(field, word).nil?
            match = true
          end
        end
      end

      if match and test.decision === 'exclude'
        self.send(:reject, test.reason)
      end

      if not match and test.decision === 'include'
        self.send(:reject, test.reason)
      end
    end

    def test(field, word)
      @row[field].match(word)
    end

    def id
      @row['Ref ID']
    end

    private
      def accept
        puts "Accepted #{@row['Ref ID']}" unless @rejected
      end

      def reject(reason = 'unspecified')
        @rejected = true
        @reason << reason
      end
  end
end
