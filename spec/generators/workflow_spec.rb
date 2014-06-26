# encoding: utf-8
require 'spec_helper'
require 'generators/workflow'

describe Dslable::Generators::Workflow do

  context :generate do
    OUTPUT_WORKFLOW_TMP_DIR = 'workflow_tmp'
    TODOS_CASE1 = <<-EOS
implement 'sample_gem_core.rb' your main logic. pass rspec all specs.
implement bin 'bin/samplegem'.
edit 'sample_gem.gemspec'.
edit 'README.md'.
edit 'LICENSE.txt'.
git add, commit.
rake install.
check gem(test using).
gem uninstall sample_gem.
rake release.
gem install sample_gem.
after release check.
    EOS

    DOINGS_CASE1 = <<-EOS
implement 'sample_gem_core_spec.rb'.
    EOS

    cases = [
      {
        case_no: 1,
        case_title: 'generate',
        gem_name: 'sample_gem',
        bin_name: 'samplegem',
        expected: Dslable::Generators::Workflow::TUDU_FILES,
        expected_contents: {
          todos: TODOS_CASE1,
          doings: DOINGS_CASE1,
          dones: ''
        }
      },
    ]

    cases.each do |c|
      it "|case_no=#{c[:case_no]}|case_title=#{c[:case_title]}" do
        begin
          case_before c

          # -- given --
          dsl = Dslable::Dsl.new
          dsl.gem_name c[:gem_name]
          dsl.bin_name c[:bin_name]
          workflow = Dslable::Generators::Workflow.new(dsl)

          # -- when --
          workflow.generate

          # -- then --
          c[:expected].each do |key, file_definition|
            actual = File.open(file_definition[:file_name]) { |f|f.read }
            expect(actual).to eq(c[:expected_contents][key])
          end
        ensure
          case_after c
        end
      end

      def case_before(c)
        # implement each case before
        Dir.mkdir(OUTPUT_WORKFLOW_TMP_DIR) unless Dir.exist? OUTPUT_WORKFLOW_TMP_DIR
        Dir.chdir(OUTPUT_WORKFLOW_TMP_DIR)
      end

      def case_after(c)
        # implement each case after
        Dir.chdir('../')
        FileUtils.rm_rf(OUTPUT_WORKFLOW_TMP_DIR) if Dir.exist? OUTPUT_WORKFLOW_TMP_DIR
      end
    end
  end
end
