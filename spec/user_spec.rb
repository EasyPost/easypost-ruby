# frozen_string_literal: true

require 'spec_helper'

describe EasyPost::Services::User, :authenticate_prod do
  let(:client) { EasyPost::Client.new(api_key: ENV['EASYPOST_PROD_API_KEY']) }

  describe '.create' do
    it 'creates a child user' do
      user = client.user.create(
        name: 'Test User',
      )

      expect(user).to be_an_instance_of(EasyPost::Models::User)
      expect(user.id).to match('user_')
      expect(user.name).to eq('Test User')

      client.user.delete(user.id) # delete the user so we don't clutter the test environment
    end
  end

  describe '.retrieve' do
    it 'retrieves a user' do
      authenticated_user = client.user.retrieve_me
      user = client.user.retrieve(authenticated_user.id)

      expect(user).to be_an_instance_of(EasyPost::Models::User)
      expect(user.id).to match('user_')
    end
  end

  describe '.retrieve_me' do
    it 'retrieves the authenticated user' do
      user = client.user.retrieve_me

      expect(user).to be_an_instance_of(EasyPost::Models::User)
      expect(user.id).to match('user_')
    end
  end

  describe '.update' do
    it 'updates a user' do
      user = client.user.retrieve_me

      test_name = 'New Test Name'

      updated_user = client.user.update(user.id, name: test_name)

      expect(updated_user).to be_an_instance_of(EasyPost::Models::User)
      expect(updated_user.id).to match('user_')
      expect(updated_user.name).to eq(test_name)
    end
  end

  describe '.delete' do
    it 'deletes a user' do
      user = client.user.create(
        name: 'Test User',
      )

      # Nothing gets returned here, simply ensure no error gets raised
      client.user.delete(user.id)
    end
  end

  describe '.update_brand' do
    it "updates the authenticated user's brand" do
      user = client.user.retrieve_me

      color = '#123456'

      brand = client.user.update_brand(
        user.id,
        { color: color },
      )

      expect(brand).to be_an_instance_of(EasyPost::Models::Brand)
      expect(brand.id).to match('brd_')
      expect(brand.color).to eq(color)
    end
  end

  describe '.all' do
    it 'retrieves all child users' do
      children = client.user.all_children(
        page_size: Fixture.page_size,
      )
      expect(children[EasyPost::InternalUtilities::Constants::FILTERS_KEY]).to be_a(Hash)

      child_user_array = children.children
      expect(child_user_array.count).to be <= Fixture.page_size
      expect(children.has_more).not_to be_nil
      expect(child_user_array).to all(be_an_instance_of(EasyPost::Models::User))
    end
  end

  describe '.get_next_page' do
    it 'retrieves the next page of a collection' do
      first_page = client.user.all_children(
        page_size: Fixture.page_size,
      )

      begin
        next_page = client.user.get_next_page_of_children(first_page)

        first_page_first_id = first_page.children.first.id
        next_page_first_id = next_page.children.first.id

        # Did we actually get a new page?
        expect(first_page_first_id).not_to eq(next_page_first_id)

        # Verify that filters are being passed along for internal reference
        expect(first_page[EasyPost::InternalUtilities::Constants::FILTERS_KEY]).to eq(
          next_page[EasyPost::InternalUtilities::Constants::FILTERS_KEY],
        )
      rescue EasyPost::Errors::EndOfPaginationError => e
        # If we get an error, make sure it's because there are no more pages.
        expect(e.message).to eq(EasyPost::Constants::NO_MORE_PAGES)
      end
    end
  end
end
