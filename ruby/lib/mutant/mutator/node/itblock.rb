# frozen_string_literal: true

module Mutant
  class Mutator
    class Node
      class Itblock < self
        MODIFIABLE = %i[if while until while_post until_post].to_set.freeze

        handle(:itblock)

        children :receiver, :parameter, :body

      private

        def dispatch
          emit_nil
          emit_receiver_mutations(&method(:n_send?))
          emit_body_mutations(&method(:references_it?))
        end

        def references_it?(node)
          first = first_it_node(node)
          first && n_lvar?(first)
        end

        def first_it_node(node)
          return node if node.eql?(s(:lvar, :it)) || assigns_it?(node)

          found = outer_children(node).filter_map do |child|
            child.instance_of?(::Parser::AST::Node) && first_it_node(child)
          end

          modifier_assignment(node, found) || found.first
        end

        # Unparser may print these as modifiers, with the body before the condition.
        def modifier_assignment(node, found)
          found.detect(&method(:assigns_it?)) if MODIFIABLE.include?(node.type)
        end

        def assigns_it?(node)
          (n_lvasgn?(node) || n_match_var?(node)) && node.children.first.equal?(:it)
        end

        def outer_children(node)
          case node.type
          when :block, :itblock, :def, :defs, :module, :sclass
            node.children.take(1)
          when :class
            node.children.take(2)
          else
            node.children
          end
        end
      end # Itblock
    end # Node
  end # Mutator
end # Mutant
