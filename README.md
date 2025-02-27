# Budget Tracker CLI Application

A powerful command-line interface (CLI) tool for personal finance management, built with Dart. Track income, expenses, and get real-time financial insights with persistent storage capabilities.

## 📌 Features

- **Dual Transaction Tracking**
  - Record both income and expenses
  - Automatic balance calculation
- **Financial Insights**
  - Real-time summary statistics
  - Detailed transaction history
- **Data Persistence**
  - Local file storage (`transactions.txt`)
  - Cross-session data preservation
- **User-Friendly Interface**
  - Interactive console menu
  - Clear financial reporting
- **Platform Agnostic**
  - Runs anywhere Dart is supported

## 🚀 Installation

### Prerequisites
- Dart SDK (version 3.0+)

**Install Dart:**
```bash
# For Debian/Ubuntu
sudo apt-get install dart

# For macOS
brew tap dart-lang/dart
brew install dart

# For Windows (via Chocolatey)
choco install dart-sdk
```

### Application Setup
```bash
wget https://github.com/CalestialAshley35/budget-tracker/blob/main/src/budget_tracker.dart
dart run budget_tracker.dart
```

## 🖥 Usage

```text
=== Budget Tracker ===
1. Add Income
2. Add Expense
3. View Summary
4. View Transactions
5. Save Transactions
6. Load Transactions
7. Exit
```

### Key Operations

1. **Add Transaction**
   ```bash
   # Income Example:
   Enter income description: Freelance Project
   Enter income amount: $1500
  
   # Expense Example:
   Enter expense description: Groceries
   Enter expense amount: $87.50
   ```

2. **Financial Summary**
   ```text
   === Budget Summary ===
   Total Income: $2500.00
   Total Expenses: $987.50
   Current Balance: $1512.50
   ```

3. **Transaction History**
   ```text
   Income: Freelance Project - $1500.00
   Expense: Groceries - $87.50
   Income: Salary - $1000.00
   ```

4. **Data Management**
   - Automatic file creation on save
   - Persistent storage between sessions
   - Human-readable text format

## 📁 File Storage

Transactions are stored in `transactions.txt` using this format:
```text
Income: Freelance Project - $1500.00
Expense: Groceries - $87.50
```

### Manual Editing Tips:
1. Maintain exact format for data integrity
2. Use USD currency format
3. One transaction per line
4. Capitalize transaction types

## 🛠 Technical Considerations

- **Data Validation**
  - Ensure numeric input for amounts
  - Handle empty descriptions gracefully
- **Error Handling**
  - File I/O error prevention
  - Corrupted data fallbacks
- **Performance**
  - O(n) complexity for financial calculations
  - Linear time file operations

## 🤝 Contributing

1. Fork the repository
2. Create feature branch (`git checkout -b feature/improvement`)
3. Commit changes (`git commit -am 'Add new feature'`)
4. Push to branch (`git push origin feature/improvement`)
5. Open Pull Request

## 📜 License

© 2023 CalestialAshley35. Licensed under the [MIT License](LICENSE).

## 🌟 Acknowledgements

- Dart programming language community
- CLI application enthusiasts
- Open-source contributors
