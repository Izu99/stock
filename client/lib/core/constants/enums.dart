enum ItemUnit {
  kg,
  L,
  pcs;

  String get name => toString().split('.').last;
}

enum StockMovementType {
  stockIn, // Purchase, Refill
  stockOut, // Sale
  wastage, // Damaged, Leaked, Expired
  adjustment; // Manual correction

  String get name => toString().split('.').last;
}

enum ExpenseCategory {
  hardware,
  other;

  String get name => toString().split('.').last;
}
