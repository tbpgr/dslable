# encoding: utf-8
require 'spec_helper'
require 'generators/product_codes/cli'

describe Dslable::Generators::ProductCodes::CLI do

  context :generate do
    OUTPUT_CLI_TMP_DIR = 'generate_cli'
    OUTPUT_CLI_CASE1 = <<-EOF
#!/usr/bin/env ruby
# encoding: utf-8

require "sample_gem_core"
require "sample_gem/version"
require "thor"

module SampleGem
  #= SampleGem CLI
  class CLI < Thor
    class_option :help, :type => :boolean, :aliases => '-h', :desc => 'help message.'
    class_option :version, :type => :boolean, :desc => 'version'

    desc "execute", "TODO: write your desc"
    def execute
      SampleGem::Core.new.execute
    end

    desc "init", "generate Samplegemfile"
    def init
      SampleGem::Core.new.init
    end

    desc "version", "version"
    def version
      p SampleGem::VERSION
    end
  end
end

SampleGem::CLI.start(ARGV)
    EOF
    cases = [
      {
        case_no: 1,
        case_title: 'generate',
        gem_name: 'sample_gem',
        bin_name: 'samplegem',
        fields: [:field1, :field2, :field3, :field4, :field5, :field6],
        fields_descs: %w(field_desc1 field_desc2 field_desc3 field_desc4 field_desc5 field_desc6),
        args: [:args1, :args2, :args3, :args4, :args5, :args6],
        args_klass: [String, Array, Hash, String, Array, Hash],
        args_required: [true, true, true, false, false, false],
        args_default: ['default1', %w(default1 default2), { default_key: 'default_value' }, nil, nil, nil],
        expected_file: './bin/samplegem',
        expected_contents: OUTPUT_CLI_CASE1
      },
    ]

    cases.each do |c|
      it "|case_no=#{c[:case_no]}|case_title=#{c[:case_title]}" do
        begin
          case_before c

          # -- given --
          dsl = Dslable::Dsl.new
          gen_cli = Dslable::Generators::ProductCodes::CLI.new(setup_dsl(c, dsl))

          # -- when --
          gen_cli.generate

          # -- then --
          actual = File.open(c[:expected_file]) { |f|f.read }
          expect(actual).to eq(c[:expected_contents])
        ensure
          case_after c

        end
      end

      def case_before(c)
        # implement each case before
        Dir.mkdir(OUTPUT_CLI_TMP_DIR) unless Dir.exist? OUTPUT_CLI_TMP_DIR
        Dir.chdir(OUTPUT_CLI_TMP_DIR)
        Dir.mkdir 'bin'
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
        Dir.chdir('../')
        FileUtils.rm_rf(OUTPUT_CLI_TMP_DIR) if Dir.exist? OUTPUT_CLI_TMP_DIR
      end
    end
  end

end
