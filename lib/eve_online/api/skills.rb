module EveOnline
  module Api
    class Skills
      attr_accessor :fragment
      private :fragment=, :fragment

      def initialize fragment
        self.fragment = fragment
      end

      def each
        rows = fragment.xpath './row'
        rows.each do |row|
          skill = Skill.new row
          yield skill
        end
      end
      include Enumerable

      def to_s indent = 0
        margin = " " * indent
        [ "#{margin}Skills (#{to_a.size})" ].tap do |s|
          sort.each do |skill|
            s << skill.to_s(indent + 2)
          end
        end.join "\n"
      end
    end
  end
end