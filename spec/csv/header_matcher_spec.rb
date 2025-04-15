# spec/csv/header_matcher_spec.rb

require 'rspec'
require_relative '../../lib/csv/header_matcher'

RSpec.describe Csv::HeaderMatcher do
	let(:file_path) {File.expand_path("../../data/input2.csv", __dir__) }

	describe ".get_matching_headers" do
		it "returns headers containing email when matching_type is 'email'" do
      result = described_class.get_matching_headers(file_path, "email")
      expect(result).to eq(["Email1", "Email2"])
    end
		
		it "returns headers containing phone when matching_type is 'phone'" do
      result = described_class.get_matching_headers(file_path, "phone")
      expect(result).to eq(["Phone1", "Phone2"])
    end

    it "returns headers containing both phone and email when matching_type is 'either'" do
      result = described_class.get_matching_headers(file_path, "either")
      expect(result.sort).to eq(["Email1", "Email2", "Phone1", "Phone2"])
    end

    it "returns nil or empty array for invalid match_type" do
      result = described_class.get_matching_headers(file_path, "name")
      expect(result).to be_nil.or be_empty
    end
	end
end
