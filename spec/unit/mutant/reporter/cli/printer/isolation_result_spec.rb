# frozen_string_literal: true

RSpec.describe Mutant::Reporter::CLI::Printer::IsolationResult do
  setup_shared_context

  describe '.call' do
    context 'on successful isolation' do
      let(:reportable) do
        Mutant::Isolation::Result::Success.new(mutation_a_test_result)
      end

      it_reports <<~'STR'
        - 1 @ runtime: 1.0
          - test-a
      STR
    end

    context 'on exception isolation error' do
      let(:exception) do
        Class.new(RuntimeError) do
          def inspect
            '<TestException>'
          end

          def backtrace
            %w[first last]
          end
        end.new('foo')
      end

      let(:reportable) do
        Mutant::Isolation::Result::Exception.new(exception)
      end

      it_reports <<~'STR'
        Killing the mutation resulted in an integration error.
        This is the case when the tests selected for the current mutation
        did not produce a test result, but instead an exception was raised.

        This may point to the following problems:
        * Bug in mutant
        * Bug in the ruby interpreter
        * Bug in your test suite
        * Bug in your test suite under concurrency

        The following exception was raised while reading the killfork result:

        ```
        <TestException>
        first
        last
        ```
      STR
    end

    context 'on fork isolation error' do
      let(:reportable) do
        Mutant::Isolation::Fork::ForkError.new
      end

      it_reports <<~'STR'
        Forking the child process to isolate the mutation in failed.
        This meant that either the RubyVM or your OS was under too much
        pressure to add another child process.

        Possible solutions are:
        * Reduce concurrency
        * Reduce locks
      STR
    end

    context 'on child isolation error' do
      let(:reportable) do
        Mutant::Isolation::Fork::ChildError.new(
          instance_double(
            Process::Status,
            'unsuccessful status'
          ),
          'log message'
        )
      end

      it_reports <<~'STR'
        Log messages (combined stderr and stdout):
        [killfork] log message
        Killfork exited nonzero. Its result (if any) was ignored.
        Process status:
        #<InstanceDouble(Process::Status) "unsuccessful status">
      STR
    end

    context 'on child timeout' do
      let(:reportable) do
        Mutant::Isolation::Fork::Result::Timeout.new(1.2)
      end

      it_reports <<~'STR'
        Mutation analysis ran into the configured timeout of 1.2 seconds.
      STR
    end

    context 'on child isolation error' do
      let(:fork_error) do
        Mutant::Isolation::Fork::ForkError.new
      end

      let(:child_error) do
        Mutant::Isolation::Fork::ChildError.new(
          instance_double(
            Process::Status,
            'unsuccessful status'
          ),
          'log message'
        )
      end

      let(:reportable) do
        Mutant::Isolation::Result::ErrorChain.new(
          fork_error,
          child_error
        )
      end

      it_reports <<~'STR'
        Forking the child process to isolate the mutation in failed.
        This meant that either the RubyVM or your OS was under too much
        pressure to add another child process.

        Possible solutions are:
        * Reduce concurrency
        * Reduce locks
        Log messages (combined stderr and stdout):
        [killfork] log message
        Killfork exited nonzero. Its result (if any) was ignored.
        Process status:
        #<InstanceDouble(Process::Status) "unsuccessful status">
      STR
    end
  end
end
