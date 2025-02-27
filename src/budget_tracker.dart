import 'dart:io';

class Transaction {
  String description;
  double amount;
  bool isExpense;

  Transaction(this.description, this.amount, this.isExpense);
}

class BudgetTracker {
  List<Transaction> transactions = [];

  void addTransaction(String description, double amount, bool isExpense) {
    transactions.add(Transaction(description, amount, isExpense));
  }

  double getTotalIncome() {
    return transactions
        .where((transaction) => !transaction.isExpense)
        .fold(0.0, (sum, transaction) => sum + transaction.amount);
  }

  double getTotalExpenses() {
    return transactions
        .where((transaction) => transaction.isExpense)
        .fold(0.0, (sum, transaction) => sum + transaction.amount);
  }

  double getBalance() {
    return getTotalIncome() - getTotalExpenses();
  }

  void displayTransactions() {
    if (transactions.isEmpty) {
      print('No transactions available.');
    } else {
      transactions.forEach((transaction) {
        String type = transaction.isExpense ? 'Expense' : 'Income';
        print('$type: ${transaction.description} - \$${transaction.amount}');
      });
    }
  }

  void displaySummary() {
    print('=== Budget Summary ===');
    print('Total Income: \$${getTotalIncome().toStringAsFixed(2)}');
    print('Total Expenses: \$${getTotalExpenses().toStringAsFixed(2)}');
    print('Current Balance: \$${getBalance().toStringAsFixed(2)}');
  }

  void saveTransactionsToFile() {
    final file = File('transactions.txt');
    String data = transactions.map((transaction) {
      return '${transaction.isExpense ? 'Expense' : 'Income'}: ${transaction.description} - \$${transaction.amount.toStringAsFixed(2)}';
    }).join('\n');
    file.writeAsStringSync(data);
    print('Transactions saved to transactions.txt');
  }

  void loadTransactionsFromFile() {
    final file = File('transactions.txt');
    if (file.existsSync()) {
      String data = file.readAsStringSync();
      List<String> lines = data.split('\n');
      for (var line in lines) {
        if (line.isNotEmpty) {
          var parts = line.split(' - ');
          String type = parts[0];
          String description = parts[1].split(': ')[1];
          double amount = double.parse(parts[2].substring(1));
          addTransaction(description, amount, type == 'Expense');
        }
      }
      print('Transactions loaded from transactions.txt');
    } else {
      print('No saved transactions found.');
    }
  }
}

void main() {
  BudgetTracker budgetTracker = BudgetTracker();

  while (true) {
    print('\n=== Budget Tracker ===');
    print('1. Add Income');
    print('2. Add Expense');
    print('3. View Summary');
    print('4. View Transactions');
    print('5. Save Transactions');
    print('6. Load Transactions');
    print('7. Exit');
    stdout.write('Select an option: ');

    String? input = stdin.readLineSync();

    switch (input) {
      case '1':
        stdout.write('Enter income description: ');
        String? incomeDescription = stdin.readLineSync();
        stdout.write('Enter income amount: \$');
        double incomeAmount = double.parse(stdin.readLineSync()!);
        budgetTracker.addTransaction(incomeDescription ?? 'No Description', incomeAmount, false);
        print('Income added successfully.');
        break;

      case '2':
        stdout.write('Enter expense description: ');
        String? expenseDescription = stdin.readLineSync();
        stdout.write('Enter expense amount: \$');
        double expenseAmount = double.parse(stdin.readLineSync()!);
        budgetTracker.addTransaction(expenseDescription ?? 'No Description', expenseAmount, true);
        print('Expense added successfully.');
        break;

      case '3':
        budgetTracker.displaySummary();
        break;

      case '4':
        budgetTracker.displayTransactions();
        break;

      case '5':
        budgetTracker.saveTransactionsToFile();
        break;

      case '6':
        budgetTracker.loadTransactionsFromFile();
        break;

      case '7':
        print('Exiting Budget Tracker...');
        return;

      default:
        print('Invalid option, please try again.');
    }
  }
}
