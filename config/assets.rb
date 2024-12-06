# frozen_string_literal: true

base_path = File.expand_path("..", __dir__)

Decidim::Webpacker.register_path("#{base_path}/app/packs")
Decidim::Webpacker.register_entrypoints(
  decidim_additional_authorization_handler: "#{base_path}/app/packs/entrypoints/decidim_additional_authorization_handler.js",
  decidim_additional_authorization_handler_css: "#{base_path}/app/packs/stylesheets/decidim/additional_authorization_handler/additional_authorization_handler.scss"
)
#Decidim::Webpacker.register_stylesheet_import("stylesheets/decidim/additional_authorization_handler/additional_authorization_handler")
