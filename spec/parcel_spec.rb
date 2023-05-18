# frozen_string_literal: true

require 'spec_helper'

describe EasyPost::Services::Parcel do
  let(:client) { EasyPost::Client.new(api_key: ENV['EASYPOST_TEST_API_KEY']) }

  describe '.create' do
    it 'creates a parcel' do
      parcel = client.parcel.create(Fixture.basic_parcel)

      expect(parcel).to be_an_instance_of(EasyPost::Models::Parcel)
      expect(parcel.id).to match('prcl_')
      expect(parcel.weight).to eq(15.4)
    end
  end

  describe '.retrieve' do
    it 'retrieves a parcel' do
      parcel = client.parcel.create(Fixture.basic_parcel)
      retrieved_parcel = client.parcel.retrieve(parcel.id)

      expect(retrieved_parcel).to be_an_instance_of(EasyPost::Models::Parcel)
      expect(retrieved_parcel.to_s).to eq(parcel.to_s)
    end
  end
end
