module Flitter
  class Record
    attr_reader :rejected, :accept_reasons, :reject_reasons, :id

    def initialize(row)
      @row = row
      @id = row[1]

      @rejected = false

      @reject_reasons = []
      @accept_reasons = []
    end

    def run_tests(tests)
      tests.each { |t| self.send(:run_test, t) }
    end

    def to_csv
      @row.push(@accept_reasons)
      @row.push(@reject_reasons)

      if rejected
        @row.push('rejected')
      end

      @row.to_csv
    end

    private
      def run_test(test)
        match = false

        test.words.each do |word|
          test.fields.each do |field|
            if not self.send(:test, field, word).nil?
              match = true
            end
          end
        end

        if test.decision === 'exclude'
          if match
            self.send(:reject, test.reason)
          else
            self.send(:accept, test.reason)
          end
        end

        if test.decision === 'include'
          if match
            self.send(:accept, test.reason)
          else
            self.send(:reject, test.reason)
          end
        end
      end

      def test(field, word)
        @row[field].downcase.match(word.downcase)
      end

      def accept(reason = 'unspecified')
        @accept_reasons << reason
      end

      def reject(reason = 'unspecified')
        @rejected = true
        @reject_reasons << reason
      end
  end
end
