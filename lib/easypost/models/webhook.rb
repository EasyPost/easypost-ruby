# frozen_string_literal: true

# Each Webhook contains the url which EasyPost will notify whenever an object in our system updates. Several types of objects are processed
# asynchronously in the EasyPost system, so whenever an object updates, an Event is sent via HTTP POST to each configured webhook URL.
class EasyPost::Models::Webhook < EasyPost::Models::EasyPostObject
end
