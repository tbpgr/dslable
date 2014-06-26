# encoding: utf-8
require 'spec_helper'
require 'dslable_core'
require 'fileutils'

describe Dslable::Core do
  context :init do
    cases = [
      {
        case_no: 1,
        case_title: 'output template',
        expected: Dslable::Core::DSLDEFINE_TEMPLATE
      },
    ]

    cases.each do |c|
      it "|case_no=#{c[:case_no]}|case_title=#{c[:case_title]}" do
        begin
          case_before c

          # -- given --
          dslable_core = Dslable::Core.new

          # -- when --
          dslable_core.init

          # -- then --
          actual = File.open(Dslable::Core::DSLDEFINE_FILE) { |f|f.read }
          expect(actual).to eq(c[:expected])
        ensure
          case_after c
        end
      end

      def case_before(c)
        # implement each case before
      end

      def case_after(c)
        return unless File.exist? Dslable::Core::DSLDEFINE_FILE
        File.delete(Dslable::Core::DSLDEFINE_FILE)
      end
    end
  end

  GENERATE_DSLABLE_GEM_CASE = <<-EOS
# encoding: utf-8
gem_name "sample_gem"

field :sample_field1 do |f|
  f.desc "sample_field1 description"
  f.args :sample_args1 do |a|
    a.desc "sample_args1 description"
    a.klass String
    a.required
    a.default_value "sample_field1_default"
  end
end

field :sample_field2 do |f|
  f.desc "sample_field2 description"
  f.args :sample_args2 do |a|
    a.desc "sample_args2 description"
    a.klass Array
  end
end

field :sample_field3 do |f|
  f.desc "sample_field3 description"
  f.args :sample_args3 do |a|
    a.desc "sample_args3 description"
    a.klass Hash
    a.default_value :hash_sample_key1 => "hash_sample_value1", :hash_sample_key2 => "hash_sample_value2"
  end
end
  EOS

  context :generate do
    OUTPUT_CORE_TMP_DIR = 'core_tmp'
    DSLDEFINE_TEMPLATE1 = <<-EOS
# encoding: utf-8

# set your gem name. this is use in rb-filename and class-name
gem_name "sample_gem"

# set your bin name
bin_name "bin_name"

# set your dsl filed
field :field_name1 do |f|
  # set your field description
  f.desc "field1 description"
  f.args :args_name do |a|
    # set your args description
    a.desc "args description"
    # you can use String, Array, Hash and :Boolean
    a.klass String
    # if you want not required, comment out following line
    a.required
    # if you comment out following line, default => nil
    a.default_value "args_value"
  end
end

field :field_name2 do |f|
  f.desc "field2 description"
  f.args :args_name do |a|
    a.desc "args description"
    a.klass Array
    a.default_value ["args_value1", "args_value2"]
  end
end
    EOS

    cases = [
      {
        case_no: 1,
        case_title: 'output some_core, some_dsl, some_dsl_model and their spec.',
        define_src: DSLDEFINE_TEMPLATE1,
        gem_name: 'sample_gem',
        expected_files: [
          './sample_gem/Gemfile',
          './sample_gem/sample_gem.gemspec',
          './sample_gem/.gitignore',
          './sample_gem/.rspec',
          './sample_gem/Rakefile',
          './sample_gem/README.md',
          './sample_gem/lib/sample_gem_core.rb',
          './sample_gem/lib/sample_gem_dsl.rb',
          './sample_gem/lib/sample_gem_dsl_model.rb',
          './sample_gem/bin/bin_name',
          './sample_gem/spec/spec_helper.rb',
          './sample_gem/spec/sample_gem_core_spec.rb',
        ]
      },
    ]

    cases.each do |c|
      it "|case_no=#{c[:case_no]}|case_title=#{c[:case_title]}" do
        begin
          case_before c

          # -- given --
          dslable_core = Dslable::Core.new

          # -- when --
          dslable_core.generate

          # -- then --
          Dir.chdir('../')
          c[:expected_files].each do |expected_file|
            actual = File.exist? expected_file
            expect(actual).to be_true
          end
        ensure
          case_after c
        end
      end

      def case_before(c)
        # implement each case before
        Dir.mkdir(OUTPUT_CORE_TMP_DIR) unless Dir.exist? OUTPUT_CORE_TMP_DIR
        Dir.chdir(OUTPUT_CORE_TMP_DIR)
        File.open(Dslable::Core::DSLDEFINE_FILE, 'w') { |f|f.puts c[:define_src] }
      end

      def case_after(c)
        # implement each case after
        Dir.chdir('../')
        FileUtils.rm_rf(OUTPUT_CORE_TMP_DIR) if Dir.exist? OUTPUT_CORE_TMP_DIR
      end
    end
  end

end
