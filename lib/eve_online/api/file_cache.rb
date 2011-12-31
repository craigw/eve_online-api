module EveOnline
  module Api
    class FileCache
      attr_accessor :directory
      private :directory=, :directory

      attr_accessor :logger
      private :logger=, :logger

      attr_accessor :boundary
      private :boundary=, :boundary

      def initialize options = {}
        self.directory = options[:directory] || Dir.tmpdir
        self.logger = options[:logger] || NullLogger.instance
        self.boundary = options[:boundary] || '_FILE_CACHE_'
      end

      def get key
        logger.debug "Cache asked for #{key}"
        file = file_for key
        return unless file
        logger.debug "Reading from cache at #{file}"
        File.read file
      end

      def set key, data, expiration_date
        logger.debug "Asked to cache #{key} until #{expiration_date}"
        request_time = Time.now
        return unless expiration_date > request_time
        hex = Digest::SHA1.hexdigest key.to_s
        file_name = "#{expiration_date.to_i}#{boundary}#{hex}"
        file_path = File.join directory, file_name
        logger.debug "Realising cache instance as #{file_path}"
        File.open file_path, 'w' do |file|
          file.print data
        end
        logger.debug "Cached #{key} in #{file_path}"
      end

      def file_for key
        logger.debug "Finding cache instances for #{key}"
        hex = Digest::SHA1.hexdigest key.to_s
        pattern = File.join directory, "*#{boundary}#{hex}"
        logger.debug "Glob for #{pattern} on disk"
        files = Dir.glob pattern
        logger.debug "Found #{files.size} cache instances"
        return unless files.any?
        request_time = Time.now
        logger.debug "Excluding expired instanced"
        live = files.select { |file_name|
          expiration_date = expiration_date file_name
          expiration_date > request_time
        }
        logger.debug "Found #{live.size} live cache instances"
        return unless live.any?
        logger.debug "Selecting most recent live instance"
        instance = live.sort_by { |file_name|
          expiration_date file_name
        }[-1]
        expiration_date = expiration_date instance
        logger.debug "Instance is #{instance}, expires = #{expiration_date}"
        instance
      end

      def expiration_date file_path
        logger.debug "Finding expiration date from #{file_path}"
        file_name = File.basename file_path
        logger.debug "File name = #{file_name}"
        timestamp, _ = file_name.split %r{#{boundary}}, 2
        logger.debug "Timestamp = #{timestamp}"
        time = Time.at timestamp.to_i
        logger.debug "Time = #{time}"
        time
      end
    end
  end
end