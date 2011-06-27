module Flitter
  class Test
    attr_reader :words, :fields, :decision, :reason, :mark, :matches

    def initialize(yaml)
      @matches = 0

      @test = YAML::load(yaml)
      @words = @test['words']
      @fields = @test['fields']
      @reason = @test['reason']
      @mark = @test['mark']
    end

    def log_match
      @matches = matches + 1;
    end
  end
end
