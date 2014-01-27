# require 'spec_helper'

# describe EasyPost::Refund do
#   describe '#create' do
#     context 'tracking code string' do
#       before :all do
#         @tracking_codes = '12345, 39474, 26547, 18373'
#       end

#       it 'creates Refunds' do
#         refunds = EasyPost::Refund.create(
#           :carrier => 'USPS',
#           :tracking_codes => @tracking_codes
#         )
#         expect(refunds).to be_an_instance_of(Array)
#         expect(refunds.size).to eq(4)
#       end
#     end
#     context 'tracking code array' do
#       before :all do
#         @tracking_codes = ['12345', '39474, 26547', 18373, '22479']
#       end

#       it 'creates Refunds' do
#         refunds = EasyPost::Refund.create(
#           :carrier => 'USPS',
#           :tracking_codes => @tracking_codes
#         )
#         expect(refunds).to be_an_instance_of(Array)
#         expect(refunds.size).to eq(5)
#       end

#       it 'fails to create without tracking codes' do
#         expect{EasyPost::Refund.create()}.to raise_error(EasyPost::Error)

#         begin
#           EasyPost::Refund.create()
#         rescue EasyPost::Error => e
#           expect(e.message).to eq('Invalid or missing param: tracking_codes')
#           expect(e.param).to eq('tracking_codes')
#         end
#       end
#     end
#   end

#   describe '#retrieve' do
#     before :all do
#       @tracking_codes = '12345, 39474, 26547, 18373'
#     end
#     it 'retrieves refund' do
#       refunds = EasyPost::Refund.create(
#         :carrier => 'USPS',
#         :tracking_codes => @tracking_codes
#       )
#       refunds.each do |refund|
#         if refund.id
#           retrieved_refund = EasyPost::Refund.retrieve(refund.id)
#           expect(retrieved_refund).to be_an_instance_of(EasyPost::Refund)
#           break
#         end
#       end
#     end
#   end

# end
