# require 'spec_helper'

# describe 'usps electronic merchandise return service' do
#   before(:all) do
#     @first = EasyPost::Shipment.create(
#       :to_address   => ADDRESS[:california],
#       :from_address => ADDRESS[:missouri],
#       :parcel       => PARCEL[:dimensions_light],
#       :is_return    => true
#     )
#     @first.buy(:rate => @first.lowest_rate("USPSElectronicMerchandiseReturn",
#                                            "First"))

#     @priority = EasyPost::Shipment.create(
#       :to_address   => ADDRESS[:california],
#       :from_address => ADDRESS[:missouri],
#       :parcel       => PARCEL[:dimensions],
#       :is_return    => true
#     )
#     @priority.buy(:rate => @priority.lowest_rate("USPSElectronicMerchandiseReturn",
#                                                  "Priority"))

#     @bpm = EasyPost::Shipment.create(
#       :to_address   => ADDRESS[:california],
#       :from_address => ADDRESS[:missouri],
#       :parcel       => PARCEL[:dimensions_light],
#       :is_return    => true
#     )
#     @bpm.buy(:rate => @bpm.lowest_rate("USPSElectronicMerchandiseReturn",
#                                        "BoundPrintedMatter"))

#     @media = EasyPost::Shipment.create(
#       :to_address   => ADDRESS[:california],
#       :from_address => ADDRESS[:missouri],
#       :parcel       => PARCEL[:dimensions],
#       :is_return    => true
#     )
#     @media.buy(:rate => @media.lowest_rate("USPSElectronicMerchandiseReturn",
#                                            "MediaMail"))

#     @library = EasyPost::Shipment.create(
#       :to_address   => ADDRESS[:california],
#       :from_address => ADDRESS[:missouri],
#       :parcel       => PARCEL[:dimensions],
#       :is_return    => true
#     )
#     @library.buy(:rate => @library.lowest_rate("USPSElectronicMerchandiseReturn",
#                                                "LibraryMail"))
#   end

#   it 'buys a first label' do
#     expect(@first).to be_an_instance_of(EasyPost::Shipment)
#     expect(@first.selected_rate).to be_an_instance_of(EasyPost::Rate)
#     expect(@first.selected_rate.service).to eq("First")
#     expect(@first.postage_label.label_url).to end_with(".png")
#     expect(@first.tracking_code).to eq("9499907123456123456781")

#     label = open(@first.postage_label.label_url)
#     expect(label.size).to be > 30000
#   end

#    it 'buys a priority label' do
#     expect(@priority.selected_rate.service).to eq("Priority")
#     expect(@priority.tracking_code).to eq("9499907123456123456781")

#     label = open(@priority.postage_label.label_url)
#     expect(label.size).to be > 30000
#   end

#   it 'buys a bpm label' do
#     expect(@bpm.selected_rate.service).to eq("BoundPrintedMatter")
#     expect(@bpm.tracking_code).to eq("9499907123456123456781")

#     label = open(@bpm.postage_label.label_url)
#     expect(label.size).to be > 30000
#   end

#   it 'buys a media mail label' do
#     expect(@media.selected_rate.service).to eq("MediaMail")
#     expect(@media.tracking_code).to eq("9499907123456123456781")

#     label = open(@media.postage_label.label_url)
#     expect(label.size).to be > 30000
#   end

#   it 'buys a library mail label' do
#     expect(@library.selected_rate.service).to eq("LibraryMail")
#     expect(@library.tracking_code).to eq("9499907123456123456781")

#     label = open(@library.postage_label.label_url)
#     expect(label.size).to be > 30000
#   end

# end
