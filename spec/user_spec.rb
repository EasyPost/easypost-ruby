require 'spec_helper'

describe EasyPost::User do
  before do
    EasyPost.api_key = "gMhH1to1hGSKgncBhkJtlA"
  end

  it 'performs all basic CRUD actions on a User' do
    me = EasyPost::User.retrieve_me
    original_children_count = me.children.count

    name = 'Ruby All-Things-Testing'

    sub_user = EasyPost::User.create(
      name: name,
      password: 'password1',
      password_confirmation: 'password1',
      phone_number: '7778675309'
    )

    id = sub_user.id
    email = sub_user.email

    retrieved_user = EasyPost::User.retrieve(id)
    expect(retrieved_user.id).to eq(id)
    expect(retrieved_user.email).to eq(email)
    expect(retrieved_user.name).to eq(name)

    new_me = EasyPost::User.retrieve_me
    interm_children_count = new_me.children.count
    expect(interm_children_count).to eq(original_children_count + 1)

    new_name = 'Ruby All-Things-Tested'
    retrieved_user.name = new_name
    retrieved_user.save

    updated_user = EasyPost::User.retrieve(id)
    expect(updated_user.id).to eq(id)
    expect(updated_user.email).to eq(email)
    expect(updated_user.name).to eq(new_name)
  end

  describe '#all_api_keys' do
    it 'returns the correct set of api_keys' do
      EasyPost.api_key = "gMhH1to1hGSKgncBhkJtlA"

      api_keys = EasyPost::User.all_api_keys

      my_keys = api_keys.keys
      expect(my_keys.first.mode).to eq("production")
      expect(my_keys.last.mode).to eq("test")

      me = EasyPost::User.retrieve_me
      children_count = me.children.count

      expect(api_keys.children.count).to eq(children_count)
    end
  end

  describe '#api_keys' do
    it 'returns different keys for the parent and child users' do
      me = EasyPost::User.retrieve_me
      my_keys = me.api_keys

      child = me.children.first
      child_keys = child.api_keys

      expect(my_keys).not_to eq(child_keys)
    end
  end
end
