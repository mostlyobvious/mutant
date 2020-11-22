# frozen_string_literal: true

module Mutant
  class Reporter
    class CLI
      class Printer
        # Reporter for mutation results
        class IsolationResult < self
          PROCESS_ERROR_MESSAGE = <<~'MESSAGE'
            Killfork exited nonzero. Its result (if any) was ignored.
            Process status:
            %s
          MESSAGE

          LOG_MESSAGES = <<~'MESSAGE'
            Log messages (combined stderr and stdout):
            %s
          MESSAGE

          EXCEPTION_ERROR_MESSAGE = <<~'MESSAGE'
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
            %s
            %s
            ```
          MESSAGE

          FORK_ERROR_MESSAGE = <<~'MESSAGE'
            Forking the child process to isolate the mutation in failed.
            This meant that either the RubyVM or your OS was under too much
            pressure to add another child process.

            Possible solutions are:
            * Reduce concurrency
            * Reduce locks
          MESSAGE

          TIMEOUT_ERROR_MESSAGE =<<~'MESSAGE'
            Mutation analysis ran into the configured timeout of %02.9<timeout>g seconds.
          MESSAGE

          private_constant(*constants(false))

          # Run report printer
          #
          # @return [undefined]
          def run
            print_timeout
            print_tests
            print_process_status
            print_log_messages
            print_exception
          end

        private

          def print_tests
            value = object.value or return
            visit(TestResult, value)
          end

          def print_log_messages
            log = object.log

            return if log.empty?

            puts('Log messages (combined stderr and stdout):')

            log.each_line do |line|
              puts('[killfork] %<line>s' % { line: line })
            end
          end

          # rubocop:disable Style/GuardClause
          def print_process_status
            process_status = object.process_status or return

            unless process_status.success?
              puts(PROCESS_ERROR_MESSAGE % object.process_status.inspect)
            end
          end
          # rubocop:enable Style/GuardClause

          def visit_fork_error
            puts(FORK_ERROR_MESSAGE)
          end

          def print_timeout
            timeout = object.timeout or return
            puts(TIMEOUT_ERROR_MESSAGE % { timeout: timeout })
          end

          def print_exception
            exception = object.exception or return

            puts(
              EXCEPTION_ERROR_MESSAGE % [
                exception.inspect,
                exception.backtrace.join("\n")
              ]
            )
          end

          def visit_chain
            printer = self.class

            visit(printer, object.value)
            visit(printer, object.next)
          end
        end # IsolationResult
      end # Printer
    end # CLI
  end # Reporter
end # Mutant
