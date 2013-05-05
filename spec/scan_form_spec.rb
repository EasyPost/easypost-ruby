require 'spec_helper'

describe EasyPost::ScanForm do
  describe '#create' do
    context 'tracking code string' do
      before :all do
        @tracking_codes = '12345, 39474, 26547, 18373'
      end

      it 'creates a ScanForm' do
        scan_form = EasyPost::ScanForm.create(
          :from_address => address_california,
          :tracking_codes => @tracking_codes
        )
        expect(scan_form).to be_an_instance_of(EasyPost::ScanForm)
        expect(scan_form.tracking_codes).to be_an_instance_of(Array)
        expect(scan_form.tracking_codes.size).to eq(4)
      end
    end
    context 'tracking code array' do
      before :all do
        @tracking_codes = ['12345', '39474, 26547', 18373, '22479']
      end
      
      it 'creates a ScanForm' do
        scan_form = EasyPost::ScanForm.create(
          :from_address => address_missouri,
          :tracking_codes => @tracking_codes
        )
        expect(scan_form).to be_an_instance_of(EasyPost::ScanForm)
        expect(scan_form.tracking_codes).to be_an_instance_of(Array)
        expect(scan_form.tracking_codes.size).to eq(5)
      end

      it 'fails to create without tracking codes' do
        expect{EasyPost::ScanForm.create()}.to raise_error(EasyPost::Error)

        begin
          EasyPost::ScanForm.create()
        rescue EasyPost::Error => e
          #puts e.inspect
          expect(e.message).to eq('Invalid or missing param: tracking_codes')
          expect(e.param).to eq('tracking_codes')
        end
      end
    end
  end
  
  describe '#retrieve' do
    before :all do
      @tracking_codes = '12345, 39474, 26547, 18373'
    end
    it 'retrieves scan_form' do
      scan_form = EasyPost::ScanForm.create(
        :from_address => address_california,
        :tracking_codes => @tracking_codes
      )
      retrieved_scan_form = EasyPost::ScanForm.retrieve(scan_form.id)

      expect(retrieved_scan_form).to be_an_instance_of(EasyPost::ScanForm)
    end
  end
end