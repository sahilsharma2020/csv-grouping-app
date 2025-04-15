# lib/csv/header_matcher.rb
require 'csv'

module Csv
  module HeaderMatcher
    def self.get_matching_headers(path, matching_type)
      headers = CSV.read(path, headers: true).headers.map(&:strip)
      
      if matching_type == "either"
        headers.select { |h| h.downcase.include?("email") || h.downcase.include?("phone") }
      elsif ["email", "phone"].include?(matching_type)
        headers.select { |h| h.downcase.include?(matching_type) }
      end
    end
  end
end
