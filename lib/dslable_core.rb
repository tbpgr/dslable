require "dslable/version"
require "dslable_field"
require "dslable_args"
require "dslable_dsl"
require "generators/gem_template"
require "generators/product_codes/cli"
require "generators/product_codes/core"
require "generators/product_codes/dsl"
require "generators/product_codes/dsl_model"
require "generators/rspec/spec_template"
require "generators/rspec/specs"
require "generators/settings/gemfile"

module Dslable
  class Core
    DSLDEFINE_FILE = "Dsldefine"

    DSLDEFINE_TEMPLATE =<<-EOS
# encoding: utf-8

# set your gem name. this is use in rb-filename and class-name
gem_name "TODO: set your gem_name"

# set your bin name
bin_name "TODO: set your bin_name"

# set your dsl filed
field :field_name1 do |f|
  # set your field description
  f.desc "field1 description"
  f.args :args_name do |a|
    # set your args description
    a.desc "args description"
    # you can use String, Array and Hash
    a.klass String
    # if you want not required, comment out following line
    a.required
    # if you comment out following line, default => nil
    a.default_value "args_value2"
  end
end

# field :field_name2 do |f|
#   f.desc "field2 description"
#   f.args :args_name do |a|
#     a.desc "args description"
#     a.klass String
#     a.required
#     a.default_value "args_value2"
#   end
# end
    EOS

    def init
      File.open(DSLDEFINE_FILE, "w") {|f|f.puts DSLDEFINE_TEMPLATE}
    end

    def generate
      src = read_dsl_define
      # DSLからパラメータの取得
      dsl = Dslable::Dsl.new
      dsl.instance_eval src
      Dslable::Generators::GemTemplate.new(dsl).generate
      Dslable::Generators::Settings::Gemfile.new(dsl).generate
      Dslable::Generators::ProductCodes::Core.new(dsl).generate
      Dslable::Generators::ProductCodes::Dsl.new(dsl).generate
      Dslable::Generators::ProductCodes::DslModel.new(dsl).generate
      Dslable::Generators::ProductCodes::CLI.new(dsl).generate
      Dslable::Generators::RSpec::SpecTemplate.new(dsl).generate
      Dslable::Generators::RSpec::Specs.new(dsl).generate
    end

    private
    def read_dsl_define
      File.open(DSLDEFINE_FILE) {|f|f.read}
    end
  end

end
