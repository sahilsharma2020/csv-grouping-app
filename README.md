# CSV Grouping App

This is a simple Ruby app that reads a CSV file and generates a new CSV with a unique group ID (UID) prepended to each row. Grouping is based on matching fields like email, phone, or either — useful for identifying and merging duplicate entries across rows.

---

## Features

- Match rows using `email`, `phone`, or `either` (email or phone).
- Assigns consistent group IDs (UIDs) to related rows.
- Outputs a new CSV file with `UID` as the first column.
- Handles missing/blank fields and overlapping identifiers.
- Supports multiple matching columns based on headers containing substrings of the selected match type.<br>
  Example: A CSV file with columns `Email1` and `Email2` will work seamlessly when matching by `email`.
- Includes RSpec tests for all components.

---

## Getting Started

### Prerequisites

- Ruby (latest version recommended)
- Bundler

---

### Intial setup and running instructions

- Ensure that the latest Ruby version is installed on your system.
- Clone the repository

	```
	git clone https://github.com/sahilsharma2020/csv-grouping-app.git
	cd csv-grouping-app
	```

- Install dependencies:
	```
	bundle install
	```
- Run the app:
	```
	ruby bin/run.rb
	``` 
- The above command will display the following instructions:
	```
	Welcome to the CSV grouping app App!
	Please follow the instructions below:
	----------------------------------------
	1. Provide the path to the input CSV file.
	2. Choose a matching type: email, phone, or either.
	----------------------------------------
	Enter CSV file path:
	```

- To run all test cases (RSpec):
	```
   bundle exec rspec
	```

---

## Testing with Sample CSV Files

Sample input files are located in the /data folder. You can test the app using them like this:

- Run the app:
	```
	ruby bin/run.rb
	``` 
- When prompted for the CSV file path, enter:

	```
	data/{file_name.csv}
	```

- When prompted for matching type, enter one of:
	```
	email
	phone
	either
	```
- A new file with copied data with prepended UID column will be saved at the same directory with name affixed '_copy.csv'.<br>
	Example: If you choose email for data/input2.csv, the app will use all columns with "Email" in their headers (Email1, Email2, etc.) for matching.<br>
	Note: If the output file doesn't exist it will be created or be overwritten if already exists.

	---

	## Code Structure

	All the core logic is located in the `lib/csv/` directory. Each file has a specific role, as explained below:

- `processor.rb`: Handles reading/writing CSV and assigning UIDs.
- `header_matcher.rb`: Encapsulates the logic to get the headers matched matching type.
- `uid_generator.rb`: Creates and manages unique ID for each row.
- `run.rb`: CLI script to run the app interactively.


