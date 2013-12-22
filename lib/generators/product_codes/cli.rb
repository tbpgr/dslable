# encoding: utf-8
require "generators/generators"
require "erb"
require 'active_support/inflector'
require "dslable_dsl"
require "fileutils"

module Dslable::Generators::ProductCodes
  class CLI
    CLI_TEMPLATE =<<-EOF
#!/usr/bin/env ruby
# encoding: utf-8

require "<%=gem_name%>_core"
require "<%=gem_name%>/version"
require "thor"

module <%=gem_name_camel%>
  #= <%=gem_name_camel%> CLI
  class CLI < Thor
    class_option :help, :type => :boolean, :aliases => '-h', :desc => 'help message.'
    class_option :version, :type => :boolean, :desc => 'version'

    desc "execute", "TODO: write your desc"
    def execute
      <%=gem_name_camel%>::Core.new.execute
    end

    desc "init", "generate <%=dsl_file_name%>"
    def init
      <%=gem_name_camel%>::Core.new.init
    end

    desc "version", "version"
    def version
      p <%=gem_name_camel%>::VERSION
    end
  end
end

<%=gem_name_camel%>::CLI.start(ARGV)
    EOF

    attr_accessor :dsl

    #== initialize dsl model
    #=== Params
    #- _dsl: input from dsl
    def initialize(_dsl)
      raise InvalidDslError.new("dsl not allow nil") if _dsl.nil?
      @dsl = _dsl
    end

    def generate
      cli_src = adapt_template(@dsl.camelized_gem_name)
      generate_cli_src cli_src
    end

    private
    def adapt_template(gem_name_camel)
      gem_name = @dsl._gem_name
      dsl_file_name = "#{@dsl._gem_name.camelize.downcase.camelize}file"
      erb = ERB.new(CLI_TEMPLATE)
      erb.result(binding)
    end

    def generate_cli_src(cli_src)
      FileUtils.mkdir_p("./bin") unless File.exists?("./bin")
      File.open("./bin/#{@dsl._bin_name}", "w") {|f|f.puts cli_src}
    end
  end

  class InvalidDslError < StandardError;end
end
