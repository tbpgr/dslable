# encoding: utf-8
require 'generators/generators'

module Dslable::Generators::RSpec
  # Dslable::Generators::RSpec RSpec Template Generator(only execute 'rspec --init')
  class SpecTemplate
    attr_accessor :dsl

    # == initialize generate rspec template
    # === Params
    #- _dsl: input from dsl
    def initialize(_dsl)
      @dsl = _dsl
    end

    # == generate rspec template
    def generate
      `rspec --init`
    end
  end
end
