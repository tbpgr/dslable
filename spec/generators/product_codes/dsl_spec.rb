# encoding: utf-8
require "spec_helper"
require "generators/product_codes/dsl"
require "dslable_dsl"

describe Dslable::Generators::ProductCodes::Dsl do

  context :generate do
    OUTPUT_DSL_TMP_DIR = "generate_dsl"
    OUTPUT_DSL_CASE1 =<<-EOF
# encoding: utf-8
require 'sample_gem_dsl_model'

module SampleGem
  class Dsl
    attr_accessor :sample_gem

    # String Define
    [:field1, :field4].each do |f|
      define_method f do |value|
        eval "@sample_gem.#\{f.to_s} = '#\{value}'", binding
      end
    end

    # Array/Hash Define
    [:field2, :field3, :field5, :field6].each do |f|
      define_method f do |value|
        eval "@sample_gem.#\{f.to_s} = #\{value}", binding
      end
    end

    def initialize
      @sample_gem = SampleGem::DslModel.new
      @sample_gem.field1 = 'default1'
      @sample_gem.field2 = ["default1", "default2"]
      @sample_gem.field3 = {:default_key=>"default_value"}
    end
  end
end
    EOF

    cases = [
      {
        case_no: 1,
        case_title: "generate",
        gem_name: "sample_gem",
        fields: [:field1, :field2, :field3, :field4, :field5, :field6],
        fields_descs: ["field_desc1", "field_desc2", "field_desc3", "field_desc4", "field_desc5", "field_desc6"],
        args: [:args1, :args2, :args3, :args4, :args5, :args6],
        args_klass: [String, Array, Hash, String, Array, Hash],
        args_required: [true, true, true, false, false, false],
        args_default: ["default1", ["default1", "default2"], {default_key: "default_value"}, nil, nil, nil],
        expected_file: "./lib/sample_gem_dsl.rb",
        expected_contents: OUTPUT_DSL_CASE1

      },
    ]

    cases.each do |c|
      it "|case_no=#{c[:case_no]}|case_title=#{c[:case_title]}" do
        begin
          case_before c

          # -- given --
          dsl = Dslable::Dsl.new
          gen_dsl = Dslable::Generators::ProductCodes::Dsl.new(setup_dsl(c, dsl))

          # -- when --
          gen_dsl.generate

          # -- then --
          actual = File.open(c[:expected_file]) {|f|f.read}
          expect(actual).to eq(c[:expected_contents])
        ensure
          case_after c

        end
      end

      def case_before(c)
        # implement each case before
        Dir.mkdir(OUTPUT_DSL_TMP_DIR) unless Dir.exists? OUTPUT_DSL_TMP_DIR
        Dir.chdir(OUTPUT_DSL_TMP_DIR)
        Dir.mkdir "lib"
      end

      def setup_dsl(c, dsl)
        dsl.gem_name c[:gem_name]
        c[:fields].each_with_index do |field, i|
          dsl.field c[:fields][i] do |f|
            f.desc c[:fields_descs][i]
            f.args c[:args][i] do |a|
              a.klass c[:args_klass][i]
              a.required if c[:args_required][i]
              a.default_value c[:args_default][i]
            end
          end
        end
        dsl
      end

      def case_after(c)
        # implement each case after
        Dir.chdir("../")
        FileUtils.rm_rf(OUTPUT_DSL_TMP_DIR) if Dir.exists? OUTPUT_DSL_TMP_DIR
      end
    end
  end

end
