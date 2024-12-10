# frozen_string_literal: true

module Decidim::AdditionalAuthorizationHandler
  module Extends
    module ExcelExporterExtend
      # Public: Exports a file in an Excel readable format.
      #
      # Returns an ExportData instance.
      def admin_export
        workbook = RubyXL::Workbook.new
        worksheet = workbook[0]

        admin_headers.each_with_index.map do |header, index|
          worksheet.change_column_width(index, 20)
          worksheet.add_cell(0, index, header)
        end

        worksheet.change_row_fill(0, "c0c0c0")
        worksheet.change_row_bold(0, true)
        worksheet.change_row_horizontal_alignment(0, "center")

        admin_processed_collection.each_with_index do |resource, index|
          admin_headers.each_with_index do |header, j|
            if resource[header].respond_to?(:strftime)
              cell = worksheet.add_cell(index + 1, j, custom_sanitize(resource[header]))
              resource[header].is_a?(Date) ? cell.set_number_format("dd.mm.yyyy") : cell.set_number_format("dd.mm.yyyy HH:MM:SS")
              next
            end
            worksheet.add_cell(index + 1, j, custom_sanitize(resource[header]))
          end
        end

        Decidim::Exporters::ExportData.new(workbook.stream.string, "xlsx")
      end
    end
  end
end

Decidim::Exporters::Excel.prepend(Decidim::AdditionalAuthorizationHandler::Extends::ExcelExporterExtend)
