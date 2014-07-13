# encoding: utf-8
require 'spec_helper'
require 'generators/product_codes/core'
require 'dslable_dsl'
require 'dslable_field'

describe Dslable::Generators::ProductCodes::Core do
  context :generate do
    OUTPUT_CORE_TMP_DIR = 'generate_core'
    OUTPUT_CORE_CASE1 = <<-EOF
# encoding: utf-8
require 'sample_gem_dsl'

module SampleGem
  # SampleGem Core
  class Core
    SAMPLE_GEM_FILE = 'Samplegemfile'
    SAMPLE_GEM_TEMPLATE = <<-EOS
# encoding: utf-8

# field_desc1
# args1 is required
# args1 allow only String
# args1's default value => "default1"
field1 "default1"

# field_desc2
# args2 is required
# args2 allow only Array
# args2's default value => ["default1", "default2"]
field2 ["default1", "default2"]

# field_desc3
# args3 is required
# args3 allow only Hash
# args3's default value => :default_key=>"default_value"
field3 :default_key=>"default_value"

# field_desc4
# args4 allow only String
field4 "your value"

# field_desc5
# args5 allow only Array
field5 ["your value"]

# field_desc6
# args6 allow only Hash
field6 "your key"=>"your value"

# field_desc7
# args7 is required
# args7 allow only Boolean
# args7's default value => false
field7 false

    EOS

    # generate Samplegemfile to current directory.
    def init
      File.open(SAMPLE_GEM_FILE, 'w') do |f|
        f.puts SAMPLE_GEM_TEMPLATE
      end
    end

    # TODO: write your gem's specific contents
    def execute
      src = read_dsl
      dsl = SampleGem::Dsl.new
      dsl.instance_eval src

      # TODO: implement your gem's specific logic

    end

    private

    def read_dsl
      File.open(SAMPLE_GEM_FILE) { |f|f.read }
    end
  end
end
    EOF
    cases = [
      {
        case_no: 1,
        case_title: 'valid generate core class',
        gem_name: 'sample_gem',
        fields: [:field1, :field2, :field3, :field4, :field5, :field6, :field7],
        fields_descs: %w(field_desc1 field_desc2 field_desc3 field_desc4 field_desc5 field_desc6 field_desc7),
        args: [:args1, :args2, :args3, :args4, :args5, :args6, :args7],
        args_klass: [String, Array, Hash, String, Array, Hash, :Boolean],
        args_required: [true, true, true, false, false, false, true],
        args_default: ['default1', %w(default1 default2), { default_key: 'default_value' }, nil, nil, nil, false],
        expected_file: './lib/sample_gem_core.rb',
        expected_contents: OUTPUT_CORE_CASE1
      },

    ]

    cases.each do |c|
      it "|case_no=#{c[:case_no]}|case_title=#{c[:case_title]}" do
        begin
          case_before c

          # -- given --
          dsl = Dslable::Dsl.new
          core = Dslable::Generators::ProductCodes::Core.new(setup_dsl(c, dsl))

          # -- when --
          core.generate

          # -- then --
          actual = File.open(c[:expected_file]) { |f|f.read }
          expect(actual).to eq(c[:expected_contents])
        ensure
          case_after c
        end
      end

      def case_before(c)
        Dir.mkdir(OUTPUT_CORE_TMP_DIR) unless Dir.exist? OUTPUT_CORE_TMP_DIR
        Dir.chdir(OUTPUT_CORE_TMP_DIR)
        Dir.mkdir 'lib'
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
        Dir.chdir('../')
        FileUtils.rm_rf(OUTPUT_CORE_TMP_DIR) if Dir.exist? OUTPUT_CORE_TMP_DIR
      end
    end
  end

end
