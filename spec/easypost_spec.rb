require "spec_helper"

describe EasyPost do
  describe "#make_client" do
    it "respects http_config" do
      client = described_class.make_client(URI("https://www.example.com"))
      expect(client).to be_a Net::HTTP
      expect(client.use_ssl?).to be true
      expect(client.verify_mode).to eq OpenSSL::SSL::VERIFY_PEER
      expect(client.ssl_version).to eq :TLSv1_2
      expect(client.read_timeout).to eq 60
      expect(client.open_timeout).to eq 30
    end
  end

  describe "#make_request" do
    it "makes http requests to the specified url" do
      response = described_class.make_request("get", "/health/ok")
      expect(response).to eq "UP"
    end

    it "raises errors for 400s" do
      expect { described_class.make_request("get", "/asdf") }.to raise_error EasyPost::Error.new(
        "The requested resource could not be found.",
        404,
        "NOT_FOUND",
        []
      )
    end

    it "raises errors for 500s" do
      expect { described_class.make_request("get", "/health/boom") }.to raise_error EasyPost::Error.new(
        "We're sorry, something went wrong. If the problem persists please contact Support.",
        500,
        "INTERNAL_SERVER_ERROR",
        []
      )
    end
  end
end
