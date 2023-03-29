# frozen_string_literal: true

require 'spec_helper'

describe EasyPost::Address do
  describe '.get_next_page' do
    it 'retrieves the next page of a collection' do
      first_page = described_class.all(
        page_size: Fixture.page_size,
      )

      next_page = described_class.get_next_page(first_page)

      first_page_first_id = first_page.addresses.first.id
      next_page_first_id = next_page.addresses.first.id

      # Did we actually get a new page?
      expect(first_page_first_id).not_to eq(next_page_first_id)
    end

    it 'retrieves the next page of a collection with a page size' do
      first_page = described_class.all(
        page_size: Fixture.page_size,
      )

      page_size = 5

      next_page = described_class.get_next_page(first_page, page_size)
      next_page_items = next_page.addresses

      expect(next_page_items.length).to be <= page_size
    end

    describe 'throws an error' do
      it 'if has_more is false' do
        first_page = described_class.all(
          page_size: Fixture.page_size,
        )

        first_page.has_more = false

        expect { described_class.get_next_page(first_page) }.to raise_error(EasyPost::Error)
      end

      it 'if the current items are empty' do
        first_page = described_class.all(
          page_size: Fixture.page_size,
        )

        first_page.addresses = []

        expect { described_class.get_next_page(first_page) }.to raise_error(EasyPost::Error)
      end
    end
  end
end
