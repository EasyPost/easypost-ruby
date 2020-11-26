require "spec_helper"

describe EasyPost do
  describe "#http_config=" do
    it "defaults correctly" do
      expect(described_class.http_config[:timeout]).to eq 60
    end

    it "overrides existing without destorying others" do
      described_class.http_config = {timeout: 15}
      expect(described_class.http_config[:timeout]).to eq 15
      expect(described_class.http_config[:open_timeout]).to eq 30
    end

    it "adds new without destroying others" do
      described_class.http_config = {proxy: "http://foo:bar@127.0.0.1:5000"}
      expect(described_class.http_config[:proxy]).to eq "http://foo:bar@127.0.0.1:5000"
      expect(described_class.http_config[:open_timeout]).to eq 30
    end
  end

  describe "#make_client" do
    it "respects http_config" do
      client = described_class.make_client(URI("https://www.example.com"))
      expect(client).to be_a Net::HTTP
      expect(client.use_ssl?).to be true
      expect(client.verify_mode).to eq OpenSSL::SSL::VERIFY_PEER
      expect(client.read_timeout).to eq 60
      expect(client.open_timeout).to eq 30

      ruby_version = Gem::Version.new(RUBY_VERSION)
      if ruby_version >= Gem::Version.new("2.5.0")
        expect(client.min_version).to eq OpenSSL::SSL::TLS1_2_VERSION
      else
        expect(client.ssl_version).to eq :TLSv1_2
      end
    end
  end

  describe "#make_request" do
    it "makes http requests to the specified url" do
      response = described_class.make_request("get", "/health/ok")
      expect(response).to eq "UP"
    end

    it 'stores the http_body on the error' do
      expect { described_class.make_request("get", "/health/boom", nil) }.to raise_error(EasyPost::Error) { |error|
        expect(error.http_body).to eq(
          '{"error":{"code":"INTERNAL_SERVER_ERROR","message":"We\'re sorry, something went wrong. If the problem persists please contact Support.","errors":[]}}',
        )
      }
    end

    it "raises errors for 400s" do
      expect { described_class.make_request("get", "/asdf") }.to raise_error EasyPost::Error.new(
        "The requested resource could not be found.",
        404,
        "NOT_FOUND",
        [],
        anything,
      )
    end

    it "raises errors for 500s" do
      expect { described_class.make_request("get", "/health/boom") }.to raise_error EasyPost::Error.new(
        "We're sorry, something went wrong. If the problem persists please contact Support.",
        500,
        "INTERNAL_SERVER_ERROR",
        [],
        anything,
      )
    end
  end
end
