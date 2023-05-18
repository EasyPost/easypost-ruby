# frozen_string_literal: true

class EasyPost::Exceptions::EndOfPaginationError < EasyPost::Exceptions::EasyPostError
  def initialize
    super EasyPost::Constants::NO_MORE_PAGES
  end
end
