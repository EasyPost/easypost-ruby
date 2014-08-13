require 'spec_helper'

describe EasyPost::Container do

  describe '#create' do
    it 'creates a container object' do
      container = EasyPost::Container.create(
        name: "Spec Box 1",
        length: 6.2,
        width: 12.8,
        height: 13.5,
        max_weight: 40.55,
        reference: "SPECBOX",
      )
      expect(container).to be_an_instance_of(EasyPost::Container)
      expect(container.max_weight).to eq(40.55)
    end

    it 'fails to create a container object' do
      expect { EasyPost::Container.create(
        name: "Missing dimension",
        length: 6,
        width: 12,
        max_weight: 40
      ) }.to raise_exception(EasyPost::Error, /Invalid request, if one dimension is provided all three are required./)
    end

    it 'creates a container object with default values' do
      container = EasyPost::Container.create(name: "Defaults Box")
      expect(container).to be_an_instance_of(EasyPost::Container)
      expect(container.id).to be
      expect(container.name).to eq("Defaults Box")
      expect(container.length).to eq(0.0)
      expect(container.width).to eq(0.0)
      expect(container.height).to eq(0.0)
      expect(container.max_weight).to eq(0.0)
      expect(container.type).to eq("BOX")
    end
  end

  describe '#retrieve' do
    it 'retrieves a user created container by public_id' do
      container_1 = EasyPost::Container.create(
        name: "My Box",
        length: 6.2,
        width: 12.8,
        height: 13.5,
        max_weight: 40.55,
        reference: "SPECBOX",
        type: "BAG",
      )
      container_2 = EasyPost::Container.retrieve(container_1.id)

      expect(container_1).to be_an_instance_of(EasyPost::Container)
      expect(container_2).to be_an_instance_of(EasyPost::Container)
      expect(container_2.id).to eq(container_1.id)
      expect(container_1.type).to eq("BAG")
    end

    it 'retrieves a user created container by reference' do
      container_1 = EasyPost::Container.create(
        name: "Spec Box 2",
        length: 6.2,
        width: 12.8,
        height: 133.94,
        max_weight: 40.55,
        reference: "SPECBOX4",
      )
      container_2 = EasyPost::Container.retrieve("SPECBOX4")

      expect(container_1).to be_an_instance_of(EasyPost::Container)
      expect(container_2).to be_an_instance_of(EasyPost::Container)
      expect(container_2.height).to eq(container_1.height)
      expect(container_1.type).to eq("BOX")
    end

    it 'retrieves global containers' do
      container_1 = EasyPost::Container.retrieve("container_USPSFR03")
      container_2 = EasyPost::Container.retrieve("container_USPSFR02")

      expect(container_1).to be_an_instance_of(EasyPost::Container)
      expect(container_2).to be_an_instance_of(EasyPost::Container)
      expect(container_1.reference).to eq(container_2.reference)
    end
  end

end
