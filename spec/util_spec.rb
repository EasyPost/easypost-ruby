require 'spec_helper'

describe EasyPost::Util do
  describe '#url_encode' do
    it 'encodes' do
      expect(described_class.url_encode('foobar')).to eq('foobar')
      expect(described_class.url_encode('foo bar')).to eq('foo+bar')
      expect(described_class.url_encode('foo/bar')).to eq('foo%2Fbar')
      expect(described_class.url_encode('foo\\bar')).to eq('foo%5Cbar')
      expect(described_class.url_encode('foo!bar')).to eq('foo%21bar')
      expect(described_class.url_encode('foo/💩')).to eq('foo%2F%F0%9F%92%A9')
    end
  end

  describe "#flatten_params" do
    it "flattens" do
      expect(described_class.flatten_params({:foo => "bar"})).to eq([["foo", "bar"]])
      expect(described_class.flatten_params({:foo => ["bar", "baz"]})).to eq([["foo[0]", "bar"], ["foo[1]", "baz"]])
      expect(described_class.flatten_params({:foo => {"bar" => "baz"}})).to eq([["foo[bar]", "baz"]])
    end
  end
end
