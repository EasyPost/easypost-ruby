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
  end
end
