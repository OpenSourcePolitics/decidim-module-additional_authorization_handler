# frozen_string_literal: true

require "spec_helper"

module Decidim
  describe Exporters::JSON do
    subject { described_class.new(collection, serializer) }

    let(:serializer) do
      Class.new do
        def initialize(resource, public_scope: true)
          @resource = resource
          @public_scope = public_scope
        end

        def run
          serialize
        end

        def serialize
          {
            id: @resource.id,
            serialized_name: @resource.name
          }
        end
      end
    end

    let(:collection) do
      [OpenStruct.new(id: 1, name: "foo"), OpenStruct.new(id: 2, name: "bar")]
    end

    describe "export" do
      it "exports the collection using the right serializer" do
        json = JSON.parse(subject.export.read)
        expect(json[0]).to eq("id" => 1, "serialized_name" => "foo")
        expect(json[1]).to eq("id" => 2, "serialized_name" => "bar")
      end
    end

    describe "admin export" do
      it "exports the collection using the right serializer" do
        json = JSON.parse(subject.admin_export.read)
        expect(json[0]).to eq("id" => 1, "serialized_name" => "foo")
        expect(json[1]).to eq("id" => 2, "serialized_name" => "bar")
      end
    end
  end
end
