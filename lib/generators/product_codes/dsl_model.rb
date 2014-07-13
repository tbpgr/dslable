# encoding: utf-8
require 'generators/generators'
require 'erb'
require 'active_support/inflector'
require 'dslable_dsl'

module Dslable::Generators::ProductCodes
  class DslModel
    DSL_MODEL_TEMPLATE = <<-EOF
# encoding: utf-8
require 'active_model'

# rubocop:disable LineLength
module <%=gem_name_camel%>
  # DslModel
  class DslModel
    include ActiveModel::Model

<%=fields%>
  end
end
# rubocop:enable LineLength
    EOF

    attr_accessor :dsl

    # == initialize dsl model
    # === Params
    #- _dsl: input from dsl
    def initialize(_dsl)
      fail InvalidDslError.new('dsl not allow nil') if _dsl.nil?
      @dsl = _dsl
    end

    def generate
      dsl_model_src = adapt_template(@dsl.camelized_gem_name, get_fields)
      generate_dsl_model_src dsl_model_src
    end

    private
    def get_fields
      fields = []
      @dsl.fields.each do |field|
        field_codes = []
        field_codes << "    # #{field._desc}"
        field_codes << "    attr_accessor :#{field._field_name}"
        field_codes << "    validates :#{field._field_name}, presence: true" if field._args._required
        field_codes << ''
        fields << field_codes.join("\n")
      end
      fields.join("\n")
    end

    def adapt_template(gem_name_camel, fields)
      gem_name = @dsl._gem_name
      erb = ERB.new(DSL_MODEL_TEMPLATE)
      erb.result(binding)
    end

    def generate_dsl_model_src(dsl_model_src)
      File.open("./lib/#{@dsl._gem_name}_dsl_model.rb", 'w') { |f|f.puts dsl_model_src }
    end
  end

  class InvalidDslError < StandardError; end
end
