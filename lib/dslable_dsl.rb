# encoding: utf-8
require 'active_support/inflector'

module Dslable
  class Dsl
    attr_accessor :_gem_name
    attr_accessor :_gem_desc
    attr_accessor :_bin_name
    attr_accessor :fields

    def initialize
      @fields = []
    end

    def gem_name(_gem_name)
      raise InvalidDslError.new("gem_name not allow nil") if _gem_name.nil?
      raise InvalidDslError.new("gem_name not allow empty") if _gem_name.empty?
      raise InvalidDslError.new("gem_name allow /^[a-z0-9_]+$/") unless _gem_name =~ /^[a-z0-9_]+$/
      @_gem_name = _gem_name
    end

    def gem_desc(_gem_desc)
      raise InvalidDslError.new("gem_desc not allow nil") if _gem_desc.nil?
      raise InvalidDslError.new("gem_desc not allow empty") if _gem_desc.empty?
      @_gem_desc = _gem_desc
    end

    def bin_name(_bin_name)
      raise InvalidDslError.new("bin_name not allow nil") if _bin_name.nil?
      raise InvalidDslError.new("bin_name not allow empty") if _bin_name.empty?
      raise InvalidDslError.new("bin_name allow /^[a-z0-9_]+$/") unless _bin_name =~ /^[a-z0-9_]+$/
      @_bin_name = _bin_name
    end

    def field(_field_name)
      raise InvalidDslError.new("field name not allow nil") if _field_name.nil?
      raise InvalidDslError.new("field name not allow empty") if _field_name.empty?
      _field = Field.new
      _field.field_name _field_name
      yield _field
      @fields << _field
    end

    def camelized_gem_name
      _gem_name.camelize
    end
  end

  class InvalidDslError < StandardError;end
end
