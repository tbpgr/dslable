# encoding: utf-8
require "spec_helper"
require "generators/settings/gemfile"

describe Dslable::Generators::Settings::Gemfile do

  context :generate do
    OUTPUT_GEMFILE_TMP_DIR = "generate_gemfile"

    cases = [
      {
        case_no: 1,
        case_title: "generate",
        gem_name: "sample_gem",
        bin_name: "samplegem",
        fields: [:field1],
        fields_descs: ["field_desc1"],
        args: [:args1],
        args_klass: [String],
        args_required: [true],
        args_default: ["default1"],
        expected_file: "./Gemfile",
        expected_contents: Dslable::Generators::Settings::Gemfile::GEMFILE_TEMPLATE
      },
    ]

    cases.each do |c|
      it "|case_no=#{c[:case_no]}|case_title=#{c[:case_title]}" do
        begin
          case_before c

          # -- given --
          dsl = Dslable::Dsl.new
          gen_gemfile = Dslable::Generators::Settings::Gemfile.new(setup_dsl(c, dsl))

          # -- when --
          gen_gemfile.generate

          # -- then --
          actual = File.open(c[:expected_file]) {|f|f.read}
          expect(actual).to eq(c[:expected_contents])
        ensure
          case_after c

        end
      end

      def case_before(c)
        # implement each case before
        Dir.mkdir(OUTPUT_GEMFILE_TMP_DIR) unless Dir.exists? OUTPUT_GEMFILE_TMP_DIR
        Dir.chdir(OUTPUT_GEMFILE_TMP_DIR)
      end

      def setup_dsl(c, dsl)
        dsl.gem_name c[:gem_name]
        dsl.bin_name c[:bin_name]
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
        FileUtils.rm_rf(OUTPUT_GEMFILE_TMP_DIR) if Dir.exists? OUTPUT_GEMFILE_TMP_DIR
      end
    end
  end

end
