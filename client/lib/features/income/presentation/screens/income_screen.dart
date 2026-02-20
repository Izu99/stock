import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:hardware_stock_sales/l10n/app_localizations.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_widgets.dart';
import '../../data/models/income.dart';
import '../providers/income_provider.dart';

class IncomeScreen extends ConsumerWidget {
  const IncomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final incomesAsync = ref.watch(incomesProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(l10n.income),
      ),
      body: incomesAsync.when(
        data: (incomes) {
          if (incomes.isEmpty) {
            return EmptyStateWidget(
              icon: Icons.account_balance_wallet_outlined,
              title: l10n.noIncome,
              action: ElevatedButton.icon(
                onPressed: () => _showAddIncomeDialog(context, l10n, ref),
                icon: const Icon(Icons.add, size: 18),
                label: Text(l10n.addIncome),
              ),
            );
          }

          final totalIncome = incomes.fold(0.0, (sum, e) => sum + e.amount);

          return Column(
            children: [
              // Summary header
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF7C3AED), Color(0xFF5B21B6)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF7C3AED).withValues(alpha: 0.3),
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
                      child: const Icon(Icons.account_balance_wallet,
                          color: Colors.white, size: 24),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.otherIncome,
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            color: Colors.white.withValues(alpha: 0.8),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Rs. ${totalIncome.toStringAsFixed(0)}',
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
                  onRefresh: () async => ref.invalidate(incomesProvider),
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: incomes.length,
                    itemBuilder: (context, index) {
                      final income = incomes[index];
                      return _buildIncomeCard(context, income, l10n, ref);
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
            onPressed: () => ref.invalidate(incomesProvider),
            icon: const Icon(Icons.refresh, size: 18),
            label: Text(l10n.retry),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddIncomeDialog(context, l10n, ref),
        child: const Icon(Icons.add_rounded, size: 28),
      ),
    );
  }

  Widget _buildIncomeCard(
    BuildContext context,
    Income income,
    AppLocalizations l10n,
    WidgetRef ref,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider.withValues(alpha: 0.5)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFFEDE9FE),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.attach_money_rounded,
              color: Color(0xFF7C3AED), size: 22),
        ),
        title: Text(
          income.title,
          style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 15),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              DateFormat('MMM dd, yyyy').format(income.date),
              style: GoogleFonts.inter(fontSize: 12, color: AppColors.textHint),
            ),
            if (income.note != null && income.note!.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                income.note!,
                style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ],
        ),
        trailing: SizedBox(
          width: 110,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Flexible(
                child: Text(
                  'Rs. ${income.amount.toStringAsFixed(0)}',
                  textAlign: Alignment.centerRight.x > 0 ? TextAlign.end : TextAlign.start,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w700,
                    color: AppColors.success,
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(width: 2),
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert, size: 18, color: AppColors.textHint),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 40),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        const Icon(Icons.delete_outline, size: 18, color: AppColors.error),
                        const SizedBox(width: 8),
                        Text(l10n.delete, style: const TextStyle(color: AppColors.error)),
                      ],
                    ),
                  ),
                ],
                onSelected: (value) {
                  if (value == 'delete') {
                    ref.read(incomesProvider.notifier).delete(income.id);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddIncomeDialog(
    BuildContext context,
    AppLocalizations l10n,
    WidgetRef ref,
  ) {
    final titleCtrl = TextEditingController();
    final amountCtrl = TextEditingController();
    final noteCtrl = TextEditingController();
    DateTime selectedDate = DateTime.now();
    final formKey = GlobalKey<FormState>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.65,
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
                          l10n.addIncome,
                          style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w700),
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
                              validator: (v) => v == null || v.isEmpty ? l10n.required : null,
                            ),
                            const SizedBox(height: 16),
                            AppTextField(
                              controller: amountCtrl,
                              label: l10n.amount,
                              prefixIcon: Icons.attach_money,
                              keyboardType: TextInputType.number,
                              validator: (v) => v == null || v.isEmpty ? l10n.required : null,
                            ),
                            const SizedBox(height: 16),
                            AppTextField(
                              controller: TextEditingController(
                                text: DateFormat('yyyy-MM-dd').format(selectedDate),
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
                                    final income = Income(
                                      id: '',
                                      title: titleCtrl.text.trim(),
                                      amount: double.tryParse(amountCtrl.text) ?? 0,
                                      date: selectedDate,
                                      note: noteCtrl.text.trim().isEmpty
                                          ? null
                                          : noteCtrl.text.trim(),
                                    );
                                    ref.read(incomesProvider.notifier).add(income);
                                    Navigator.pop(context);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(l10n.incomeAdded),
                                        backgroundColor: AppColors.success,
                                      ),
                                    );
                                  }
                                },
                                child: Text(l10n.save),
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