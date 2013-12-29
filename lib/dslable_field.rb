# encoding: utf-8
require 'dslable_args'

module Dslable
  class Field
    attr_accessor :_field_name
    attr_accessor :_desc
    attr_accessor :_args

    def initialize
      @_desc = ''
    end

    def field_name(_name)
      return if _name.nil?
      @_field_name = _name
    end

    def desc(_desc)
      return if _desc.nil?
      @_desc = _desc
    end

    def args(args_name)
      fail InvalidFieldError.new('args_name not allow nil') if args_name.nil?
      fail InvalidFieldError.new('args_name not allow empty') if args_name.empty?
      fail InvalidFieldError.new("args_name allow /^[a-z0-9_]+$/. your input is #{args_name}") unless args_name =~ /^[a-z0-9_]+$/
      dslable_args = Dslable::Args.new
      dslable_args._args_name = args_name
      yield dslable_args
      @_args = dslable_args
    end
  end

  class InvalidFieldError < StandardError; end
end
