module EveOnline
  module Api
    class Skill
      attr_accessor :fragment
      private :fragment=, :fragment

      def initialize fragment
        self.fragment = fragment
      end

      def id
        fragment['typeID']
      end

      def name
        fragment['typeName']
      end

      def <=> other
        name <=> other.name
      end
      include Comparable

      def to_s indent = 0
        "#{' ' * indent}#{name} Skill (id:#{id})"
      end
    end
  end
end