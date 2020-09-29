require "spec_helper"

describe EasyPost::Util do
  describe "#normalize_string_list" do
    it "handles a pre-normalized list" do
      expect(EasyPost::Util.normalize_string_list(["foo", "bar", "baz"])).to eq ["foo", "bar", "baz"]
    end

    it "handles comma-separated strings" do
      expect(EasyPost::Util.normalize_string_list("foo,bar,Baz")).to eq ["foo", "bar", "baz"]
    end

    it "handles symbols" do
      expect(EasyPost::Util.normalize_string_list([:foo, :bar, :baz])).to eq ["foo", "bar", "baz"]
    end
  end
end
