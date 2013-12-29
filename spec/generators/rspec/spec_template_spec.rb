# encoding: utf-8
require 'spec_helper'
require 'generators/rspec/spec_template'
require 'dslable_dsl'

describe Dslable::Generators::RSpec::SpecTemplate do

  context :generate do
    OUTPUT_SPEC_TMP_DIR = 'generate_spec_template'

    cases = [
      {
        case_no: 1,
        case_title: 'valid spec template',
        gem_name: 'sample_gem',
        spec_dir_name: 'spec'
      },
    ]

    cases.each do |c|
      it "|case_no=#{c[:case_no]}|case_title=#{c[:case_title]}" do
        begin
          case_before c

          # -- given --
          dsl = Dslable::Dsl.new
          dsl.gem_name c[:gem_name]
          spec_template = Dslable::Generators::RSpec::SpecTemplate.new(dsl)

          # -- when --
          spec_template.generate

          # -- then --
          actual = Dir.exists?("./#{c[:spec_dir_name]}")
          expect(actual).to be_true
        ensure
          case_after c

        end
      end

      def case_before(c)
          Dir.mkdir(OUTPUT_SPEC_TMP_DIR) unless Dir.exists? OUTPUT_SPEC_TMP_DIR
          Dir.chdir(OUTPUT_SPEC_TMP_DIR)
        end

        def case_after(c)
          Dir.chdir('../')
          FileUtils.rm_rf(OUTPUT_SPEC_TMP_DIR) if Dir.exists? OUTPUT_SPEC_TMP_DIR
      end
    end
  end

end
