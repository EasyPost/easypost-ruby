# TODO: fix this
#
#require 'spec_helper'
#
#describe EasyPost::Item do
#
#  describe '#create' do
#    it 'creates an item object', focus: true do
#      item = EasyPost::Item.create(
#        name: "Spec Item",
#        description: "Spec item description",
#        harmonized_code: "66.77.90.10",
#        country_of_origin: "US",
#        length: 6.0,
#        width: 11.8,
#        height: 12.5,
#        weight: 10.55,
#        warehouse_location: "SECTION A",
#        value: 96.00,
#        sku: "V4C3D5R2Z6",
#        upc: "UPCYEAHYOUKNOWME"
#      )
#      expect(item).to be_an_instance_of(EasyPost::Item)
#      expect(item.weight).to eq(10.55)
#      expect(item.harmonized_code).to eq("66.77.90.10")
#      expect(item.sku).to eq("V4C3D5R2Z6")
#    end
#
#    it 'fails to create an item object' do
#      expect { EasyPost::Item.create(
#        length: 6,
#        width: 12,
#        height: 13,
#        weight: 40
#      ) }.to raise_exception(EasyPost::Error, /Invalid request, 'name' is required./)
#    end
#
#    it 'creates an item object with default values' do
#      item = EasyPost::Item.create(
#        name: "Default Item",
#        length: 6.0,
#        width: 8.0,
#        height: 10,
#        weight: 13,
#        value: 19.99
#      )
#      expect(item.description).to be_nil
#    end
#  end
#
#  describe '#retrieve' do
#    it 'retrieves an item by id' do
#      item = EasyPost::Item.create(
#        name: "Test Item",
#        sku: "28374662838",
#        length: 6.0,
#        width: 8.0,
#        height: 10,
#        weight: 13,
#        value: 13.00
#      )
#      id = item.id
#      item = nil
#      item = EasyPost::Item.retrieve(id)
#
#      expect(item).to be_an_instance_of(EasyPost::Item)
#      expect(item.value).to eq("13.00")
#      expect(item.sku).to eq("28374662838")
#    end
#
#    it 'retrieves an item by reference' do
#      item_1 = EasyPost::Item.create(
#        name: "Test Item",
#        reference: "81993736515",
#        length: 6.0,
#        width: 8.0,
#        height: 10,
#        weight: 13,
#        value: 13.00
#      )
#      item_2 = EasyPost::Item.retrieve(item_1.reference)
#
#      expect(item_2).to be_an_instance_of(EasyPost::Item)
#      expect(item_2.reference).to eq(item_1.reference)
#    end
#
#    it 'retrieves an item by custom reference' do
#      item_1 = EasyPost::Item.create(
#        name: "Test Item",
#        sku: "928273646",
#        length: 6.0,
#        width: 8.0,
#        height: 10,
#        weight: 13,
#        value: 17.38
#      )
#      item_2 = EasyPost::Item.retrieve_reference(sku: "928273646")
#
#      expect(item_2).to be_an_instance_of(EasyPost::Item)
#      expect(item_2.value).to eq("17.38")
#    end
#  end
#
#end

