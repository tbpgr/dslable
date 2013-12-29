# encoding: utf-8
require 'spec_helper'
require 'dslable_dsl'

describe Dslable::Dsl do
  context :gem_name do
    cases = [
      {
        case_no: 1,
        case_title: 'valid gem name',
        input: 'abcdefghijklmnopqrstuvwxyz01234567891_',
        expected: 'abcdefghijklmnopqrstuvwxyz01234567891_'
      },
      {
        case_no: 2,
        case_title: 'empty gem name',
        input: '',
        expect_error: true
      },
      {
        case_no: 3,
        case_title: 'nil gem name',
        input: nil,
        expect_error: true
      },
      {
        case_no: 4,
        case_title: 'invalid gem name contain space',
        input: 'gem name',
        expect_error: true
      },
    ]

    cases.each do |c|
      it "|case_no=#{c[:case_no]}|case_title=#{c[:case_title]}" do
        begin
          case_before c

          # -- given --
          dslable_dsl = Dslable::Dsl.new

          # -- when --
          if c[:expect_error]
            lambda { dslable_dsl.gem_name c[:input] }.should raise_error(Dslable::InvalidDslError)
            next
          end
          dslable_dsl.gem_name c[:input]
          actual = dslable_dsl._gem_name

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

  context :gem_desc do
    cases = [
      {
        case_no: 1,
        case_title: 'valid gem desc',
        input: 'abcdefghijklmnopqrstuvwxyz01234567891_',
        expected: 'abcdefghijklmnopqrstuvwxyz01234567891_'
      },
      {
        case_no: 2,
        case_title: 'empty gem desc',
        input: '',
        expect_error: true
      },
      {
        case_no: 3,
        case_title: 'nil gem desc',
        input: nil,
        expect_error: true
      },
    ]

    cases.each do |c|
      it "|case_no=#{c[:case_no]}|case_title=#{c[:case_title]}" do
        begin
          case_before c

          # -- given --
          dslable_dsl = Dslable::Dsl.new

          # -- when --
          if c[:expect_error]
            lambda { dslable_dsl.gem_desc c[:input] }.should raise_error(Dslable::InvalidDslError)
            next
          end
          dslable_dsl.gem_desc c[:input]
          actual = dslable_dsl._gem_desc

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

  context :field do
    cases = [
      {
        case_no: 1,
        case_title: 'case_title',
        input_field_name: :field_name,
        input_field_desc: 'field_desc',
        input_args_name: :args_name,
        input_args_desc: 'args_desc',
        expected_field_name: :field_name,
        expected_field_desc: 'field_desc',
        expected_args_name: :args_name,
        expected_args_desc: 'args_desc',
      },
    ]

    cases.each do |c|
      it "|case_no=#{c[:case_no]}|case_title=#{c[:case_title]}" do
        begin
          case_before c

          # -- given --
          dslable_dsl = Dslable::Dsl.new

          # -- when --
          dslable_dsl.field c[:input_field_name] do |f|
            f.desc c[:input_field_desc]
            f.args c[:input_args_name] do |a|
              a.desc c[:input_args_desc]
            end
          end

          # -- then --
          actual = dslable_dsl.fields.first
          expect(actual._field_name).to eq(c[:expected_field_name])
          expect(actual._desc).to eq(c[:expected_field_desc])
          expect(actual._args._args_name).to eq(c[:expected_args_name])
          expect(actual._args._desc).to eq(c[:expected_args_desc])
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

  context :bin_name do
    cases = [
      {
        case_no: 1,
        case_title: 'valid bin name',
        input: 'abcdefghijklmnopqrstuvwxyz01234567891_',
        expected: 'abcdefghijklmnopqrstuvwxyz01234567891_'
      },
      {
        case_no: 2,
        case_title: 'empty bin name',
        input: '',
        expect_error: true
      },
      {
        case_no: 3,
        case_title: 'nil bin name',
        input: nil,
        expect_error: true
      },
      {
        case_no: 4,
        case_title: 'invalid bin name contain space',
        input: 'bin name',
        expect_error: true
      },
    ]

    cases.each do |c|
      it "|case_no=#{c[:case_no]}|case_title=#{c[:case_title]}" do
        begin
          case_before c

          # -- given --
          dslable_dsl = Dslable::Dsl.new

          # -- when --
          if c[:expect_error]
            lambda { dslable_dsl.bin_name c[:input] }.should raise_error(Dslable::InvalidDslError)
            next
          end
          dslable_dsl.bin_name c[:input]
          actual = dslable_dsl._bin_name

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
