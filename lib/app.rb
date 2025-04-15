# lib/app.rb

class App
  ALLOWED_TYPES = ["email", "phone", "either"]

  def initialize
    @file_path = nil
    @matching_type = nil
  end

  def start
    display_instructions
    get_user_inputs
    process_csv
  end

  private

  def display_instructions
    puts "Welcome to the CSV grouping app App!"
    puts "Please follow the instructions below:"
    puts "-" * 40
    puts "1. Provide the path to the input CSV file."
    puts "2. Choose a matching type: email, phone, or either."
    puts "-" * 40
  end

  def get_user_inputs
    @file_path = get_valid_file_path
    @matching_type = get_valid_matching_type
  end

  def get_valid_file_path
    loop do
      print "Enter CSV file path: "
      file_path = gets.chomp.strip

      if File.exist?(file_path) && File.extname(file_path).downcase == ".csv"
        return file_path
      else
        puts "Error: Invalid file path or not a CSV file. Please try again."
      end
    end
  end

  def get_valid_matching_type
    loop do
      print "Enter matching type (email/phone/either): "
      matching_type = gets.chomp.strip.downcase

      if ALLOWED_TYPES.include?(matching_type)
        return matching_type
      else
        puts "Error: Invalid matching type. Please enter email, phone, or either."
      end
    end
  end

  def process_csv
    csv_p = Csv::Processor.new(@file_path, @matching_type)
    csv_p.execute
  end
end
