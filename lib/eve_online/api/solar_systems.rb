module EveOnline
  module Api
    class SolarSystems
      attr_accessor :fragment
      private :fragment=, :fragment

      def initialize fragment
        self.fragment = fragment
      end

      def each
        rows = fragment.xpath './row'
        rows.each do |row|
          solar_system = SolarSystem.new row
          yield solar_system
        end
      end
      include Enumerable

      def to_s indent = 0
        margin = " " * indent
        ["#{margin}Solar Systems (#{to_a.size})"].tap do |s|
          sort.each do |solar_system|
            s << solar_system.to_s(indent + 2)
          end
        end.join "\n"        
      end
    end
  end
end