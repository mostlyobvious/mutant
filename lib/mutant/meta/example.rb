module Mutant
  module Meta
    class Example
      include Adamantium, Concord::Public.new(:file, :node, :mutations)

      # Verification instance for example
      #
      # @return [Verification]
      def verification
        Verification.new(self, generated)
      end

      # Normalized source
      #
      # @return [String]
      def source
        Unparser.unparse(node)
      end
      memoize :source

      # Generated mutations on example source
      #
      # @return [Enumerable<Mutant::Mutation>]
      def generated
        Mutator.each(node).map do |node|
          Mutation::Evil.new(self, node)
        end
      end
      memoize :generated
    end # Example
  end # Meta
end # Mutant
