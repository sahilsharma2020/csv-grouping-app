# lib/csv/processor.rb

require 'csv'
require_relative 'header_matcher'
require_relative 'uid_generator'

module Csv
  class Processor
    def initialize(file_path, matching_type)
      @file_path = file_path
      @matching_type = matching_type.downcase
      @uid_generator = UidGenerator.new
    end

    def execute
      headers = HeaderMatcher.get_matching_headers(@file_path, @matching_type)
      
      if headers.empty?
        puts '-'* 40
        puts "Error: No matching headers found for the matching type '#{@matching_type}'. Please try a different type or verify the CSV file"
        return
      end

      row_uids = @uid_generator.generate_uids(@file_path, headers)
      write_csv(row_uids)
    end

    private

    def write_csv(row_uids)
      new_file_path = generate_new_path(@file_path)
      begin
        CSV.open(new_file_path, 'w') do |csv|
          CSV.foreach(@file_path, headers: true, skip_blanks: true).with_index do |row, idx|
            csv << ["UID"] + row.headers.to_a if csv.lineno == 0
            csv << [row_uids[idx]] + row.fields
          end
        end

        puts "-" * 40
        puts "Data copied to: #{new_file_path}"
      rescue CSV::MalformedCSVError => e
        puts "Error reading CSV: #{e.message}"
      end
    end

    def generate_new_path(file_path)
      base = File.basename(file_path, ".*")
      dir = File.dirname(file_path)
      "#{dir}/#{base}_copy.csv"
    end
  end
end
