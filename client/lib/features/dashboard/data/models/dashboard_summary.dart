class DashboardTransaction {
  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final String type;
  final List<TransactionItem>? items;

  DashboardTransaction({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
    required this.type,
    this.items,
  });

  factory DashboardTransaction.fromJson(Map<String, dynamic> json) =>
      DashboardTransaction(
        id: (json['_id'] ?? json['id'] ?? '') as String,
        title: json['title'] as String,
        amount: (json['amount'] as num).toDouble(),
        date: DateTime.parse(json['date'] as String),
        type: json['type'] as String,
        items: (json['items'] as List?)
            ?.map((e) => TransactionItem.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
}

class TransactionItem {
  final String name;
  final double qty;
  final double price;
  final double total;
  final double profit;

  TransactionItem({
    required this.name,
    required this.qty,
    required this.price,
    required this.total,
    required this.profit,
  });

  factory TransactionItem.fromJson(Map<String, dynamic> json) => TransactionItem(
        name: json['name'] as String,
        qty: (json['qty'] as num).toDouble(),
        price: (json['price'] as num).toDouble(),
        total: (json['total'] as num).toDouble(),
        profit: (json['profit'] as num).toDouble(),
      );
}

class SalesHistoryPoint {
  final String date;
  final double amount;
  final double profit;

  SalesHistoryPoint({
    required this.date,
    required this.amount,
    required this.profit,
  });

  factory SalesHistoryPoint.fromJson(Map<String, dynamic> json) => SalesHistoryPoint(
        date: json['date'] as String,
        amount: (json['amount'] as num).toDouble(),
        profit: (json['profit'] as num? ?? 0).toDouble(),
      );
}

class TopItem {
  final String name;
  final double total;
  final double qty;

  TopItem({required this.name, required this.total, required this.qty});

  factory TopItem.fromJson(Map<String, dynamic> json) => TopItem(
        name: json['name'] as String,
        total: (json['total'] as num).toDouble(),
        qty: (json['qty'] as num).toDouble(),
      );
}

class ExpenseBreakdown {
  final String category;
  final double amount;

  ExpenseBreakdown({required this.category, required this.amount});

  factory ExpenseBreakdown.fromJson(Map<String, dynamic> json) => ExpenseBreakdown(
        category: json['category'] as String,
        amount: (json['amount'] as num).toDouble(),
      );
}

class DashboardSummary {
  final double totalStockValue;
  final double todaySales;
  final double monthlySales;
  final double totalExpenses;
  final double otherIncome;
  final double profit;
  final int totalItems;
  final int lowStockCount;
  final List<DashboardTransaction> recentTransactions;
  final List<DashboardTransaction>? allTransactions;
  final Map<String, double>? rangeStats;
  final List<SalesHistoryPoint>? salesHistory;
  final List<TopItem>? topItems;
  final List<ExpenseBreakdown>? expenseBreakdown;

  DashboardSummary({
    required this.totalStockValue,
    required this.todaySales,
    required this.monthlySales,
    required this.totalExpenses,
    required this.otherIncome,
    required this.profit,
    this.totalItems = 0,
    this.lowStockCount = 0,
    this.recentTransactions = const [],
    this.allTransactions,
    this.rangeStats,
    this.salesHistory,
    this.topItems,
    this.expenseBreakdown,
  });

  factory DashboardSummary.fromJson(Map<String, dynamic> json) {
    return DashboardSummary(
      totalStockValue: (json['totalStockValue'] as num).toDouble(),
      todaySales: (json['todaySales'] as num).toDouble(),
      monthlySales: (json['monthlySales'] as num).toDouble(),
      totalExpenses: (json['totalExpenses'] as num).toDouble(),
      otherIncome: (json['otherIncome'] as num).toDouble(),
      profit: (json['profit'] as num).toDouble(),
      totalItems: (json['totalItems'] as int? ?? 0),
      lowStockCount: (json['lowStockCount'] as int? ?? 0),
      recentTransactions: (json['recentTransactions'] as List? ?? [])
          .map((e) => DashboardTransaction.fromJson(e as Map<String, dynamic>))
          .toList(),
      allTransactions: (json['allTransactions'] as List?)
          ?.map((e) => DashboardTransaction.fromJson(e as Map<String, dynamic>))
          .toList(),
      rangeStats: (json['rangeStats'] as Map?)?.map(
        (k, v) => MapEntry(k as String, (v as num).toDouble()),
      ),
      salesHistory: (json['salesHistory'] as List?)
          ?.map((e) => SalesHistoryPoint.fromJson(e as Map<String, dynamic>))
          .toList(),
      topItems: (json['topItems'] as List?)
          ?.map((e) => TopItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      expenseBreakdown: (json['expenseBreakdown'] as List?)
          ?.map((e) => ExpenseBreakdown.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  DashboardSummary copyWith({
    double? totalStockValue,
    double? todaySales,
    double? monthlySales,
    double? totalExpenses,
    double? otherIncome,
    double? profit,
    int? totalItems,
    int? lowStockCount,
    List<DashboardTransaction>? recentTransactions,
    List<DashboardTransaction>? allTransactions,
    Map<String, double>? rangeStats,
    List<SalesHistoryPoint>? salesHistory,
    List<TopItem>? topItems,
    List<ExpenseBreakdown>? expenseBreakdown,
  }) {
    return DashboardSummary(
      totalStockValue: totalStockValue ?? this.totalStockValue,
      todaySales: todaySales ?? this.todaySales,
      monthlySales: monthlySales ?? this.monthlySales,
      totalExpenses: totalExpenses ?? this.totalExpenses,
      otherIncome: otherIncome ?? this.otherIncome,
      profit: profit ?? this.profit,
      totalItems: totalItems ?? this.totalItems,
      lowStockCount: lowStockCount ?? this.lowStockCount,
      recentTransactions: recentTransactions ?? this.recentTransactions,
      allTransactions: allTransactions ?? this.allTransactions,
      rangeStats: rangeStats ?? this.rangeStats,
      salesHistory: salesHistory ?? this.salesHistory,
      topItems: topItems ?? this.topItems,
      expenseBreakdown: expenseBreakdown ?? this.expenseBreakdown,
    );
  }
}
