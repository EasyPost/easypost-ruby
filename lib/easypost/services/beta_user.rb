# frozen_string_literal: true

class EasyPost::Services::BetaUser < EasyPost::Services::Service
  # Retrieve all child Users.
  def all_children(params = {})
    filters = { key: 'children' }

    get_all_helper('users/children', EasyPost::Models::User, params, filters, true)
  end

  # Get the next page of child users.
  def get_next_page_of_children(collection, page_size = nil)
    raise EasyPost::Errors::EndOfPaginationError.new unless more_pages?(collection)

    params = { before_id: collection.children.last.id }
    params[:page_size] = page_size unless page_size.nil?

    all_children(params)
  end
end
