module Flitter
  class Test
    attr_reader :words, :fields, :decision, :reason

    def initialize(step)
      @test = YAML::load(File.open(step))
      @words = @test['words']
      @fields = @test['fields']
      @decision = @test['decision']
      @reason = @test['reason']
    end

  end
end
