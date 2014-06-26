# encoding: utf-8
require 'spec_helper'
require 'generators/rspec/specs'
require 'dslable_dsl'

describe Dslable::Generators::RSpec::Specs do

  context :generate do
    OUTPUT_SPECS_TMP_DIR = 'generate_specs_template'

    cases = [
      {
        case_no: 1,
        case_title: 'valid specs template',
        gem_name: 'sample_gem',
        specs: ['spec/sample_gem_core_spec.rb']
      },
    ]

    cases.each do |c|
      it "|case_no=#{c[:case_no]}|case_title=#{c[:case_title]}" do
        begin
          case_before c

          # -- given --
          dsl = Dslable::Dsl.new
          dsl.gem_name c[:gem_name]
          specs = Dslable::Generators::RSpec::Specs.new(dsl)

          # -- when --
          specs.generate

          # -- then --
          c[:specs].each do |spec|
            actual = File.exist?("./#{spec}")
            expect(actual).to be_true
          end
        ensure
          case_after c

        end
      end

      def case_before(c)
        Dir.mkdir(OUTPUT_SPECS_TMP_DIR) unless Dir.exist? OUTPUT_SPECS_TMP_DIR
        Dir.chdir(OUTPUT_SPECS_TMP_DIR)
        end

      def case_after(c)
        Dir.chdir('../')
        FileUtils.rm_rf(OUTPUT_SPECS_TMP_DIR) if Dir.exist? OUTPUT_SPECS_TMP_DIR
    end
    end
  end

end
