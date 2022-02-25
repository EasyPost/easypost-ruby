# frozen_string_literal: true

require 'spec_helper'

describe EasyPost::Util do
  describe '#normalize_string_list' do
    it 'handles a pre-normalized list' do
      expect(described_class.normalize_string_list(%w[foo bar baz])).to eq %w[foo bar baz]
    end

    it 'handles comma-separated strings' do
      expect(described_class.normalize_string_list('foo,bar,Baz')).to eq %w[foo bar baz]
    end

    it 'handles symbols' do
      expect(described_class.normalize_string_list([:foo, :bar, :baz])).to eq %w[foo bar baz]
    end
  end
end
