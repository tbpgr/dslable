# encoding: utf-8

module Dslable
  class Args
    attr_accessor :_desc
    attr_accessor :_args_name
    attr_accessor :_klass
    attr_accessor :_required
    attr_accessor :_default_value

    def initialize
      @_desc = ""
      @_required = false
    end

    def desc(_desc)
      return if _desc.nil?
      @_desc = _desc
    end

    def args_name(_args_name)
      raise InvalidArgsError.new("args_name not allow nil") if _args_name.nil?
      raise InvalidArgsError.new("args_name not allow empty") if _args_name.empty?
      raise InvalidArgsError.new("args_name allow /^[a-z0-9_]+$/") unless _args_name =~ /^[a-z0-9_]+$/
      @_args_name = _args_name
    end

    def klass(_klass)
      raise InvalidArgsError.new("klass not allow nil") if _klass.nil?
      raise InvalidArgsError.new("klass only allow String, Array and Hash") unless [String, Hash, Array].include? (_klass)
      @_klass = _klass
    end

    def required
      @_required = true
    end

    def default_value(_default_value)
      @_default_value = _default_value
    end
  end

  class InvalidArgsError < StandardError;end
end
