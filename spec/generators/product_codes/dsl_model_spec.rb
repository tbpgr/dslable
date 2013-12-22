# encoding: utf-8
require "spec_helper"
require "generators/product_codes/dsl_model"

describe Dslable::Generators::ProductCodes::DslModel do

  context :generate do
    OUTPUT_DSL_MODEL_TMP_DIR = "generate_dsl_model"
    OUTPUT_DSL_MODEL_CASE1 =<<-EOF
# encoding: utf-8
require 'active_model'

module SampleGem
  class DslModel
    include ActiveModel::Model

    # field_desc1
    attr_accessor :field1
    validates :field1, :presence => true

    # field_desc2
    attr_accessor :field2
    validates :field2, :presence => true

    # field_desc3
    attr_accessor :field3
    validates :field3, :presence => true

    # field_desc4
    attr_accessor :field4

    # field_desc5
    attr_accessor :field5

    # field_desc6
    attr_accessor :field6

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
        expected_file: "./lib/sample_gem_dsl_model.rb",
        expected_contents: OUTPUT_DSL_MODEL_CASE1
      },
    ]

    cases.each do |c|
      it "|case_no=#{c[:case_no]}|case_title=#{c[:case_title]}" do
        begin
          case_before c

          # -- given --
          dsl = Dslable::Dsl.new
          gen_dsl_model = Dslable::Generators::ProductCodes::DslModel.new(setup_dsl(c, dsl))

          # -- when --
          gen_dsl_model.generate

          # -- then --
          actual = File.open(c[:expected_file]) {|f|f.read}
          expect(actual).to eq(c[:expected_contents])
        ensure
          case_after c

        end
      end

      def case_before(c)
        # implement each case before
        Dir.mkdir(OUTPUT_DSL_MODEL_TMP_DIR) unless Dir.exists? OUTPUT_DSL_MODEL_TMP_DIR
        Dir.chdir(OUTPUT_DSL_MODEL_TMP_DIR)
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
        FileUtils.rm_rf(OUTPUT_DSL_MODEL_TMP_DIR) if Dir.exists? OUTPUT_DSL_MODEL_TMP_DIR
      end
    end
  end

end
