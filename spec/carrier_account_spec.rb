require 'spec_helper'

describe EasyPost::CarrierAccount do
  it 'performs all basic CRUD actions on a CarrierAccount' do
    original_num_cas = EasyPost::CarrierAccount.all.count

    description = "A test Ups Account"
    reference = "RubyClientUpsTestAccount"

    created_ca = EasyPost::CarrierAccount.create(
      type: "UpsAccount",
      description: description,
      reference: reference,
      credentials: {
        account_number: "A1A1A1",
        user_id: "UPSDOTCOM_USERNAME",
        password: "UPSDOTCOM_PASSWORD",
        access_license_number: "UPS_ACCESS_LICENSE_NUMBER"
      }
    )

    id = created_ca["id"]

    interm_num_cas = EasyPost::CarrierAccount.all.count
    expect(interm_num_cas).to eq(original_num_cas + 1)

    retrieved_ca = EasyPost::CarrierAccount.retrieve(id)

    expect(retrieved_ca["id"]).to eq(created_ca["id"])
    expect(retrieved_ca["description"]).to eq(description)
    expect(retrieved_ca["reference"]).to eq(reference)

    updated_description = "An updated description for a test Ups Account"
    retrieved_ca.description = updated_description
    retrieved_ca.save

    updated_ca = EasyPost::CarrierAccount.retrieve(id)
    expect(updated_ca["id"]).to eq(created_ca["id"])
    expect(updated_ca["description"]).to eq(updated_description)

    updated_ca.delete

    final_num_cas = EasyPost::CarrierAccount.all.count
    expect(final_num_cas).to eq(original_num_cas)
  end

  describe '#types' do
    let(:carrier_account_types) { [
      "AsendiaAccount",
      "AustraliaPostAccount",
      "CanadaPostAccount",
      "CanparAccount",
      "ColisPriveAccount",
      "DhlExpressAccount",
      "DhlGlobalMailAccount",
      "FastwayAccount",
      "FedexAccount",
      "FedexSmartpostAccount",
      "GsoAccount",
      "LasershipAccount",
      "LsoAccount",
      "NorcoAccount",
      "NzpostAccount",
      "OntracAccount",
      "PurolatorAccount",
      "RoyalMailAccount",
      "SpeedeeAccount",
      "TntExpressAccount",
      "UpsAccount",
      "UpsMailInnovationsAccount",
      "UpsSurepostAccount"
    ] }

    it 'returns the expected list of types' do
      types = EasyPost::CarrierAccount.types
      account_types = types.map(&:type)

      for account_type in carrier_account_types
        expect(account_types).to include(account_type)
      end
    end
  end
end
