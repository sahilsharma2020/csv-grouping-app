# spec/csv/processor_spec.rb

require 'rspec'
require_relative '../../lib/csv/processor'

RSpec.describe Csv::Processor do
  let(:input_file_path) { File.expand_path('../../data/input2.csv', __dir__) }
  let(:output_file_path) { input_file_path.sub('.csv', '_copy.csv') }

  after do
    File.delete(output_file_path) if File.exist?(output_file_path)
    puts '-' * 40
    puts "File delete at: #{output_file_path}"
  end

  describe "#execute" do
    it "generates a new CSV file with UIDs prepended when matching_type 'email'" do
      processor = described_class.new(input_file_path, 'email')
      processor.execute

      expect(File).to exist(output_file_path)

      result = CSV.read(output_file_path, headers: true)

      # Ensure UID is prepended in new file.
      expect(result.headers).to include("UID","FirstName","LastName","Phone1","Phone2","Email1","Email2","Zip")

      uids = result['UID']

      # Ensure rows with matching emails have same UID
      expect(uids[0]).to eq(uids[1])
      expect(uids[2]).to eq(uids[3])
      expect(uids[4]).not_to eq(uids[5])
    end

    it "generates a new CSV file with UIDs prepended when matching_type 'phone'" do
      processor = described_class.new(input_file_path, 'phone')
      processor.execute

      expect(File).to exist(output_file_path)

      result = CSV.read(output_file_path, headers: true)

      # Ensure UID is prepended in new file.
      expect(result.headers).to include("UID","FirstName","LastName","Phone1","Phone2","Email1","Email2","Zip")

      uids = result['UID']

      # Ensure rows with matching phone have same UID
      expect(uids[0]).to eq(uids[1])
      expect(uids[1]).to eq(uids[2])
      expect(uids[2]).to eq(uids[3])
      expect(uids[4]).not_to eq(uids[5])
    end

    it "generates a new CSV file with UIDs prepended when matching_type 'phone'" do
      processor = described_class.new(input_file_path, 'either')
      processor.execute

      expect(File).to exist(output_file_path)

      result = CSV.read(output_file_path, headers: true)

      # Ensure UID is prepended in new file.
      expect(result.headers).to include("UID","FirstName","LastName","Phone1","Phone2","Email1","Email2","Zip")

      uids = result['UID']

      # Ensure rows with matching emails or phone have same UID
      expect(uids[0]).to eq(uids[1])
      expect(uids[1]).to eq(uids[2])
      expect(uids[2]).to eq(uids[3])
      expect(uids[3]).to eq(uids[4])
      expect(uids[4]).not_to eq(uids[5])
    end
  end
end
