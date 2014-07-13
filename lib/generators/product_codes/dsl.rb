# encoding: utf-8
require 'generators/generators'
require 'erb'
require 'active_support/inflector'
require 'dslable_dsl'

module Dslable::Generators::ProductCodes
  class Dsl
    DSL_TEMPLATE = <<-EOF
# encoding: utf-8
require '<%=gem_name%>_dsl_model'

module <%=gem_name_camel%>
  # Dsl
  class Dsl
    attr_accessor :<%=gem_name%>

    # String Define
    [<%=string_fields%>].each do |f|
      define_method f do |value|
        @<%=gem_name%>.send("\#{f}=", value)
      end
    end

    # Array/Hash/Boolean Define
    [<%=array_hash_fields%>].each do |f|
      define_method f do |value|
        @<%=gem_name%>.send("\#{f}=", value)
      end
    end

    def initialize
      @<%=gem_name%> = <%=gem_name_camel%>::DslModel.new
<%=set_defaults%>
    end
  end
end
    EOF

    attr_accessor :dsl

    # == initialize dsl
    # === Params
    #- _dsl: input from dsl
    def initialize(_dsl)
      fail InvalidDslError.new('dsl not allow nil') if _dsl.nil?
      @dsl = _dsl
    end

    def generate
      dsl_src = adapt_template(@dsl.camelized_gem_name, get_string_fields, get_other_fields, get_set_defaults)
      generate_dsl_src dsl_src
    end

    private
    def get_string_fields
      fields = []
      @dsl.fields.each do |field|
        fields << ":#{field._field_name}" if field._args._klass == String
      end
      fields.join(', ')
    end

    def get_other_fields
      fields = []
      @dsl.fields.each do |field|
        fields << ":#{field._field_name}" unless field._args._klass == String
      end
      fields.join(', ')
    end

    def get_set_defaults
      set_defaults = []
      gem_name = @dsl._gem_name
      @dsl.fields.each_with_index do |field, index|
        next if field._args._default_value.nil?
        default_value = field._args._klass == String ? "'#{field._args._default_value}'" : field._args._default_value
        set_defaults << "      @#{gem_name}.#{field._field_name} = #{default_value}"
      end
      set_defaults.join("\n")
    end

    def adapt_template(gem_name_camel, string_fields, array_hash_fields, set_defaults)
      gem_name = @dsl._gem_name
      erb = ERB.new(DSL_TEMPLATE)
      erb.result(binding)
    end

    def generate_dsl_src(dsl_src)
      File.open("./lib/#{@dsl._gem_name}_dsl.rb", 'w') { |f|f.puts dsl_src }
    end
  end

  class InvalidDslError < StandardError; end
end
