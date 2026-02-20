enum ItemUnit {
  kg,
  L,
  pcs;

  String get name => toString().split('.').last;
}

enum ExpenseCategory {
  hardware,
  other;

  String get name => toString().split('.').last;
}
