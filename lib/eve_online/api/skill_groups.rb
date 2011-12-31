module EveOnline
  module Api
    class SkillGroups
      attr_accessor :fragment
      private :fragment=, :fragment

      def initialize fragment
        self.fragment = fragment
      end

      def each
        rows = fragment.xpath './row'
        skill_groups = rows.map do |row|
          skill_group = SkillGroup.new row
        end
        skill_groups.group_by { |sg| sg.id }.each do |id, groups|
          group = groups.pop
          while next_group = groups.pop
            group.merge next_group
          end
          yield group
        end
      end
      include Enumerable

      def to_s indent = 0
        margin = " " * indent
        ["#{margin}Skill Groups (#{to_a.size})"].tap do |s|
          sort.each do |skill_group|
            s << skill_group.to_s(indent + 2)
          end
        end.join "\n"        
      end
    end
  end
end