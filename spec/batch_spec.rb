require 'spec_helper'

describe EasyPost::Batch do

  describe '#create' do
    it 'creates a batch object' do
      batch = EasyPost::Batch.create({
        :shipment => [{
          :from_address => ADDRESS[:california],
          :to_address   => ADDRESS[:missouri],
          :parcel       => PARCEL[:dimensions]
        }, {
          :from_address => ADDRESS[:california],
          :to_address   => ADDRESS[:canada],
          :parcel       => PARCEL[:dimensions],
        }],
        :reference => "batch123456789"
      })
      expect(batch).to be_an_instance_of(EasyPost::Batch)
      expect(batch.num_shipments).to eq(2)
      expect(batch.reference).to eq("batch123456789")
      expect(batch.state).to eq("creating")

      # sleeps_left = 10
      # while (batch.state == "creating" && sleeps_left > 0) do
      #   sleep(3)
      #   batch.refresh
      #   sleeps_left -= 1
      # end

      # expect(batch.state).to equal("created")
      # expect(batch.status[:created]).to equal(2)

    end
  end

  describe '#create_and_buy' do
    it 'creates a batch object and delayed jobs for purchasing the postage_labels' do
      batch = EasyPost::Batch.create({
        :shipment => [{
          :from_address => ADDRESS[:california],
          :to_address   => ADDRESS[:missouri],
          :parcel       => PARCEL[:dimensions],
          :carrier      => "usps",
          :service      => "priority"
        }, {
          :from_address => ADDRESS[:california],
          :to_address   => ADDRESS[:canada],
          :parcel       => PARCEL[:dimensions],
          :carrier      => "usps",
          :service      => "prioritymailinternational"
        }],
        :reference => "batch123456789"
      })
      expect(batch).to be_an_instance_of(EasyPost::Batch)
      expect(batch.state).to eq("creating")
      expect(batch.num_shipments).to eq(2)
    end
  end

end
