# encoding: utf-8
require 'spec_helper'
require 'generators/gem_template'
require 'dslable_dsl'

describe Dslable::Generators::GemTemplate do
  context :generate do
    OUTPUT_TMP_DIR = 'generate_gem_template'

    cases = [
      {
        case_no: 1,
        case_title: 'valid gem template',
        gem_name: 'sample_gem'
      },
    ]

    cases.each do |c|
      it "|case_no=#{c[:case_no]}|case_title=#{c[:case_title]}" do
        begin
          case_before c

          # -- given --
          dsl = Dslable::Dsl.new
          dsl.gem_name c[:gem_name]
          gem_template = Dslable::Generators::GemTemplate.new(dsl)

          # -- when --
          gem_template.generate

          # -- then --
          actual = Dir.exists?("../#{c[:gem_name]}")
          expect(actual).to be_true
        ensure

          case_after c
        end
      end

      def case_before(c)
        Dir.mkdir(OUTPUT_TMP_DIR) unless Dir.exists? OUTPUT_TMP_DIR
        Dir.chdir(OUTPUT_TMP_DIR)
      end

      def case_after(c)
        Dir.chdir('../../')
        FileUtils.rm_rf(OUTPUT_TMP_DIR) if Dir.exists? OUTPUT_TMP_DIR
      end
    end
  end

end
