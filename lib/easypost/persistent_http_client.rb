require "net/http"

class EasyPost::PersistentHttpClient
  CONNECTION_STALE_AFTER_SECONDS = 300 # 5 minutes

  def self.get(url)
    uri = url.is_a?(URI) ? url : URI(url)
    connection_manager.get_client(uri)
  end

  # each thread gets its own connection manager
  def self.connection_manager
    # before getting a connection manager
    # we first clear all old ones
    remove_old_managers
    Thread.current[:persistent_http_connection_manager] ||= new_manager
  end

  def self.connection_managers
    @connection_managers ||= []
  end

  def self.new_manager
    # create a new connection manager in a thread safe way
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

  # mutex isn't needed for CRuby, but might be needed
  # for other Ruby implementations
  def self.mutex
    @mutex ||= Mutex.new
  end

  class HttpConfig
    def self.persistent_connection=(enabled)
      @persistence = enabled
    end

    def self.persistent_connection?
      if @persistence.nil?
        @persistence = true
      end
      @persistence
    end

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
      @http_config ||= reset_config
    end

    def self.config=(http_config_params)
      config.merge!(http_config_params)
    end
  end

  # connection manager represents
  # a cache of all keep-alive connections
  # in a current thread
  class ConnectionManager
    attr_accessor :clients_store, :last_used

    def initialize
      self.clients_store = {}
      self.last_used = Time.now
    end

    def get_client(uri)
      unless HttpConfig.persistent_connection?
        return create_client(uri)
      end

      mutex.synchronize do
        # refresh the last time a client was used,
        # this prevents the client from becoming stale
        self.last_used = Time.now

        # we use params as a cache key for clients.
        # 2 connections to the same host but with different
        # options are going to use different HTTP clients
        params = [uri.host, uri.port]

        connection = clients_store[params]
        if connection
          return connection
        end

        connection = create_client(uri)

        # open connection
        connection.start

        # cache the client
        clients_store[params] = connection

        connection
      end
    end

    def create_client(uri)
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

      connection
    end

    def configure_connection(connection)
      connection.use_ssl = true
      # dynamically set Net::HTTP options
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

    # close connections for each client
    def close_connections!
      mutex.synchronize do
        clients_store.values.each(&:finish)
        self.clients_store = {}
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
