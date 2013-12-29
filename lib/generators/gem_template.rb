# encoding: utf-8
require 'generators/generators'
require 'fileutils'

module Dslable::Generators
  # Dslable::Generators Gem Template Generator
  class GemTemplate
    attr_accessor :dsl

    # == initialize generate gem template
    # === Params
    #- _dsl: input from dsl
    def initialize(_dsl)
      @dsl = _dsl
    end

    # == generate gem template
    def generate
      `bundle gem #{@dsl._gem_name}`
      Dir.chdir(@dsl._gem_name)
      FileUtils.rm_rf("./lib/#{@dsl._gem_name}.rb")
    end
  end
end
