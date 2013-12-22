# encoding: utf-8
require "spec_helper"
require "dslable_field"

describe Dslable::Field do
  context :desc do
    cases = [
      {
        case_no: 1,
        case_title: "valid description",
        input: "this is descripotion",
        expected: "this is descripotion"
      },
      {
        case_no: 2,
        case_title: "empty description",
        input: "",
        expected: ""
      },
      {
        case_no: 3,
        case_title: "nil description",
        input: nil,
        expected: ""
      },
    ]

    cases.each do |c|
      it "|case_no=#{c[:case_no]}|case_title=#{c[:case_title]}" do
        begin
          case_before c

          # -- given --
          dslable_field = Dslable::Field.new

          # -- when --
          dslable_field.desc c[:input]

          # -- then --
          actual = dslable_field._desc
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

  context :args do
    cases = [
      {
        case_no: 1,
        case_title: "valid args",
        input_key: :args_name,
        input_desc: "desc",
        input_klass: String,
        input_required: true,
        input_default_value: "default",
        expected_key: :args_name,
        expected_desc: "desc",
        expected_klass: String,
        expected_required: true,
        expected_default_value: "default",
      },
    ]

    cases.each do |c|
      it "|case_no=#{c[:case_no]}|case_title=#{c[:case_title]}" do
        begin
          case_before c

          # -- given --
          dslable_field = Dslable::Field.new

          # -- when --
          dslable_field.args :args_name do |a|
            a.desc c[:input_desc]
            a.klass c[:input_klass]
            a.required
            a.default_value c[:input_default_value]
          end

          # -- then --
          actual_args = dslable_field._args
          actual_desc = actual_args._desc
          actual_klass = actual_args._klass
          actual_required = actual_args._required
          actual_default_value = actual_args._default_value
          expect(actual_desc).to eq(c[:expected_desc])
          expect(actual_klass).to eq(c[:expected_klass])
          expect(actual_required).to eq(c[:expected_required])
          expect(actual_default_value).to eq(c[:expected_default_value])
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
