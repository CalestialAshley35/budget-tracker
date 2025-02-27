import 'dart:io';
import 'dart:convert';
import 'dart:math';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

enum TransactionType { income, expense }

class Transaction {
  final String id;
  final String description;
  final double amount;
  final DateTime date;
  final String category;
  final TransactionType type;

  Transaction({
    required this.description,
    required this.amount,
    required this.type,
    required this.category,
    DateTime? date,
  })  : id = const Uuid().v4(),
        date = date ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'description': description,
      'amount': amount,
      'date': date.toIso8601String(),
      'category': category,
      'type': type.toString(),
    };
  }

  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
      description: map['description'],
      amount: double.parse(map['amount']),
      type: TransactionType.values.firstWhere(
        (e) => e.toString() == map['type'],
      ),
      category: map['category'],
      date: DateTime.parse(map['date']),
    );
  }
}

class BudgetTracker {
  final List<Transaction> _transactions = [];
  final Set<String> _categories = {'Food', 'Utilities', 'Rent', 'Salary', 'Other'};

  List<Transaction> get transactions => List.unmodifiable(_transactions);
  Set<String> get categories => Set.unmodifiable(_categories);

  void addCategory(String category) => _categories.add(category);
  void removeCategory(String category) => _categories.remove(category);

  void addTransaction(Transaction transaction) => _transactions.add(transaction);

  void editTransaction(String id, Transaction newTransaction) {
    final index = _transactions.indexWhere((t) => t.id == id);
    if (index != -1) {
      _transactions[index] = newTransaction;
    }
  }

  void deleteTransaction(String id) => _transactions.removeWhere((t) => t.id == id);

  double get totalIncome => _transactions
      .where((t) => t.type == TransactionType.income)
      .fold(0.0, (sum, t) => sum + t.amount);

  double get totalExpenses => _transactions
      .where((t) => t.type == TransactionType.expense)
      .fold(0.0, (sum, t) => sum + t.amount);

  double get balance => totalIncome - totalExpenses;

  Map<String, double> getCategoryBreakdown(TransactionType type) {
    return _transactions
        .where((t) => t.type == type)
        .fold<Map<String, double>>({}, (map, t) {
      map.update(t.category, (value) => value + t.amount, ifAbsent: () => t.amount);
      return map;
    });
  }

  List<Transaction> getTransactionsInDateRange(DateTime start, DateTime end) {
    return _transactions.where((t) => t.date.isAfter(start) && t.date.isBefore(end)).toList();
  }

  Future<void> exportToCSV(String filename) async {
    final file = File(filename);
    final csvData = _transactions.map((t) => 
      '${t.id},${t.description},${t.amount},${t.date.toIso8601String()},${t.category},${t.type}'
    ).join('\n');
    await file.writeAsString(csvData);
  }

  Future<void> importFromCSV(String filename) async {
    final file = File(filename);
    final lines = await file.readAsLines();
    _transactions.clear();
    for (var line in lines) {
      final parts = line.split(',');
      _transactions.add(Transaction(
        description: parts[1],
        amount: double.parse(parts[2]),
        date: DateTime.parse(parts[3]),
        category: parts[4],
        type: parts[5] == 'TransactionType.income' 
          ? TransactionType.income 
          : TransactionType.expense,
      ));
    }
  }

  String generateReport() {
    final formatter = NumberFormat.simpleCurrency();
    final buffer = StringBuffer()
      ..writeln('Financial Report')
      ..writeln('----------------')
      ..writeln('Total Income: ${formatter.format(totalIncome)}')
      ..writeln('Total Expenses: ${formatter.format(totalExpenses)}')
      ..writeln('Net Balance: ${formatter.format(balance)}')
      ..writeln('\nIncome Breakdown:');
    
    getCategoryBreakdown(TransactionType.income).forEach((category, amount) {
      buffer.writeln(' - $category: ${formatter.format(amount)}');
    });
    
    buffer.writeln('\nExpense Breakdown:');
    getCategoryBreakdown(TransactionType.expense).forEach((category, amount) {
      buffer.writeln(' - $category: ${formatter.format(amount)}');
    });
    
    return buffer.toString();
  }
}

class BudgetCLI {
  final BudgetTracker tracker = BudgetTracker();
  final NumberFormat currencyFormat = NumberFormat.simpleCurrency();
  final DateFormat dateFormat = DateFormat('yyyy-MM-dd');

  Future<void> run() async {
    while (true) {
      print('\n=== Advanced Budget Tracker ===');
      print('1. Add Transaction');
      print('2. Edit Transaction');
      print('3. Delete Transaction');
      print('4. View Summary');
      print('5. List Transactions');
      print('6. Manage Categories');
      print('7. Generate Report');
      print('8. Export Data');
      print('9. Import Data');
      print('10. Exit');
      
      final choice = _prompt('Enter choice: ');
      
      try {
        switch (choice) {
          case '1':
            await _addTransaction();
            break;
          case '2':
            await _editTransaction();
            break;
          case '3':
            await _deleteTransaction();
            break;
          case '4':
            _displaySummary();
            break;
          case '5':
            _listTransactions();
            break;
          case '6':
            await _manageCategories();
            break;
          case '7':
            print(tracker.generateReport());
            break;
          case '8':
            await _exportData();
            break;
          case '9':
            await _importData();
            break;
          case '10':
            exit(0);
          default:
            print('Invalid choice');
        }
      } catch (e) {
        print('Error: $e');
      }
    }
  }

  Future<void> _addTransaction() async {
    final type = _prompt('Income or Expense? (I/E): ').toUpperCase() == 'I'
      ? TransactionType.income
      : TransactionType.expense;

    final description = _prompt('Description: ');
    final amount = _readDouble('Amount: ');
    final category = _selectCategory();
    final date = _readDate('Date (YYYY-MM-DD): ');

    tracker.addTransaction(Transaction(
      description: description,
      amount: amount,
      type: type,
      category: category,
      date: date,
    ));
    print('Transaction added successfully.');
  }

  Future<void> _editTransaction() async {
    final id = _prompt('Enter transaction ID to edit: ');
    final transaction = tracker.transactions.firstWhere(
      (t) => t.id == id,
      orElse: () => throw Exception('Transaction not found'),
    );

    final description = _prompt('New description [${transaction.description}]: ',
      defaultValue: transaction.description);
    final amount = _readDouble('New amount [${transaction.amount}]',
      defaultValue: transaction.amount);
    final category = _selectCategory(defaultCategory: transaction.category);
    final date = _readDate('New date [${dateFormat.format(transaction.date)}]',
      defaultValue: transaction.date);

    tracker.editTransaction(id, Transaction(
      description: description,
      amount: amount,
      type: transaction.type,
      category: category,
      date: date,
    ));
    print('Transaction updated successfully.');
  }

  Future<void> _deleteTransaction() async {
    final id = _prompt('Enter transaction ID to delete: ');
    tracker.deleteTransaction(id);
    print('Transaction deleted successfully.');
  }

  void _displaySummary() {
    print('\n=== Financial Summary ===');
    print('Total Income: ${currencyFormat.format(tracker.totalIncome)}');
    print('Total Expenses: ${currencyFormat.format(tracker.totalExpenses)}');
    print('Current Balance: ${currencyFormat.format(tracker.balance)}');
  }

  void _listTransactions() {
    final transactions = tracker.transactions;
    if (transactions.isEmpty) {
      print('No transactions found.');
      return;
    }

    print('\n=== Transactions ===');
    for (var t in transactions) {
      print('[${t.id}] ${dateFormat.format(t.date)} '
        '${t.type.toString().split('.').last.padRight(7)} '
        '${t.category.padRight(15)} '
        '${currencyFormat.format(t.amount).padLeft(10)} '
        '- ${t.description}');
    }
  }

  Future<void> _manageCategories() async {
    while (true) {
      print('\n=== Categories ===');
      tracker.categories.forEach(print);
      print('\n1. Add Category\n2. Remove Category\n3. Back');
      
      switch (_prompt('Choose option: ')) {
        case '1':
          tracker.addCategory(_prompt('Enter new category: '));
          break;
        case '2':
          tracker.removeCategory(_prompt('Enter category to remove: '));
          break;
        case '3':
          return;
        default:
          print('Invalid option');
      }
    }
  }

  String _selectCategory({String? defaultCategory}) {
    final categories = tracker.categories.toList();
    while (true) {
      print('\nAvailable categories:');
      categories.asMap().forEach((i, c) => print('${i + 1}. $c'));
      final choice = _prompt('Select category [${defaultCategory ?? ''}]: ',
        defaultValue: defaultCategory);

      if (categories.contains(choice)) return choice;
      final index = int.tryParse(choice);
      if (index != null && index > 0 && index <= categories.length) {
        return categories[index - 1];
      }
      print('Invalid category selection');
    }
  }

  DateTime _readDate(String promptText, {DateTime? defaultValue}) {
    while (true) {
      try {
        final input = _prompt(promptText, defaultValue: 
          defaultValue != null ? dateFormat.format(defaultValue) : null);
        return dateFormat.parseStrict(input);
      } on FormatException {
        print('Invalid date format. Use YYYY-MM-DD');
      }
    }
  }

  double _readDouble(String promptText, {double? defaultValue}) {
    while (true) {
      try {
        final input = _prompt(promptText, defaultValue: defaultValue?.toString());
        return double.parse(input);
      } on FormatException {
        print('Invalid number format');
      }
    }
  }

  String _prompt(String message, {String? defaultValue}) {
    stdout.write('$message ');
    if (defaultValue != null) stdout.write('[$defaultValue] ');
    final input = stdin.readLineSync()?.trim();
    return input?.isNotEmpty == true ? input! : defaultValue ?? '';
  }

  Future<void> _exportData() async {
    final filename = _prompt('Enter filename to export: ');
    await tracker.exportToCSV(filename);
    print('Data exported successfully to $filename');
  }

  Future<void> _importData() async {
    final filename = _prompt('Enter filename to import: ');
    await tracker.importFromCSV(filename);
    print('Data imported successfully from $filename');
  }
}

void main() => BudgetCLI().run();