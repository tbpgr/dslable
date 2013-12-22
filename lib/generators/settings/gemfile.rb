# encoding: utf-8
require "generators/generators"
require "dslable_dsl"

module Dslable::Generators::Settings
  class Gemfile
    GEMFILE_TEMPLATE =<<-EOF
source 'https://rubygems.org'

gemspec
gem "rspec", "~> 2.14.1"
gem "thor", "~> 0.18.1"
gem "simplecov", "~> 0.8.2"
gem "activesupport", "~> 4.0.1"
gem "activemodel", "~> 4.0.2"
    EOF

    attr_accessor :dsl

    #== initialize dsl model
    #=== Params
    #- _dsl: input from dsl
    def initialize(_dsl)
      raise InvalidDslError.new("dsl not allow nil") if _dsl.nil?
      @dsl = _dsl
    end

    def generate
      File.open("./Gemfile", "w") {|f|f.puts GEMFILE_TEMPLATE}
    end
  end
  class InvalidDslError < StandardError;end
end
