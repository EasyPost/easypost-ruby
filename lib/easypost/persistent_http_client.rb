require "net/http"

class EasyPost::PersistentHttpClient
  CONNECTION_STALE_AFTER_SECONDS = 300 # 5 minutes

  def self.get(url)
    uri = url.is_a?(URI) ? url : URI(url)
    connection_manager.get_connection(uri)
  end

  def self.connection_manager
    Thread.current[:persistent_http_connection_manager] ||= new_manager
  end

  def self.connection_managers
    @connection_managers ||= []
  end

  def self.new_manager
    remove_old_managers
    mutex.synchronize do
      manager = ConnectionManager.new
      connection_managers << manager
      manager
    end
  end

  def self.remove_old_managers
    mutex.synchronize do
      removed = connection_managers.reject!(&:stale?)
      (removed || []).each(&:close_connections!)
    end
  end

  def self.mutex
    @mutex ||= Mutex.new
  end

  class HttpConfig
    def self.reset_config
      @http_config = {
        timeout: 60,
        open_timeout: 30,
        verify_ssl: OpenSSL::SSL::VERIFY_PEER,
        keep_alive_timeout: 30
      }

      ruby_version = Gem::Version.new(RUBY_VERSION)
      if ruby_version >= Gem::Version.new("2.5.0")
        @http_config[:min_version] = OpenSSL::SSL::TLS1_2_VERSION
      else
        @http_config[:ssl_version] = :TLSv1_2
      end

      @http_config
    end

    def self.config
      @http_config ||= reset_http_config
    end

    def self.config=(http_config_params)
      config.merge!(http_config_params)
    end
  end

  class ConnectionManager
    attr_accessor :connections, :last_used

    def initialize
      self.connections = {}
      self.last_used = Time.now
    end

    def get_connection(uri)
      mutex.synchronize do
        self.last_used = Time.now

        params = [uri.host, uri.port]
        connection = connections[params]
        if connection
          return connection
        end
        connection = if HttpConfig.config[:proxy]
                   proxy_uri = URI(HttpConfig.config[:proxy])
                   Net::HTTP.new(
                     uri.host,
                     uri.port,
                     proxy_uri.host,
                     proxy_uri.port,
                     proxy_uri.user,
                     proxy_uri.password
                   )
                 else
                   Net::HTTP.new(uri.host, uri.port)
                 end

        configure_connection(connection)

        connection.start

        connections[params] = connection

        connection
      end
    end

    def configure_connection(connection)
      connection.use_ssl = true
      HttpConfig.config.each do |name, value|
        # Discrepancies between RestClient and Net::HTTP.
        if name == :verify_ssl
          name = :verify_mode
        elsif name == :timeout
          name = :read_timeout
        end

        # Handled in the creation of the client.
        if name == :proxy
          next
        end

        connection.send("#{name}=", value)
      end
    end

    def close_connections!
      mutex.synchronize do
        connections.values.each(&:finish)
        self.connections = {}
      end
    end

    def stale?
      Time.now - last_used > CONNECTION_STALE_AFTER_SECONDS
    end

    def mutex
      @mutex ||= Mutex.new
    end
  end
end
