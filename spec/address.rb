require 'easypost'
EasyPost.api_key = "cueqNZUb3ldeWTNX7MU3Mel8UXtaAMUi"

describe EasyPost::Address, "#create" do
  it "create an address" do
    to_address = EasyPost::Address.create(
      :name => 'Sawyer Bateman',
      :street1 => "1A Larkspur Cres.",
      :city => "St. Albert",
      :state => "AB",
      :zip => "t8n2m4",
      :country => "CA"
    )
    puts to_address.inspect
  end
end