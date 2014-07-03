# Dslable

[![Gem Version](https://badge.fury.io/rb/dslable.svg)](http://badge.fury.io/rb/dslable)
Dslable is generator for simple spec gem.

## Summary
* create gem template with DslSettingFile.
* you can get bin-executable gem.
* you can gem creation workflow.
* generated gem has 1-DslSettingFile.
* generated gem has 1-core logic class.
* generated gem has 1-dsl class.
* generated gem has 1-dsl-model class.
* generated gem has 1-core class's RSpec spec.
* generated gem has Gemfile.(already has minimum necessary gem)

## Purpose
* to create simple spec gem easier.

## Structure
### Dsldefine
this is setting file. 

set ...

* gem_name: your gem name. set snake case name
* bin_name: your bin name. set snake case name
* field: your dsl field.

### generated code: lib/your_gem_name_core.rb
* main logic. 
* init method generate DslSettingFile.
* execute method is main logic. you must edit additional logic manually.

### generated code: lib/your_gem_name_dsl.rb
* this file keeps values from DslSettingFile.

### generated code: lib/your_gem_name_dsl_model.rb
* this file define DslSettingFile's model.

### generated code: bin/your_bin_name
* this file has command line interface logic.

### generated code: spec/your_gem_name_core_spec.rb
* this file is RSpec spec for 'your_gem_name_core.rb'.

## DSL List
### Global DSL
| dsl          | mean                         |
|:-----------  |:------------                 |
| gem_name     |set your gem name.(snake_case)|
| bin_name     |set your bin name.(snake_case)|
| field        |set your field information by block|

### Field DSL
| dsl          | mean                     |
|:-----------  |:------------             |
| desc         |set your field description|

### Args DSL
| dsl          | mean                                                                   |
|:-----------  |:------------                                                           |
| desc         |set your args description                                               |
| klass        |set your args data type. you can choose [String, Array, Hash, :Boolean] |
| required     |if you want to set required, use this.                                  |
| default_value|if you want to set default value, use this.                             |

## Installation

Add this line to your application's Gemfile:

    gem 'dslable'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install dslable

## Sample Usage
### Sample Spec
* create FizzBuzzGem
* if you execute 'fizzbuzzgem', result is...
~~~bash
1 2 fizz 3 4 buzz 5 fizz 7 8 fizz buzz 11 fizz 13 14 fizzbuzz
~~~

* you can choose output 'fizz/buzz/fizzbuzz' or 'FIZZ/BUZZ/FIZZBUZZ' by setting file.
* you can set fizzbuzz range by setting file.

### Steps: 'dslable init'. generate Dsldefine Template.
~~~bash
$ dslable init
$ ls
Dsldefine
~~~

Dsldefine Template Contents
~~~ruby
# encoding: utf-8

# set your gem name. this is use in rb-filename and class-name
gem_name "TODO: set your gem_name"

# set your bin name
bin_name "TODO: set your bin_name"

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
    a.default_value "args_value2"
  end
end

# field :field_name2 do |f|
#   f.desc "field2 description"
#   f.args :args_name do |a|
#     a.desc "args description"
#     a.klass String
#     a.required
#     a.default_value "args_value2"
#   end
# end
~~~

### Steps: Edit Dsldefine manually.
~~~ruby
# encoding: utf-8
gem_name "fizz_buzz_gem"

bin_name "fizzbuzzgem"

field :is_upper_case do |f|
  f.desc "is_upper_case"
  f.args :is_upper_case do |a|
    a.desc "is_upper_case flg."
    a.klass String
    a.required
    a.default_value "false"
  end
end

field :range do |f|
  f.desc "range"
  f.args :range do |a|
    a.desc "range."
    a.klass Array
    a.default_value (1..15).to_a
  end
end
~~~

### Steps: 'dslable generate'. generate template.
~~~bash
dslable generate
~~~

FileTree
~~~
fizz_buzz_gem
│  .gitignore
│  .rspec
│  fizz_buzz_gem.gemspec
│  Gemfile
│  LICENSE.txt
│  Rakefile
│  README.md
│
├─.git
├─bin
│      fizzbuzzgem
│
├─lib
│  │  fizz_buzz_gem_core.rb
│  │  fizz_buzz_gem_dsl.rb
│  │  fizz_buzz_gem_dsl_model.rb
│  │
│  └─fizz_buzz_gem
│          version.rb
│
├─spec
│      fizz_buzz_gem_core_spec.rb
│      spec_helper.rb
└─tudu
        todos
        doings
        dones
~~~

Gemfile Template
~~~ruby
source 'https://rubygems.org'

gemspec
gem "rspec", "~> 2.14.1"
gem "thor", "~> 0.18.1"
gem "simplecov", "~> 0.8.2"
gem "activesupport", "~> 4.0.1"
gem "activemodel", "~> 4.0.2"
~~~

core source Template
fizz_buzz_gem_core.rb
~~~ruby
# encoding: utf-8
require 'fizz_buzz_gem_dsl'

module FizzBuzzGem
  #  FizzBuzzGem Core
  class Core
    FIZZ_BUZZ_GEM_FILE = "Fizzbuzzgemfile"
    FIZZ_BUZZ_GEM_TEMPLATE =<<-EOS
# encoding: utf-8

# is_upper_case
# is_upper_case is required
# is_upper_case allow only String
# is_upper_case's default value => "false"
is_upper_case "false"

# range
# range allow only Array
# range's default value => [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15]
range [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15]

    EOS

    #== generate Fizzbuzzgemfile to current directory.
    def init
      File.open(FIZZ_BUZZ_GEM_FILE, "w") {|f|f.puts FIZZ_BUZZ_GEM_TEMPLATE}
    end

    #== TODO: write your gem's specific contents
    def execute
      src = read_dsl
      dsl = FizzBuzzGem::Dsl.new
      dsl.instance_eval src

      # TODO: implement your gem's specific logic

    end

    private
    def read_dsl
      File.open(FIZZ_BUZZ_GEM_FILE) {|f|f.read}
    end
  end
end
~~~

dsl source Template
fizz_buzz_gem_dsl.rb
~~~ruby
# encoding: utf-8
require 'fizz_buzz_gem_dsl_model'

module FizzBuzzGem
  class Dsl
    attr_accessor :fizz_buzz_gem

    [:is_upper_case].each do |f|
      define_method f do |value|
        eval "@fizz_buzz_gem.#{f.to_s} = '#{value}'", binding
      end
    end

    [:range].each do |f|
      define_method f do |value|
        eval "@fizz_buzz_gem.#{f.to_s} = #{value}", binding
      end
    end

    def initialize
      @fizz_buzz_gem = FizzBuzzGem::DslModel.new
      @fizz_buzz_gem.is_upper_case = 'false'
      @fizz_buzz_gem.range = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15]
    end
  end
end
~~~

dsl model source Template
fizz_buzz_gem_dsl_model.rb
~~~ruby
# encoding: utf-8
require 'active_model'

module FizzBuzzGem
  class DslModel
    include ActiveModel::Model

    # is_upper_case
    attr_accessor :is_upper_case
    validates :is_upper_case, :presence => true

    # range
    attr_accessor :range

  end
end
~~~

bin source Template
~~~ruby
#!/usr/bin/env ruby
# encoding: utf-8

require "fizz_buzz_gem_core"
require "fizz_buzz_gem/version"
require "thor"

module FizzBuzzGem
  #= FizzBuzzGem CLI
  class CLI < Thor
    class_option :help, :type => :boolean, :aliases => '-h', :desc => 'help message.'
    class_option :version, :type => :boolean, :desc => 'version'

    desc "execute", "TODO: write your desc"
    def execute
      FizzBuzzGem::Core.new.execute
    end

    desc "init", "generate Fizzbuzzgemfile"
    def init
      FizzBuzzGem::Core.new.init
    end

    desc "version", "version"
    def version
      p FizzBuzzGem::VERSION
    end
  end
end

FizzBuzzGem::CLI.start(ARGV)
~~~

spec source Template
~~~ruby
# encoding: utf-8
require "spec_helper"
require "fizz_buzz_gem_core"

describe FizzBuzzGem::Core do

  context :init do
    cases = [
      {
        case_no: 1,
        case_title: "case_title",
        expected: "expected",

      },
    ]

    cases.each do |c|
      it "|case_no=#{c[:case_no]}|case_title=#{c[:case_title]}" do
        begin
          case_before c

          # -- given --
          fizz_buzz_gem_core = FizzBuzzGem::Core.new

          # -- when --
          # TODO: implement execute code
          # actual = fizz_buzz_gem_core.init

          # -- then --
          # TODO: implement assertion code
          # ret = expect(actual).to eq(c[:expected])
        ensure
          case_after c

        end
      end

      def case_before(c)
        # implement each case before

      end

      def case_after(c)
        # implement each case after
      end
    end
  end

  context :execute do
    cases = [
      {
        case_no: 1,
        case_title: "case_title",
        expected: "expected",

      },
    ]

    cases.each do |c|
      it "|case_no=#{c[:case_no]}|case_title=#{c[:case_title]}" do
        begin
          case_before c

          # -- given --
          fizz_buzz_gem_core = FizzBuzzGem::Core.new

          # -- when --
          # TODO: implement execute code
          # actual = fizz_buzz_gem_core.execute

          # -- then --
          # TODO: implement assertion code
          # ret = expect(actual).to eq(c[:expected])
        ensure
          case_after c

        end
      end

      def case_before(c)
        # implement each case before

      end

      def case_after(c)
        # implement each case after
      end
    end
  end

end
~~~

Workflow Template(tudu/todos, tudu/doings, tudu/dones). you can check by tudu gem.
~~~bash
$ tudu tasks -c
========TODOS========
implement 'fizz_buzz_gem_core.rb' your main logic. pass rspec all specs.
implement bin 'bin/your_bin'.
edit 'fizz_buzz_gem.gemspec'.
edit 'README.md'.
edit 'LICENSE.txt'.
git add, commit.
rake install.
check gem(test using).
gem uninstall fizz_buzz_gem.
rake release.
gem install fizz_buzz_gem.
after release check.

========DOINGS========
implement 'fizz_buzz_gem_core_spec.rb'.

========DONES========
~~~

### Steps: check todo by tudu now
~~~bash
$ tudu now
implement 'fizz_buzz_gem_core_spec.rb'.
~~~

### Steps: implement 'fizz_buzz_core_spec.rb' manually. (TDD step)
~~~ruby
# encoding: utf-8
require "spec_helper"
require "fizz_buzz_gem_core"

describe FizzBuzzGem::Core do

  context :init do
    cases = [
      {
        case_no: 1,
        case_title: "output template",
        expected: FizzBuzzGem::Core::FIZZ_BUZZ_GEM_TEMPLATE
      },
    ]

    cases.each do |c|
      it "|case_no=#{c[:case_no]}|case_title=#{c[:case_title]}" do
        begin
          case_before c

          # -- given --
          fizz_buzz_core = FizzBuzzGem::Core.new

          # -- when --
          fizz_buzz_core.init

          # -- then --
          actual = File.read(FizzBuzzGem::Core::FIZZ_BUZZ_GEM_FILE)
          expect(actual).to eq(c[:expected])
        ensure
          case_after c

        end
      end

      def case_before(c)
        # implement each case before
      end

      def case_after(c)
        # implement each case after
        FileUtils.rm_rf(FizzBuzzGem::Core::FIZZ_BUZZ_GEM_FILE) if File.exists? FizzBuzzGem::Core::FIZZ_BUZZ_GEM_FILE
      end
    end
  end

  context :execute do
    FIZZBUZZGEMFILE_CASE1 =<<-EOS
# encoding: utf-8
is_upper_case "false"
    EOS

    FIZZBUZZGEMFILE_CASE2 =<<-EOS
# encoding: utf-8
is_upper_case "true"
range (1..16).to_a
    EOS

    cases = [
      {
        case_no: 1,
        case_title: "upper false, range default",
        fizzgemfile: FIZZBUZZGEMFILE_CASE1,
        expected: "1 2 fizz 4 buzz fizz 7 8 fizz buzz 11 fizz 13 14 fizzbuzz",
      },
      {
        case_no: 2,
        case_title: "upper true, range 1..16",
        fizzgemfile: FIZZBUZZGEMFILE_CASE2,
        expected: "1 2 FIZZ 4 BUZZ FIZZ 7 8 FIZZ BUZZ 11 FIZZ 13 14 FIZZBUZZ 16",
      },
    ]

    cases.each do |c|
      it "|case_no=#{c[:case_no]}|case_title=#{c[:case_title]}" do
        begin
          case_before c

          # -- given --
          fizz_buzz_gem_core = FizzBuzzGem::Core.new

          # -- when --
          actual = fizz_buzz_gem_core.execute

          # -- then --
          ret = expect(actual).to eq(c[:expected])
        ensure
          case_after c

        end
      end

      def case_before(c)
        # implement each case before
        File.open(FizzBuzzGem::Core::FIZZ_BUZZ_GEM_FILE, "w") {|f|f.puts c[:fizzgemfile]}
      end

      def case_after(c)
        # implement each case after
        FileUtils.rm_rf(FizzBuzzGem::Core::FIZZ_BUZZ_GEM_FILE) if File.exists? FizzBuzzGem::Core::FIZZ_BUZZ_GEM_FILE
      end
    end
  end

end
~~~

### Steps: execute 'rspec' and fail.
~~~bash
$ rspec
Run options: include {:focus=>true}

All examples were filtered out; ignoring {:focus=>true}
.FF

Failures:

  1) FizzBuzzGem::Core execute |case_no=1|case_title=upper false, range default
     Failure/Error: ret = expect(actual).to eq(c[:expected])

       expected: "1 2 fizz 4 buzz fizz 7 8 fizz buzz 11 fizz 13 14 fizzbuzz"
            got: "false"

       (compared using ==)
     # ./spec/fizz_buzz_gem_core_spec.rb:86:in `block (4 levels) in <top (required)>'

  2) FizzBuzzGem::Core execute |case_no=2|case_title=upper true, range 1..16
     Failure/Error: ret = expect(actual).to eq(c[:expected])

       expected: "1 2 FIZZ 4 BUZZ FIZZ 7 8 FIZZ BUZZ 11 FIZZ 13 14 FIZZBUZZ 16"
            got: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16]

       (compared using ==)
     # ./spec/fizz_buzz_gem_core_spec.rb:86:in `block (4 levels) in <top (required)>'

Finished in 0.01 seconds
3 examples, 2 failures

Failed examples:

rspec ./spec/fizz_buzz_gem_core_spec.rb:75 # FizzBuzzGem::Core execute |case_no=1|case_title=upper false, range default
rspec ./spec/fizz_buzz_gem_core_spec.rb:75 # FizzBuzzGem::Core execute |case_no=2|case_title=upper true, range 1..16

Randomized with seed 63051
~~~

### Steps: after implement spec, execute 'tudu done'. and confirm next todo by 'todo now'
~~~bash
$ tudu done
$ tudu now
implement 'fizz_buzz_gem_core.rb' your main logic. pass rspec all specs.
~~~

### Steps: implement 'fizz_buzz_core.rb' manually.
~~~ruby
# encoding: utf-8
require 'fizz_buzz_gem_dsl'

module FizzBuzzGem
  #  FizzBuzzGem Core
  class Core
    FIZZ_BUZZ_GEM_FILE = "Fizzbuzzgemfile"
    FIZZ_BUZZ_GEM_TEMPLATE =<<-EOS
# encoding: utf-8

# is_upper_case
# is_upper_case is required
# is_upper_case allow only String
# is_upper_case's default value => "false"
is_upper_case "false"

# range
# range allow only Array
# range's default value => [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15]
range [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15]

    EOS

    #== generate Fizzbuzzgemfile to current directory.
    def init
      File.open(FIZZ_BUZZ_GEM_FILE, "w") {|f|f.puts FIZZ_BUZZ_GEM_TEMPLATE}
    end

    #== TODO: write your gem's specific contents
    def execute
      src = read_dsl
      dsl = FizzBuzzGem::Dsl.new
      dsl.instance_eval src
      output_fizzbuzz(dsl)
    end

    private
    def read_dsl
      File.open(FIZZ_BUZZ_GEM_FILE) {|f|f.read}
    end

    def output_fizzbuzz(dsl)
      ret = []
      dsl.fizz_buzz_gem.range.each do |i|
        if i % 15 == 0
          ret << 'fizzbuzz'
        elsif i % 3 == 0
          ret << 'fizz'
        elsif i % 5 == 0
          ret << 'buzz'
        else
          ret << i
        end
      end
      output = ret.join(' ')
      dsl.fizz_buzz_gem.is_upper_case == 'true' ? output.upcase : output
    end
  end
end
~~~

### Steps: execute rspec
~~~bash
$rspec
Run options: include {:focus=>true}

All examples were filtered out; ignoring {:focus=>true}
...

Finished in 0.011 seconds
3 examples, 0 failures

Randomized with seed 29906
~~~

### Steps: after implement core.rb, execute 'tudu done'. and confirm next todo by 'todo now'
~~~bash
$ tudu done
$ tudu now
implement bin 'bin/your_bin'.
~~~

### Steps: Edit bin bin/fizzbuzzgem manually
~~~ruby
#!/usr/bin/env ruby
# encoding: utf-8

require "fizz_buzz_gem_core"
require "fizz_buzz_gem/version"
require "thor"

module FizzBuzzGem
  #= FizzBuzzGem CLI
  class CLI < Thor
    class_option :help, :type => :boolean, :aliases => '-h', :desc => 'help message.'
    class_option :version, :type => :boolean, :desc => 'version'

    desc "execute", "execute fizz buzz"
    def execute
      puts FizzBuzzGem::Core.new.execute
    end

    desc "init", "generate Fizzbuzzgemfile"
    def init
      FizzBuzzGem::Core.new.init
    end

    desc "version", "version"
    def version
      p FizzBuzzGem::VERSION
    end
  end
end

FizzBuzzGem::CLI.start(ARGV)
~~~

### Steps: after implement bin, execute 'tudu done'. and confirm next todo by 'todo now'
~~~bash
$ tudu done
$ tudu now
edit 'fizz_buzz_gem.gemspec'.
~~~

### Steps: Edit fizz_buzz_gem.gemspec manually
~~~ruby
# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fizz_buzz_gem/version'

Gem::Specification.new do |spec|
  spec.name          = "fizz_buzz_gem"
  spec.version       = FizzBuzzGem::VERSION
  spec.authors       = ["yourname"]
  spec.email         = ["your@mail.address"]
  spec.description   = %q{fizz buzz gem}
  spec.summary       = %q{fizz buzz gem}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "thor", "~> 0.18.1"
  spec.add_runtime_dependency "activesupport", "~> 4.0.1"
  spec.add_runtime_dependency "activemodel", "~> 4.0.2"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", "~> 2.14.1"
  spec.add_development_dependency "simplecov", "~> 0.8.2"
end
~~~

### Steps: after edit gemspec, execute 'tudu done'. and confirm next todo by 'todo now'
~~~bash
$ tudu done
$ tudu now
edit 'README.md'.
~~~

### Steps: Edit README.md manually
~~~ruby
# FizzBuzzGem

FizzBuzzApplication summary.

## Installation

Add this line to your application's Gemfile:

    gem 'fizz_buzz_gem'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install fizz_buzz_gem

## Usage

usage...

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
~~~

### Steps: after edit README.md, execute 'tudu done'. and confirm next todo by 'todo now'
~~~bash
$ tudu done
$ tudu now
edit 'LICENSE.txt'.
~~~

### Steps: Edit LICENSE.txt
edit.

### Steps: after edit LICENSE.txt, execute 'tudu done'. and confirm next todo by 'todo now'
~~~bash
$ tudu done
$ tudu now
git add, commit.
~~~

### Steps: git add, commit
~~~bash
$ git add -A
$ git add -u
$ git commit -m "first commit"
~~~

### Steps: after git add/commit, execute 'tudu done'. and confirm next todo by 'todo now'
~~~bash
$ tudu done
$ tudu now
rake install.
~~~

### Steps: rake install
~~~bash
$ rake install
fizz_buzz_gem 0.0.1 built to pkg/fizz_buzz_gem-0.0.1.gem.
fizz_buzz_gem (0.0.1) installed.
~~~

### Steps: after rake install, execute 'tudu done'. and confirm next todo by 'todo now'
~~~bash
$ tudu done
$ tudu now
check gem(test using).
~~~

### Steps: test use fizzbuzzgem
show help
~~~bash
$ fizzbuzzgem
Commands:
  fizzbuzzgem execute         # TODO: write your desc
  fizzbuzzgem help [COMMAND]  # Describe available commands or one specific c...
  fizzbuzzgem init            # generate Fizzbuzzgemfile
  fizzbuzzgem version         # version

Options:
  -h, [--help]     # help message.
      [--version]  # version
~~~

fizzbuzzgem init
~~~bash
$ fizzbuzzgem init
$ ls
Fizzbuzzgemfile*
$ cat Fizzbuzzgemfile
# encoding: utf-8

# is_upper_case
# is_upper_case is required
# is_upper_case allow only String
# is_upper_case's default value => "false"
is_upper_case "false"

# range
# range allow only Array
# range's default value => [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15]
range [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15]
~~~

edit Fizzbuzzgemfile manually
~~~ruby
# encoding: utf-8
is_upper_case "true"
range (1..16).to_a
~~~

execute 'fizzbuzzgem execute'
~~~bash
$ fizzbuzzgem execute
1 2 FIZZ 4 BUZZ FIZZ 7 8 FIZZ BUZZ 11 FIZZ 13 14 FIZZBUZZ 16
~~~

re-edit Fizzbuzzgemfile manually
~~~ruby
# encoding: utf-8
is_upper_case "false"
~~~

execute 'fizzbuzzgem execute'
~~~bash
$ fizzbuzzgem e
1 2 fizz 4 buzz fizz 7 8 fizz buzz 11 fizz 13 14 fizzbuzz
~~~

### Steps: after test using, execute 'tudu done'. and confirm next todo by 'todo now'
~~~bash
$ tudu done
$ tudu now
gem uninstall fizz_buzz_gem.
~~~

### Steps: uninstall test installed gem.
~~~bash
gem uninstall fizz_buzz_gem
~~~

### Steps: after gem uninstall fizz_buzz_gem, execute 'tudu done'. and confirm next todo by 'todo now'
~~~bash
$ tudu done
$ tudu now
rake release.
~~~

### Steps: if test using is ok, release gem to RubyGems
~~~bash
$ rake release
~~~

### Steps: after rake release, execute 'tudu done'. and confirm next todo by 'todo now'
~~~bash
$ tudu done
$ tudu now
gem install fizz_buzz_gem.
~~~

### Steps: install gem
~~~bash
$ gem install fizz_buzz_gem
~~~

### Steps: after gem install fizz_buzz_gem, execute 'tudu done'. and confirm next todo by 'todo now'
~~~bash
$ tudu done
$ tudu now
after release check.
~~~

### Steps: check your gem.
check.

### Steps: after check your gem complete, execute 'tudu done'. all todo complete'
~~~bash
$ tudu done
All Tasks Finish!!
~~~

## Notes
* this gem uses 'bundle gem' command to create gem template. (bundler gem).
* this gem uses 'rspec --init' command to create RSpec template (rspec gem).
* this gem uses 'piccolo' command to create RSpec spec template (rspec_piccolo gem).
* this gem uses 'tudu' command to create Workflow (tudu gem).

## History
* version 0.0.5 : update runtime_dependency(version up rspec_piccolo ver0.0.6 to ver0.0.8)
* version 0.0.4 : delete Core#init spec generation
* version 0.0.4 : delete Hash default brace.
* version 0.0.3 : add using class Boolean(true or class).
* version 0.0.2 : add workflow generation by 'tudu gem'.
* version 0.0.1 : first release.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
