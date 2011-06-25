module Flitter
  class Test
    attr_reader :words, :fields, :decision, :reason

    def initialize(yaml)
      @test = YAML::load(yaml)
      @words = @test['words']
      @fields = @test['fields']
      @decision = @test['decision']
      @reason = @test['reason']
    end

  end
end
