# frozen_string_literal: true

require 'spec_helper'

describe EasyPost::Services::BetaUser, :authenticate_prod do
  let(:client) { EasyPost::Client.new(api_key: ENV['EASYPOST_PROD_API_KEY']) }

  describe '.all' do
    it 'retrieves all child users' do
      children = client.beta_user.all_children(
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
      first_page = client.beta_user.all_children(
        page_size: Fixture.page_size,
        )

      begin
        next_page = client.beta_user.get_next_page_of_children(first_page)

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
