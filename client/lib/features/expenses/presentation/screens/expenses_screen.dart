import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:stock/l10n/app_localizations.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_widgets.dart';
import '../../../../core/constants/enums.dart';
import '../../data/models/expense.dart';
import '../providers/expense_provider.dart';

class ExpensesScreen extends ConsumerWidget {
  const ExpensesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final expensesAsync = ref.watch(expensesProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: Text(l10n.expenses)),
      body: expensesAsync.when(
        data: (expenses) {
          if (expenses.isEmpty) {
            return EmptyStateWidget(
              icon: Icons.receipt_long_outlined,
              title: l10n.noExpenses,
              action: ElevatedButton.icon(
                onPressed: () => _showAddEditExpenseDialog(context, l10n, ref),
                icon: const Icon(Icons.add, size: 18),
                label: Text(l10n.addExpense),
              ),
            );
          }

          // Group by date
          final totalExpense = expenses.fold(0.0, (sum, e) => sum + e.amount);

          return Column(
            children: [
              // Summary header
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFEF5350), Color(0xFFC62828)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.error.withValues(alpha: 0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.receipt_long,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.totalExpenses,
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            color: Colors.white.withValues(alpha: 0.8),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Rs. ${totalExpense.toStringAsFixed(0)}',
                          style: GoogleFonts.inter(
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // List
              Expanded(
                child: RefreshIndicator(
                  color: AppColors.primary,
                  onRefresh: () async => ref.invalidate(expensesProvider),
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: expenses.length,
                    itemBuilder: (context, index) {
                      final expense = expenses[index];
                      return _buildExpenseCard(context, expense, l10n, ref);
                    },
                  ),
                ),
              ),
            ],
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
        error: (err, stack) => EmptyStateWidget(
          icon: Icons.error_outline,
          title: l10n.error,
          subtitle: err.toString(),
          action: ElevatedButton.icon(
            onPressed: () => ref.invalidate(expensesProvider),
            icon: const Icon(Icons.refresh, size: 18),
            label: Text(l10n.retry),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddEditExpenseDialog(context, l10n, ref),
        child: const Icon(Icons.add_rounded, size: 28),
      ),
    );
  }

  Widget _buildExpenseCard(
    BuildContext context,
    Expense expense,
    AppLocalizations l10n,
    WidgetRef ref,
  ) {
    final isHardware = expense.category == ExpenseCategory.hardware;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider.withValues(alpha: 0.5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _showAddEditExpenseDialog(
            context,
            l10n,
            ref,
            existingExpense: expense,
          ),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                // Icon
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: isHardware
                        ? AppColors.warningLight
                        : AppColors.infoLight,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    isHardware ? Icons.build_rounded : Icons.receipt_outlined,
                    color: isHardware ? AppColors.warning : AppColors.info,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 14),
                // Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        expense.title,
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 8,
                        runSpacing: 4,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              expense.category.name,
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Text(
                            DateFormat('MMM dd, yyyy').format(expense.date),
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: AppColors.textHint,
                            ),
                          ),
                        ],
                      ),
                      if (expense.note != null && expense.note!.isNotEmpty) ...[
                        const SizedBox(height: 2),
                        Text(
                          expense.note!,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
                // Amount + Menu
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Rs. ${expense.amount.toStringAsFixed(0)}',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w700,
                        color: AppColors.error,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 4),
                PopupMenuButton<String>(
                  icon: const Icon(
                    Icons.more_vert,
                    size: 20,
                    color: AppColors.textHint,
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(minWidth: 40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          const Icon(
                            Icons.edit_outlined,
                            size: 18,
                            color: AppColors.primary,
                          ),
                          const SizedBox(width: 8),
                          Text(l10n.edit),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          const Icon(
                            Icons.delete_outline,
                            size: 18,
                            color: AppColors.error,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            l10n.delete,
                            style: const TextStyle(color: AppColors.error),
                          ),
                        ],
                      ),
                    ),
                  ],
                  onSelected: (value) {
                    if (value == 'edit') {
                      _showAddEditExpenseDialog(
                        context,
                        l10n,
                        ref,
                        existingExpense: expense,
                      );
                    } else if (value == 'delete') {
                      ref.read(expensesProvider.notifier).delete(expense.id);
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showAddEditExpenseDialog(
    BuildContext context,
    AppLocalizations l10n,
    WidgetRef ref, {
    Expense? existingExpense,
  }) {
    final isEdit = existingExpense != null;
    final titleCtrl = TextEditingController(text: existingExpense?.title ?? '');
    final amountCtrl = TextEditingController(
      text: existingExpense?.amount.toString() ?? '',
    );
    final noteCtrl = TextEditingController(text: existingExpense?.note ?? '');
    ExpenseCategory selectedCategory =
        existingExpense?.category ?? ExpenseCategory.other;
    DateTime selectedDate = existingExpense?.date ?? DateTime.now();
    final formKey = GlobalKey<FormState>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.7,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 12),
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.divider,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          isEdit ? l10n.editExpense : l10n.addExpense,
                          style: GoogleFonts.inter(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(20),
                      child: Form(
                        key: formKey,
                        child: Column(
                          children: [
                            AppTextField(
                              controller: titleCtrl,
                              label: l10n.title,
                              prefixIcon: Icons.label_outline,
                              validator: (v) =>
                                  v == null || v.isEmpty ? l10n.required : null,
                            ),
                            const SizedBox(height: 16),
                            AppTextField(
                              controller: amountCtrl,
                              label: l10n.amount,
                              prefixIcon: Icons.attach_money,
                              keyboardType: TextInputType.number,
                              validator: (v) =>
                                  v == null || v.isEmpty ? l10n.required : null,
                            ),
                            const SizedBox(height: 16),
                            AppDropdownField<ExpenseCategory>(
                              label: l10n.category,
                              value: selectedCategory,
                              prefixIcon: Icons.category_outlined,
                              items: ExpenseCategory.values
                                  .map(
                                    (c) => DropdownMenuItem(
                                      value: c,
                                      child: Text(c.name),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (val) {
                                if (val != null) {
                                  setModalState(() => selectedCategory = val);
                                }
                              },
                            ),
                            const SizedBox(height: 16),
                            AppTextField(
                              controller: TextEditingController(
                                text: DateFormat(
                                  'yyyy-MM-dd',
                                ).format(selectedDate),
                              ),
                              label: l10n.date,
                              prefixIcon: Icons.calendar_today_outlined,
                              readOnly: true,
                              onTap: () async {
                                final picked = await showDatePicker(
                                  context: context,
                                  initialDate: selectedDate,
                                  firstDate: DateTime(2020),
                                  lastDate: DateTime.now(),
                                );
                                if (picked != null) {
                                  setModalState(() => selectedDate = picked);
                                }
                              },
                            ),
                            const SizedBox(height: 16),
                            AppTextField(
                              controller: noteCtrl,
                              label: l10n.note,
                              prefixIcon: Icons.note_outlined,
                              maxLines: 2,
                            ),
                            const SizedBox(height: 24),
                            SizedBox(
                              width: double.infinity,
                              height: 52,
                              child: ElevatedButton(
                                onPressed: () {
                                  if (formKey.currentState!.validate()) {
                                    final expense = Expense(
                                      id: existingExpense?.id ?? '',
                                      title: titleCtrl.text.trim(),
                                      amount:
                                          double.tryParse(amountCtrl.text) ?? 0,
                                      category: selectedCategory,
                                      date: selectedDate,
                                      note: noteCtrl.text.trim().isEmpty
                                          ? null
                                          : noteCtrl.text.trim(),
                                    );

                                    if (isEdit) {
                                      ref
                                          .read(expensesProvider.notifier)
                                          .updateExpense(expense);
                                    } else {
                                      ref
                                          .read(expensesProvider.notifier)
                                          .add(expense);
                                    }

                                    Navigator.pop(context);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          isEdit
                                              ? l10n.expenseUpdated
                                              : l10n.expenseAdded,
                                        ),
                                        backgroundColor: AppColors.success,
                                      ),
                                    );
                                  }
                                },
                                child: Text(isEdit ? l10n.update : l10n.save),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
