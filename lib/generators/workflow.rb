# encoding: utf-8
require 'generators/generators'
require 'fileutils'
require 'dslable_dsl'
require 'erb'

module Dslable::Generators
  # =Dslable::Generators Gem Template Generator
  class Workflow
    # ==todos contents
    TODOS_CONTENTS = <<-EOS
implement '<%=gem_name%>_core.rb' your main logic. pass rspec all specs.
implement bin 'bin/your_bin'.
edit '<%=gem_name%>.gemspec'.
edit 'README.md'.
edit 'LICENSE.txt'.
git add, commit.
rake install.
check gem(test using).
gem uninstall <%=gem_name%>.
rake release.
gem install <%=gem_name%>.
after release check.
    EOS

    # ==doings contents
    DOINGS_CONTENTS = <<-EOS
implement '<%=gem_name%>_core_spec.rb'.
    EOS

    # ==tudu file definitions
    TUDU_FILES = {
      :todos => {
        :file_name => 'tudu/todos',
        :contents => TODOS_CONTENTS
      },
      :doings => {
        :file_name => 'tudu/doings',
        :contents => DOINGS_CONTENTS
      },
      :dones => {
        :file_name => 'tudu/dones',
        :contents => ''
      },
    }
    attr_accessor :dsl

    #== initialize generate gem template
    #=== Params
    #- _dsl: input from dsl
    def initialize(_dsl)
      raise InvalidDslError.new('dsl not allow nil') if _dsl.nil?
      @dsl = _dsl
    end

    #== generate gem template
    def generate
      Dir.mkdir('tudu')
      gem_name = @dsl._gem_name
      TUDU_FILES.each do |key, file_definition|
        File.open("./#{file_definition[:file_name]}", "w") do |f|
          f.print adapt_template(gem_name, file_definition[:contents])
        end
      end
    end

    private

    def adapt_template(gem_name, template)
      erb = ERB.new(template)
      erb.result(binding)
    end
  end
  class InvalidDslError < StandardError;end
end
