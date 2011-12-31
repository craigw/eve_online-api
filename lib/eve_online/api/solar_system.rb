module EveOnline
  module Api
    class SolarSystem
      attr_accessor :fragment
      private :fragment=, :fragment

      def initialize fragment
        self.fragment = fragment
      end

      def id
        fragment['solarSystemID']
      end

      def name
        fragment['solarSystemName']
      end

      def alliance_id
        fragment['allianceID']
      end

      def corporation_id
        fragment['corporationID']
      end

      def faction_id
        fragment['factionID']
      end

      def <=> other
        name <=> other.name
      end
      include Comparable

      def to_s indent = 0
        margin = " " * indent
        "#{margin}#{name} Solar System (id:#{id}, alliance:#{alliance_id}, corporation:#{corporation_id}, faction:#{faction_id})"
      end
    end
  end
end