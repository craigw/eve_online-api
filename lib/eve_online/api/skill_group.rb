module EveOnline
  module Api
    class SkillGroup
      attr_accessor :fragment
      private :fragment=, :fragment

      def initialize fragment
        self.fragment = fragment
      end

      def id
        fragment['groupID']
      end

      def name
        fragment['groupName']
      end

      def <=> other
        name <=> other.name
      end
      include Comparable

      def merge other
        other.skills_fragment.children.each do |child|
          skills_fragment.add_child child
        end
      end

      def skills
        Skills.new skills_fragment
      end

      def skills_fragment
        fragment.at_xpath './rowset'
      end

      def to_s indent = 0
        "#{' ' * indent}#{name} Skill Group (id:#{id})\n#{skills.to_s(indent + 2)}"
      end
    end
  end
end