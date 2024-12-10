# frozen_string_literal: true

require "decidim/additional_authorization_handler/workflow"
require "decidim/additional_authorization_handler/engine"
require "decidim/additional_authorization_handler/extends/proposal_serializer_extend"
#require "decidim/additional_authorization_handler/extends/csv_exporter_extend"
require "decidim/additional_authorization_handler/extends/excel_exporter_extend"
#require "decidim/additional_authorization_handler/extends/json_exporter_extend"

module Decidim
  # This namespace holds the logic of the `AdditionalAuthorizationHandler` component. This component
  # allows users to create additional_authorization_handler in a participatory space.
  module AdditionalAuthorizationHandler
  end
end
