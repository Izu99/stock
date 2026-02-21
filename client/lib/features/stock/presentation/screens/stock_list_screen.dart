import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:Stock/l10n/app_localizations.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_widgets.dart';
import '../../../../core/constants/enums.dart';
import '../../data/models/stock_item.dart';
import '../providers/stock_provider.dart';

class StockListScreen extends ConsumerStatefulWidget {
  const StockListScreen({super.key});

  @override
  ConsumerState<StockListScreen> createState() => _StockListScreenState();
}

class _StockListScreenState extends ConsumerState<StockListScreen> {
  String _searchQuery = '';
  String _selectedCategory = 'All';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final stockAsyncValue = ref.watch(stockProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(l10n.stock),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list_rounded),
            onPressed: _showFilterSheet,
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.divider),
              ),
              child: TextField(
                style: GoogleFonts.inter(fontSize: 15),
                decoration: InputDecoration(
                  hintText: l10n.search,
                  prefixIcon: const Icon(Icons.search_rounded, size: 20, color: AppColors.textHint),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
                onChanged: (value) => setState(() => _searchQuery = value),
              ),
            ),
          ),

          // Stock Count + Category Chips
          stockAsyncValue.when(
            data: (stockItems) {
              final categories = ['All', ...{...stockItems.map((e) => e.category)}];
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  children: [
                    SizedBox(
                      height: 36,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: categories.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 8),
                        itemBuilder: (context, index) {
                          final cat = categories.elementAt(index);
                          final isSelected = _selectedCategory == cat;
                          return GestureDetector(
                            onTap: () => setState(() => _selectedCategory = cat),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              decoration: BoxDecoration(
                                color: isSelected ? AppColors.primary : Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: isSelected ? AppColors.primary : AppColors.border,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  cat == 'All' ? l10n.all : cat,
                                  style: GoogleFonts.inter(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color: isSelected ? Colors.white : AppColors.textSecondary,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),

          // Stock List
          Expanded(
            child: stockAsyncValue.when(
              data: (stockItems) {
                var filteredItems = stockItems.where((item) =>
                    item.name.toLowerCase().contains(_searchQuery.toLowerCase()));
                if (_selectedCategory != 'All') {
                  filteredItems = filteredItems.where((item) => item.category == _selectedCategory);
                }
                final items = filteredItems.toList();

                if (items.isEmpty) {
                  return EmptyStateWidget(
                    icon: Icons.inventory_2_outlined,
                    title: l10n.noItems,
                    subtitle: l10n.tapToAdd,
                    action: ElevatedButton.icon(
                      onPressed: () => _showAddEditDialog(context, l10n, ref),
                      icon: const Icon(Icons.add, size: 18),
                      label: Text(l10n.addItem),
                    ),
                  );
                }

                return RefreshIndicator(
                  color: AppColors.primary,
                  onRefresh: () async => ref.invalidate(stockProvider),
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      final isLowStock = item.quantity < 10;
                      return _buildStockCard(context, item, isLowStock, l10n, ref);
                    },
                  ),
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
                  onPressed: () => ref.invalidate(stockProvider),
                  icon: const Icon(Icons.refresh, size: 18),
                  label: Text(l10n.retry),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddEditDialog(context, l10n, ref),
        child: const Icon(Icons.add_rounded, size: 28),
      ),
    );
  }

  Widget _buildStockCard(
    BuildContext context,
    StockItem item,
    bool isLowStock,
    AppLocalizations l10n,
    WidgetRef ref,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isLowStock
              ? AppColors.warning.withValues(alpha: 0.5)
              : AppColors.divider.withValues(alpha: 0.5),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _showAddEditDialog(context, l10n, ref, existingItem: item),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                // Item Icon
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.primarySurface,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _getUnitIcon(item.unit),
                    color: AppColors.primary,
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
                        item.name,
                        style: GoogleFonts.inter(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
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
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              item.category,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Text(
                            '${item.quantity.toStringAsFixed(item.quantity == item.quantity.roundToDouble() ? 0 : 1)} ${item.unit.name}',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: isLowStock ? AppColors.warning : AppColors.textSecondary,
                              fontWeight: isLowStock ? FontWeight.w600 : FontWeight.w400,
                            ),
                          ),
                          if (isLowStock)
                            Icon(
                              Icons.warning_amber_rounded,
                              size: 14,
                              color: AppColors.warning,
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Price + Actions
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Rs. ${item.sellPrice.toStringAsFixed(0)}',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Buy: Rs. ${item.buyPrice.toStringAsFixed(0)}',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: AppColors.textHint,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 4),
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert, color: AppColors.textHint, size: 20),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          const Icon(Icons.edit_outlined, size: 18, color: AppColors.primary),
                          const SizedBox(width: 8),
                          Text(l10n.editItem),
                        ],
                      ),
                    ),
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
                    if (value == 'edit') {
                      _showAddEditDialog(context, l10n, ref, existingItem: item);
                    } else if (value == 'delete') {
                      _showDeleteConfirmation(context, l10n, ref, item);
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

  IconData _getUnitIcon(ItemUnit unit) {
    switch (unit) {
      case ItemUnit.kg:
        return Icons.scale_rounded;
      case ItemUnit.L:
        return Icons.water_drop_rounded;
      case ItemUnit.pcs:
        return Icons.category_rounded;
    }
  }

  void _showFilterSheet() {
    // Simple bottom sheet filter
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Filter Options',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.sort_by_alpha),
                title: const Text('Sort by Name'),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                leading: const Icon(Icons.arrow_downward),
                title: const Text('Price: Low to High'),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                leading: const Icon(Icons.arrow_upward),
                title: const Text('Price: High to Low'),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                leading: Icon(Icons.warning_amber, color: AppColors.warning),
                title: const Text('Low Stock Only'),
                onTap: () => Navigator.pop(context),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  void _showDeleteConfirmation(
    BuildContext context,
    AppLocalizations l10n,
    WidgetRef ref,
    StockItem item,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.confirmDelete),
        content: Text(l10n.deleteMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(stockProvider.notifier).deleteItem(item.id);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
  }

  void _showAddEditDialog(
    BuildContext context,
    AppLocalizations l10n,
    WidgetRef ref, {
    StockItem? existingItem,
  }) {
    final isEdit = existingItem != null;
    final nameCtrl = TextEditingController(text: existingItem?.name ?? '');
    final buyPriceCtrl = TextEditingController(text: existingItem?.buyPrice.toString() ?? '');
    final sellPriceCtrl = TextEditingController(text: existingItem?.sellPrice.toString() ?? '');
    final qtyCtrl = TextEditingController(text: existingItem?.quantity.toString() ?? '');
    final categoryCtrl = TextEditingController(text: existingItem?.category ?? '');
    final subcategoryCtrl = TextEditingController(text: existingItem?.subcategory ?? '');
    final noteCtrl = TextEditingController(text: existingItem?.note ?? '');
    ItemUnit selectedUnit = existingItem?.unit ?? ItemUnit.pcs;
    final formKey = GlobalKey<FormState>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Consumer(
          builder: (context, ref, child) {
            final stockAsyncValue = ref.watch(stockProvider);
            return StatefulBuilder(
              builder: (context, setModalState) {
                return Container(
                  height: MediaQuery.of(context).size.height * 0.85,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                children: [
                  // Handle bar
                  Container(
                    margin: const EdgeInsets.only(top: 12),
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.divider,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  // Header
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          isEdit ? l10n.editItem : l10n.addItem,
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
                  // Form
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(20),
                      child: Form(
                        key: formKey,
                        child: Column(
                          children: [
                            AppTextField(
                              controller: nameCtrl,
                              label: l10n.itemName,
                              prefixIcon: Icons.inventory_2_outlined,
                              validator: (v) => v == null || v.isEmpty ? l10n.required : null,
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: AppTextField(
                                    controller: buyPriceCtrl,
                                    label: l10n.buyPrice,
                                    prefixIcon: Icons.shopping_cart_outlined,
                                    keyboardType: TextInputType.number,
                                    validator: (v) => v == null || v.isEmpty ? l10n.required : null,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: AppTextField(
                                    controller: sellPriceCtrl,
                                    label: l10n.sellPrice,
                                    prefixIcon: Icons.sell_outlined,
                                    keyboardType: TextInputType.number,
                                    validator: (v) => v == null || v.isEmpty ? l10n.required : null,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: AppTextField(
                                    controller: qtyCtrl,
                                    label: l10n.quantity,
                                    prefixIcon: Icons.numbers,
                                    keyboardType: TextInputType.number,
                                    validator: (v) => v == null || v.isEmpty ? l10n.required : null,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: AppDropdownField<ItemUnit>(
                                    label: l10n.unit,
                                    value: selectedUnit,
                                    prefixIcon: Icons.straighten,
                                    items: ItemUnit.values
                                        .map((u) => DropdownMenuItem(
                                              value: u,
                                              child: Text(u.name),
                                            ))
                                        .toList(),
                                    onChanged: (val) {
                                      if (val != null) {
                                        setModalState(() => selectedUnit = val);
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            // Category with Autocomplete
                            stockAsyncValue.when(
                              data: (items) {
                                final existingCategories = items.map((e) => e.category).toSet().toList();
                                return RawAutocomplete<String>(
                                  initialValue: TextEditingValue(text: categoryCtrl.text),
                                  optionsBuilder: (TextEditingValue textEditingValue) {
                                    if (textEditingValue.text.isEmpty) {
                                      return existingCategories;
                                    }
                                    return existingCategories.where((String option) {
                                      return option.toLowerCase().contains(textEditingValue.text.toLowerCase());
                                    });
                                  },
                                  onSelected: (String selection) {
                                    categoryCtrl.text = selection;
                                  },
                                  fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
                                    // Sync initial value manually if needed, but here we use the controller
                                    if (controller.text.isEmpty && categoryCtrl.text.isNotEmpty) {
                                      controller.text = categoryCtrl.text;
                                    }
                                    controller.addListener(() {
                                      categoryCtrl.text = controller.text;
                                    });
                                    return AppTextField(
                                      controller: controller,
                                      label: l10n.category,
                                      prefixIcon: Icons.category_outlined,
                                      validator: (v) => v == null || v.isEmpty ? l10n.required : null,
                                    );
                                  },
                                  optionsViewBuilder: (context, onSelected, options) {
                                    return Align(
                                      alignment: Alignment.topLeft,
                                      child: Material(
                                        elevation: 4,
                                        child: SizedBox(
                                          width: MediaQuery.of(context).size.width - 40,
                                          child: ListView.builder(
                                            padding: EdgeInsets.zero,
                                            shrinkWrap: true,
                                            itemCount: options.length,
                                            itemBuilder: (BuildContext context, int index) {
                                              final String option = options.elementAt(index);
                                              return ListTile(
                                                title: Text(option),
                                                onTap: () => onSelected(option),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                              loading: () => AppTextField(controller: categoryCtrl, label: l10n.category),
                              error: (_, __) => AppTextField(controller: categoryCtrl, label: l10n.category),
                            ),
                            const SizedBox(height: 16),
                            // Subcategory with Autocomplete
                            stockAsyncValue.when(
                              data: (items) {
                                final existingSubCategories = items
                                    .where((e) => e.subcategory != null)
                                    .map((e) => e.subcategory!)
                                    .toSet()
                                    .toList();
                                return RawAutocomplete<String>(
                                  initialValue: TextEditingValue(text: subcategoryCtrl.text),
                                  optionsBuilder: (TextEditingValue textEditingValue) {
                                    if (textEditingValue.text.isEmpty) {
                                      return existingSubCategories;
                                    }
                                    return existingSubCategories.where((String option) {
                                      return option.toLowerCase().contains(textEditingValue.text.toLowerCase());
                                    });
                                  },
                                  onSelected: (String selection) {
                                    subcategoryCtrl.text = selection;
                                  },
                                  fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
                                    if (controller.text.isEmpty && subcategoryCtrl.text.isNotEmpty) {
                                      controller.text = subcategoryCtrl.text;
                                    }
                                    controller.addListener(() {
                                      subcategoryCtrl.text = controller.text;
                                    });
                                    return AppTextField(
                                      controller: controller,
                                      label: l10n.subcategory,
                                      prefixIcon: Icons.label_outline,
                                    );
                                  },
                                  optionsViewBuilder: (context, onSelected, options) {
                                    return Align(
                                      alignment: Alignment.topLeft,
                                      child: Material(
                                        elevation: 4,
                                        child: SizedBox(
                                          width: MediaQuery.of(context).size.width - 40,
                                          child: ListView.builder(
                                            padding: EdgeInsets.zero,
                                            shrinkWrap: true,
                                            itemCount: options.length,
                                            itemBuilder: (BuildContext context, int index) {
                                              final String option = options.elementAt(index);
                                              return ListTile(
                                                title: Text(option),
                                                onTap: () => onSelected(option),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                              loading: () => AppTextField(controller: subcategoryCtrl, label: l10n.subcategory),
                              error: (_, __) => AppTextField(controller: subcategoryCtrl, label: l10n.subcategory),
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
                                    final item = StockItem(
                                      id: existingItem?.id ?? '',
                                      name: nameCtrl.text.trim(),
                                      buyPrice: double.tryParse(buyPriceCtrl.text) ?? 0,
                                      sellPrice: double.tryParse(sellPriceCtrl.text) ?? 0,
                                      quantity: double.tryParse(qtyCtrl.text) ?? 0,
                                      unit: selectedUnit,
                                      category: categoryCtrl.text.trim(),
                                      subcategory: subcategoryCtrl.text.trim().isEmpty
                                          ? null
                                          : subcategoryCtrl.text.trim(),
                                      date: existingItem?.date ?? DateTime.now(),
                                      note: noteCtrl.text.trim().isEmpty
                                          ? null
                                          : noteCtrl.text.trim(),
                                    );
                                    if (isEdit) {
                                      ref.read(stockProvider.notifier).updateItem(item);
                                    } else {
                                      ref.read(stockProvider.notifier).addItem(item);
                                    }
                                    Navigator.pop(context);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(isEdit ? l10n.itemUpdated : l10n.itemAdded),
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
      },
    );
  }
}
