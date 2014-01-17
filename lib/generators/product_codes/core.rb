# encoding: utf-8
require 'dslable_dsl'
require 'generators/generators'
require 'erb'
require 'active_support/inflector'

module Dslable::Generators::ProductCodes
  class Core
    attr_accessor :dsl
    CORE_TEMPLATE = <<-END
# encoding: utf-8
require '<%=gem_name%>_dsl'

module <%=gem_name_camel%>
  #  <%=gem_name_camel%> Core
  class Core
    <%=gem_name_upper%>_FILE = "<%=dsl_file_name%>"
    <%=gem_name_upper%>_TEMPLATE =<<-EOS
# encoding: utf-8

<%=fields%>
    EOS

    #== generate <%=dsl_file_name%> to current directory.
    def init
      File.open(<%=gem_name_upper%>_FILE, "w") {|f|f.puts <%=gem_name_upper%>_TEMPLATE}
    end

    #== TODO: write your gem's specific contents
    def execute
      src = read_dsl
      dsl = <%=gem_name_camel%>::Dsl.new
      dsl.instance_eval src

      # TODO: implement your gem's specific logic

    end

    private
    def read_dsl
      File.open(<%=gem_name_upper%>_FILE) {|f|f.read}
    end
  end
end
    END

    # == initialize core
    # === Params
    #- _dsl: input from dsl
    def initialize(_dsl)
      fail InvalidDslError.new('dls not allow nil') if _dsl.nil?
      @dsl = _dsl
    end

    def generate
      gem_name_camel = @dsl.camelized_gem_name
      gem_name_upper = @dsl._gem_name.upcase
      dsl_file_name = "#{@dsl._gem_name.camelize.downcase.camelize}file"
      fields = get_fields

      core_src = adapt_template(gem_name_camel, gem_name_upper, dsl_file_name, fields, @dsl._gem_name)
      generate_core_src core_src
    end

    private
    def get_fields
      field_dsls_all = []
      @dsl.fields.each do |field|
        field_dsls = []
        field_dsls << get_field_desc(field)
        field_dsls << get_field_required(field) if field._args._required
        field_dsls << get_field_klass(field)
        field_dsls << get_field_default(field) unless field._args._default_value.nil?
        field_dsls << get_field_call(field)
        field_dsls << ['']
        field_dsls_all << field_dsls.join("\n")
      end
      field_dsls_all.join("\n")
    end

    def get_field_desc(field)
      "# #{field._desc}"
    end

    def get_field_required(field)
      "# #{field._args._args_name} is required"
    end

    def get_field_klass(field)
      "# #{field._args._args_name} allow only #{field._args._klass}"
    end

    def get_field_default(field)
      "# #{field._args._args_name}'s default value => #{get_default(field)}"
    end

    def get_field_call(field)
      "#{field._field_name} #{get_default(field)}"
    end

    def get_default(field)
      klass = field._args._klass
      default_value = field._args._default_value
      if default_value.nil?
        method("nil_default_#{klass.to_s.downcase}").call
      else
        default_value = default_value.to_s.delete!('{').delete!('}') if field._args._klass == Hash
        klass == String ? "\"#{default_value}\"" : default_value
      end
    end

    def nil_default_string
      "\"your value\""
    end

    def nil_default_array
      ['your value']
    end

    def nil_default_hash
      ret = { 'your key' => 'your value' }.to_s.delete!('{').delete!('}')
      ret
    end

    def nil_default_boolean
      false
    end

    def adapt_template(gem_name_camel, gem_name_upper, dsl_file_name, fields, gem_name)
      erb = ERB.new(CORE_TEMPLATE)
      erb.result(binding)
    end

    def generate_core_src(core_src)
      File.open("./lib/#{@dsl._gem_name}_core.rb", 'w') { |f|f.puts core_src }
    end
  end

  class InvalidDslError < StandardError; end
end
