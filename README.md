# Advanced Budget Tracker CLI (v2.0.0)

A feature-rich command-line budget tracking application with financial reporting, category management, and CSV import/export capabilities.

## Features

- **Transaction Management**
  - Add income/expense transactions with descriptions, amounts, and categories
  - Edit existing transactions
  - Delete transactions
  - View transaction history with filtering
- **Financial Insights**
  - Real-time balance calculation
  - Income/expense breakdown by category
  - Custom date range filtering
  - Comprehensive financial reports
- **Data Management**
  - CSV import/export functionality
  - Custom category management
  - Persistent data handling
- **Advanced Functionality**
  - UUID-based transaction identification
  - Localized currency formatting
  - Date parsing with validation
  - Type-safe transaction handling

## Installation

1. **Install Dart SDK** (version 2.18+)
   ```bash
   sudo apt-get install dart
   ```
2. **Download Application**
   ```bash
   wget https://github.com/CalestialAshley35/budget-tracker/raw/main/src/budget_tracker.dart
   ```
3. **Install Dependencies**
   ```bash
   dart pub add intl uuid
   ```

## Usage

```bash
dart run budget_tracker.dart
```

### Main Menu Options

| Option | Action                      | Description                                  |
|--------|-----------------------------|----------------------------------------------|
| 1      | Add Transaction             | Create new income/expense entry             |
| 2      | Edit Transaction            | Modify existing transaction                 |
| 3      | Delete Transaction          | Remove transaction by ID                    |
| 4      | View Summary                | Display current financial status            |
| 5      | List Transactions           | Show all recorded transactions              |
| 6      | Manage Categories           | Add/remove spending categories              |
| 7      | Generate Report             | Create detailed financial breakdown         |
| 8      | Export Data                 | Save transactions to CSV file               |
| 9      | Import Data                 | Load transactions from CSV file             |
| 10     | Exit                        | Quit application                            |

## Transaction Management

### Adding a Transaction
```text
1. Select transaction type (Income/Expense)
2. Enter description
3. Input amount (supports decimal values)
4. Choose from existing categories or create new
5. Specify date or use current date
```

### Example Workflow
```text
=== Advanced Budget Tracker ===
1. Add Transaction
[...]
Enter choice: 1

Income or Expense? (I/E): E
Description: Groceries
Amount: 74.50
Date (YYYY-MM-DD): 2023-08-15
[Category selection menu...]
Transaction added successfully.
```

## Data Management

### CSV Format
```csv
id,description,amount,date,category,type
d6b6f...,Groceries,74.50,2023-08-15T00:00:00.000Z,Food,TransactionType.expense
```

**Export Command**
```bash
Enter filename to export: transactions.csv
Data exported successfully to transactions.csv
```

**Import Notes**
- Clears existing transactions before import
- Requires strict CSV format matching
- Preserves original transaction IDs

## Financial Reporting

**Sample Report Output**
```text
Financial Report
----------------
Total Income: $5,000.00
Total Expenses: $3,450.00
Net Balance: $1,550.00

Income Breakdown:
 - Salary: $5,000.00

Expense Breakdown:
 - Food: $850.00
 - Rent: $2,500.00
 - Utilities: $100.00
```

## Configuration

### Category Management
- Default categories: Food, Utilities, Rent, Salary, Other
- Add unlimited custom categories
- Category-safe removal (prevents data corruption)

### Localization Settings
- Automatic currency formatting based on system locale
- Custom date formatting (ISO 8601 compliant)

## Known Limitations

- CSV import doesn't handle escaped commas in descriptions
- No native data persistence between sessions (use export/import)
- Limited to single currency handling

## Contributing

1. Fork repository
2. Create feature branch
3. Submit pull request
4. Follow Dart style guidelines

```bash
dart analyze
dart format .
```

**Report Issues**  
GitHub Issues Tracker