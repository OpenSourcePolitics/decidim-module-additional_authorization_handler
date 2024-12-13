# frozen_string_literal: true

module Decidim::AdditionalAuthorizationHandler
  module Extends
    module CSVExporterExtend
      # Public: Exports a CSV serialized version of the collection using the
      # provided serializer and following the previously described strategy.
      # It injects some informations as author's data which can only be exported by admin
      #
      # Returns an ExportData instance.
      def admin_export(col_sep = Decidim.default_csv_col_sep)
        data = ::CSV.generate(headers: admin_headers, write_headers: true, col_sep:) do |csv|
          admin_processed_collection.each do |resource|
            csv << admin_headers.map { |header| custom_sanitize(resource[header]) }
          end
        end

        Decidim::Exporters::ExportData.new(data, "csv")
      end

      private

      def admin_headers
        return [] if admin_processed_collection.empty?

        admin_processed_collection.first.keys
      end

      def admin_processed_collection
        @admin_processed_collection ||= collection.map do |resource|
          flatten(@serializer.new(resource, public_scope: false).run).deep_dup
        end
      end
    end
  end
end

Decidim::Exporters::CSV.prepend(Decidim::AdditionalAuthorizationHandler::Extends::CSVExporterExtend)
