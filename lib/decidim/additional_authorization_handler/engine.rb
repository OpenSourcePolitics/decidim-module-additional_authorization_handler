# frozen_string_literal: true

require "rails"
require "decidim/core"

module Decidim
  module AdditionalAuthorizationHandler
    # This is the engine that runs on the public interface of additional_authorization_handler.
    class Engine < ::Rails::Engine
      isolate_namespace Decidim::AdditionalAuthorizationHandler

      routes do
        # Add engine routes here
        # resources :additional_authorization_handler
        # root to: "additional_authorization_handler#index"
      end

      initializer "additional_authorization_handler.mount_routes" do
        Decidim::Core::Engine.routes do
          mount Decidim::AdditionalAuthorizationHandler::Engine => "/"
        end
      end

      initializer "AdditionalAuthorizationHandler.webpacker.assets_path" do
        Decidim.register_assets_path File.expand_path("app/packs", root)
      end

      initializer "additional_authorization_handler" do
        config.to_prepare do
          Decidim::Proposals::ProposalSerializer.prepend(Decidim::AdditionalAuthorizationHandler::Extends::ProposalSerializerExtend)

          require "decidim/additional_authorization_handler/extends/csv_exporter_extend"
          require "decidim/additional_authorization_handler/extends/excel_exporter_extend"
          require "decidim/additional_authorization_handler/extends/json_exporter_extend"
        end
      end
    end
  end
end
