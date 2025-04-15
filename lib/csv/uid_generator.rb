# lib/csv/uid_generator.rb
require 'csv'

module Csv
  class UidGenerator
    def initialize
      @uid = 1
      @mt_to_uid = {}
      @rows_to_uid = []
    end

    # Generate and returns an array of UIDs mapped with CSV row index as array index. 
    def generate_uids(path, headers)
      begin
        CSV.foreach(path, headers: true, skip_blanks: true).with_index do |row, idx|
          row_data = extract_data(headers, row)
          existing_ids = row_data.map { |val| @mt_to_uid[val] }.compact.uniq

          if existing_ids.empty?
            group_id = @uid
            @uid += 1
          else
            group_id = merge_conflicting_uids(existing_ids)
          end

          @rows_to_uid[idx] = group_id
          row_data.each { |val| @mt_to_uid[val] = group_id }
        end

        @rows_to_uid
      rescue CSV::MalformedCSVError => e
        puts "Error reading CSV: #{e.message}"
      end
    end

    private

    # Extract and return the row data for the provided headers.
    def extract_data(headers, row)
      data = []

      headers.each do |header|
        next if row[header].to_s.strip.empty?
        if header.include?("Phone")
          data << row[header].to_s.gsub(/\D/, '')[-10..]
          next
        end
        data << row[header]
      end

      return data
    end

    # Merge the conflicting uids and return unified id for multiple existing_ids.
    def merge_conflicting_uids(existing_ids)
      min_id = existing_ids.min
      if existing_ids.size > 1
        old_to_new_id = existing_ids.map { |old| [old, min_id] }.to_h
        
        @mt_to_uid.each do |k, v|
          if old_to_new_id[v]
            @mt_to_uid[k] = old_to_new_id[v]
          end
        end
        
        @rows_to_uid.map! { |v| old_to_new_id[v] || v }
      end
      min_id
    end
  end
end
