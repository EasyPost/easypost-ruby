require 'spec_helper'

describe EasyPost::Insurance do
  let(:tracking_code)   { 'EZ2000000002' }
  let(:carrier)         { 'usps' }
  let(:amount)          { 101.00 }

  describe '#create' do
    it 'creates an insurance object' do
      insurance = EasyPost::Insurance.create(
        to_address: ADDRESS[:california],
        from_address: ADDRESS[:missouri],
        amount: amount,
        tracking_code: tracking_code,
        carrier: carrier
      )

      expect(insurance).to be_a(EasyPost::Insurance)
      expect(insurance.id).not_to be_nil
      expect(insurance.amount).to eq("101.00000")
      expect(insurance.tracking_code).to eq(tracking_code)
      expect(insurance.tracker).to be_a(EasyPost::Tracker)
    end
  end

  describe '#retrieve' do
    it 'creates an insurance object' do
      id = EasyPost::Insurance.create(
        to_address: ADDRESS[:california],
        from_address: ADDRESS[:missouri],
        amount: amount,
        tracking_code: tracking_code,
        carrier: carrier
      ).id

      insurance = EasyPost::Insurance.retrieve(id)

      expect(insurance).to be_a(EasyPost::Insurance)
      expect(insurance.id).to eq(id)
      expect(insurance.amount).to eq("101.00000")
      expect(insurance.tracking_code).to eq(tracking_code)
      expect(insurance.tracker).to be_a(EasyPost::Tracker)
    end
  end


  describe '#index' do
    it 'retrieves a full page of insurances' do
      insurances = EasyPost::Insurance.all(page_size: 5)

      expect(insurances["insurances"].count).to eq(5)
      expect(insurances["has_more"]).to eq(true)
    end

    it 'retrieves all insurances with given tracking code, up to a page' do
      insurances = EasyPost::Insurance.all(tracking_code: tracking_code, page_size: 5)

      expect(insurances["insurances"].count).to eq(5)
      expect(insurances["has_more"]).to eq(true)
    end

    it 'retrieves all insurances with given tracking code and carrier, up to a page' do
      insurances = EasyPost::Insurance.all(tracking_code: tracking_code, carrier: carrier, page_size: 5)

      expect(insurances["insurances"].count).to eq(5)
      expect(insurances["has_more"]).to eq(true)
    end
  end
end
