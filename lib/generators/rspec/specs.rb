# encoding: utf-8
require 'generators/generators'

module Dslable::Generators::RSpec
  # Dslable::Generators::RSpec Specs Generator specs
  class Specs
    attr_accessor :dsl

    # == initialize generate specs
    # === Params
    #- _dsl: input from dsl
    def initialize(_dsl)
      @dsl = _dsl
    end

    # == generate specs
    def generate
      generate_core
    end

    def generate_core
      core_class_name = "#{@dsl.camelized_gem_name}::Core"
      core_class_file_name = "#{@dsl._gem_name}_core"
      `piccolo e #{core_class_name} #{core_class_file_name} init execute`
    end
  end
end
