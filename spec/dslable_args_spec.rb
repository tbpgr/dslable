# encoding: utf-8
require 'spec_helper'
require 'dslable_args'

describe Dslable::Args do
  context :desc do
    cases = [
      {
        case_no: 1,
        case_title: 'valid description',
        input: 'this is descripotion',
        expected: 'this is descripotion'
      },
      {
        case_no: 2,
        case_title: 'empty description',
        input: '',
        expected: ''
      },
      {
        case_no: 3,
        case_title: 'nil description',
        input: nil,
        expected: ''
      },
    ]

    cases.each do |c|
      it "|case_no=#{c[:case_no]}|case_title=#{c[:case_title]}" do
        begin
          case_before c

          # -- given --
          dslable_args = Dslable::Args.new

          # -- when --
          dslable_args.desc c[:input]

          # -- then --
          actual = dslable_args._desc
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
      end
    end
  end

  context :args_name do
    cases = [
      {
        case_no: 1,
        case_title: 'valid dsl_args name',
        input: 'abcdefghijklmnopqrstuvwxyz01234567891_',
        expected: 'abcdefghijklmnopqrstuvwxyz01234567891_'
      },
      {
        case_no: 2,
        case_title: 'empty dsl_args name',
        input: '',
        expect_error: true
      },
      {
        case_no: 3,
        case_title: 'nil dsl_args name',
        input: nil,
        expect_error: true
      },
      {
        case_no: 4,
        case_title: 'invalid dsl_args name contain space',
        input: 'method name',
        expect_error: true
      },
    ]

    cases.each do |c|
      it "|case_no=#{c[:case_no]}|case_title=#{c[:case_title]}" do
        begin
          case_before c

          # -- given --
          dslable_args = Dslable::Args.new

          # -- when --
          if c[:expect_error]
            lambda { dslable_args.args_name c[:input] }.should raise_error(Dslable::InvalidArgsError)
            next
          end
          dslable_args.args_name c[:input]
          actual = dslable_args._args_name

          # -- then --
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
      end
    end
  end

  context :klass do
    cases = [
      {
        case_no: 1,
        case_title: 'valid klass String',
        input: String,
        expected: String
      },
      {
        case_no: 2,
        case_title: 'valid klass Array',
        input: Array,
        expected: Array
      },
      {
        case_no: 3,
        case_title: 'valid klass Hash',
        input: Hash,
        expected: Hash
      },
      {
        case_no: 4,
        case_title: 'invalid klass Hash',
        input: Fixnum,
        expect_error: true
      },
      {
        case_no: 5,
        case_title: 'nil klass',
        input: nil,
        expect_error: true
      },
      {
        case_no: 6,
        case_title: 'valid klass Boolean',
        input: :Boolean,
        expected: :Boolean
      },
    ]

    cases.each do |c|
      it "|case_no=#{c[:case_no]}|case_title=#{c[:case_title]}" do
        begin
          case_before c

          # -- given --
          dslable_args = Dslable::Args.new

          # -- when --
          if c[:expect_error]
            lambda { dslable_args.klass c[:input] }.should raise_error(Dslable::InvalidArgsError)
            next
          end
          dslable_args.klass c[:input]
          actual = dslable_args._klass

          # -- then --
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
      end
    end
  end

  context :required do
    cases = [
      {
        case_no: 1,
        case_title: 'valid required',
        expected: true
      },
    ]

    cases.each do |c|
      it "|case_no=#{c[:case_no]}|case_title=#{c[:case_title]}" do
        begin
          case_before c

          # -- given --
          dslable_args = Dslable::Args.new

          # -- when --
          dslable_args.required
          actual = dslable_args._required

          # -- then --
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
      end
    end
  end

  context :default_value do
    cases = [
      {
        case_no: 1,
        case_title: 'valid default',
        input: 'valid default',
        expected: 'valid default'
      },
    ]

    cases.each do |c|
      it "|case_no=#{c[:case_no]}|case_title=#{c[:case_title]}" do
        begin
          case_before c

          # -- given --
          dslable_args = Dslable::Args.new

          # -- when --
          dslable_args.default_value c[:input]
          actual = dslable_args._default_value

          # -- then --
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
      end
    end
  end

end
