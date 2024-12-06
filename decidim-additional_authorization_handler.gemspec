# frozen_string_literal: true

$LOAD_PATH.push File.expand_path("lib", __dir__)

require "decidim/additional_authorization_handler/version"

Gem::Specification.new do |s|
  s.version = Decidim::AdditionalAuthorizationHandler.version
  s.authors = ["stephanie rousset"]
  s.email = ["stephanie@opensourcepolitics.eu"]
  s.license = "AGPL-3.0"
  s.homepage = "https://decidim.org"
  s.metadata = {
    "bug_tracker_uri" => "https://github.com/decidim/decidim/issues",
    "documentation_uri" => "https://docs.decidim.org/",
    "funding_uri" => "https://opencollective.com/decidim",
    "homepage_uri" => "https://decidim.org",
    "source_code_uri" => "https://github.com/decidim/decidim"
  }
  s.required_ruby_version = "~> 3.2"

  s.name = "decidim-additional_authorization_handler"
  s.summary = "A decidim additional_authorization_handler module"
  s.description = "additional authorization handler."

  s.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").select do |f|
      (File.expand_path(f) == __FILE__) ||
        f.start_with?(*%w(app/ config/ db/ lib/ LICENSE-AGPLv3.txt Rakefile README.md))
    end
  end

  s.add_dependency "decidim-core", Decidim::AdditionalAuthorizationHandler.decidim_version
end