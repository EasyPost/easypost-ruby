# frozen_string_literal: true

class EasyPost::Errors::EndOfPaginationError < EasyPost::Errors::EasyPostError
  def initialize
    super EasyPost::Constants::NO_MORE_PAGES
  end
end
