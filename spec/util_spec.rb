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

  describe '#os_name' do
    it 'returns correct OS name for Linux' do
      stub_const('RUBY_PLATFORM', 'linux')
      expect(described_class.os_name).to eq 'Linux'
    end

    it 'returns correct OS name for Darwin' do
      stub_const('RUBY_PLATFORM', 'darwin')
      expect(described_class.os_name).to eq 'Darwin'
    end

    it 'returns correct OS name for Windows' do
      stub_const('RUBY_PLATFORM', 'wince')
      expect(described_class.os_name).to eq 'Windows'
    end

    it 'returns correct OS name for Unknown' do
      stub_const('RUBY_PLATFORM', 'other-os')
      expect(described_class.os_name).to eq 'Unknown'
    end
  end

  describe '#form_encode_params' do
    it 'form-encodes params' do
      expect(described_class.form_encode_params({ parent_key: { nested_key: '123' } }))
        .to eq({ 'parent_key[nested_key]' => '123' })
    end
  end
end
