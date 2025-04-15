# spec/csv/uid_generator_spec.rb

require 'rspec'
require_relative '../../lib/csv/uid_generator'

RSpec.describe Csv::UidGenerator do
  let(:file_path) { File.expand_path('../fixtures/sample1.csv', __dir__) }
  let(:headers) { ["Email"] }
  let(:uid_generator) { described_class.new }

  describe "#generate_uids" do
    context "when all the rows have unique matching type" do
      it "assigns unique UIDs to each row" do
        file_path = File.expand_path('../fixtures/sample1.csv', __dir__)
        headers = ["Email"]
        result = uid_generator.generate_uids(file_path, headers)
        
        expect(result).to eq([1, 2, 3, 4])
      end
    end

    context "when there are conflicts in rows" do
      it "assigns the same UID to rows with matching data" do
        # The rows in the sample CSV have conflicts because of Email and Email2, same for phone.
        file_path = File.expand_path('../fixtures/sample2.csv', __dir__)
        headers = ["Email1", "Email2"]

        result = uid_generator.generate_uids(file_path, headers)

        # As per the sample2 CSV data
        expect(result[0..4].uniq).to eq([1])  # Rows 1 to 5 got same UID because of same matching type data
        expect(result[5]).to eq(3) # Row 6 gets a different UID
      end
    end
  end

  describe "#extract_data" do
    it "Should return data from column with header containing 'Email' " do
      row = {
        'FirstName' => 'Jane',
        'LastName' => 'Doe',
        'Phone1' => '555) 123-4567',
        'Phone2' => '(555) 654-9873',
        'Email1' => 'janed@home.com',
        'Email2'=> 'johnd@home.com',
        'Zip' => '94105'
      }
      
      headers = ["Email1", "Email2"]

      result = uid_generator.send(:extract_data, headers, row)
      
      expect(result).to eq(['janed@home.com', 'johnd@home.com'])
    end

    it "Should return data from column with header containing 'Phone' in normalized form" do
      row = {
        'FirstName' => 'Jane',
        'LastName' => 'Doe',
        'Phone1' => '(555) 123-4567',
        'Phone2' => '(555) 654-9873',
        'Email1' => '',
        'Email2'=> '',
        'Zip' => '94105'
      }

      headers = ["Phone1", "Phone2"]

      result = uid_generator.send(:extract_data, headers, row)
      
      expect(result).to eq(['5551234567', '5556549873']) 
    end

    it "Should return empty data from column with header containing 'Email'" do
      row = {
        'FirstName' => 'Jane',
        'LastName' => 'Doe',
        'Phone1' => '555) 123-4567',
        'Phone2' => '(555) 654-9873',
        'Email1' => '',
        'Email2'=> '',
        'Zip' => '94105'
      }

      headers = ["Email1", "Email2"]

      result = uid_generator.send(:extract_data, headers, row)
      
      expect(result).to eq([])
    end
  end
end
