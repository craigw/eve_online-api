module EveOnline
  module Api
    class Client
      attr_accessor :api_base
      private :api_base=, :api_base

      attr_accessor :cache
      private :cache=, :cache

      attr_accessor :logger
      private :logger=, :logger

      def initialize options = {}
        self.api_base = options[:api_base] || 'http://api.eve-online.com'
        logger = options[:logger] || NullLogger.instance
        self.cache = options[:cache] || FileCache.new(:logger => logger)
        self.logger = logger
      end

      def skill_tree
        logger.debug "Fetching skill tree"
        results = get '/eve/SkillTree.xml.aspx'
      end

      def sovereignty
        logger.debug "Fetching sovereignty information"
        results = get '/map/Sovereignty.xml.aspx'
      end

      def get path
        uri = URI.parse api_base + path
        logger.debug "Asking cache for #{uri}"
        cached_document = cache.get uri
        logger.debug "Cache returned #{cached_document ? 'document' : 'nothing'}"
        return results_from cached_document if cached_document
        logger.debug "Making request to EVE API"
        response = Net::HTTP.get uri
        logger.debug "Parsing response"
        doc = Nokogiri::XML response
        expiration_string = doc.at_xpath '/eveapi/cachedUntil/text()'
        expiration_date = Time.parse expiration_string.to_s
        logger.debug "Told response is cached until #{expiration_date}"
        cache.set uri, response, expiration_date
        logger.debug "Returning response"
        results_from response
      end
      private :get

      def results_from xml
        doc = Nokogiri::XML xml
        result = doc.at_xpath '/eveapi/result/rowset'
        evaluate_result result
      end

      def evaluate_result row
        container_name = row['name']
        container_name[0] = container_name[0].upcase
        const_defined = EveOnline::Api.const_defined? container_name
        logger.debug "#{const_defined ? 'Found' : 'Unknown'} container: #{container_name}"
        return unless const_defined
        logger.debug "Using container #{container_name}"
        container_class = EveOnline::Api.const_get container_name
        logger.debug "Class instance = #{container_class.inspect}"
        container_class.new row
      end
    end
  end
end