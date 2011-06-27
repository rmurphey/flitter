module Flitter
  class Record
    attr_reader :rejected, :id, :reject_reason

    def initialize(row)
      @row = row
      @id = row[1]

      @rejected = false
      @marks = []

      @reject_reason = ''
    end

    def run_tests(tests)
      tests.each { |t| self.send(:run_test, t) }
    end

    def to_csv
      if @rejected
        @row.push("rejected: #{reject_reason}")
      end

      @row.to_csv
    end

    private
      def run_test(test)
        scores = Hash.new
        reasons_to_act = 0

        test.words.each do |word|
          matches = 0

          clean_word = word.sub(/^NOT /, '')

          test.fields.each do |field|
            if self.send(:test, field, clean_word)
              matches += 1
            end
          end

          scores[word] = matches
        end

        scores.keys.each do |k|
          puts "scores for #{k}: #{scores[k]}"

          invert = !k.match(/^NOT /).nil?

          if invert
            if scores[k] == 0
              reasons_to_act += 1
            end
          else
            if scores[k] > 0
              reasons_to_act += 1
            end
          end
        end

        if test.mark and reasons_to_act > 0
          self.send(:mark, test)
        elsif reasons_to_act > 0
          self.send(:reject, test)
        else
          self.send(:accept, test)
        end
      end

      def test(field, word)
        !@row[field].downcase.match(word.downcase).nil?
      end

      def accept(test)
        puts "#{@id} was not rejected for #{test.reason}"
        # @accept_reasons << reason
      end

      def reject(test)
        puts "#{@id} rejected for #{test.reason}"

        if not @rejected
          @rejected = true
          @reject_reason = test.reason
          test.log_match
        end
      end

      def mark(test)
        @marks << "#{@id} #{test.mark}: #{test.reason}"
        puts @marks.last
      end
  end
end
