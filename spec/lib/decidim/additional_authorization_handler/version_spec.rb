# frozen_string_literal: true

require "spec_helper"

module Decidim
  describe AdditionalAuthorizationHandler do
    subject { described_class }

    it "returns decidim version" do
      expect(subject.decidim_version).to eq("~> 0.31.0")
    end

    it "returns module's version" do
      expect(described_class.version).to eq("1.1.0")
    end
  end
end
