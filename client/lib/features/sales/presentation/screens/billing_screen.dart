import 'dart:developer' as dev;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:Stock/l10n/app_localizations.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_widgets.dart';
import '../../../stock/data/models/stock_item.dart';
import '../../../stock/presentation/providers/stock_provider.dart';
import '../../data/repositories/sales_repository.dart';

class _CartItem {
  final StockItem stockItem;
  double quantity;
  double sellPrice; // Editable sell price

  double get subtotal => sellPrice * quantity;
  double get profit => (sellPrice - stockItem.buyPrice) * quantity;

  _CartItem({required this.stockItem, this.quantity = 1})
      : sellPrice = stockItem.sellPrice;
}

class BillingScreen extends ConsumerStatefulWidget {
  const BillingScreen({super.key});

  @override
  ConsumerState<BillingScreen> createState() => _BillingScreenState();
}

class _BillingScreenState extends ConsumerState<BillingScreen> {
  final List<_CartItem> _cart = [];
  String _searchQuery = '';
  bool _isProcessing = false;

  double get _total => _cart.fold(0, (sum, item) => sum + item.subtotal);
  double get _totalProfit => _cart.fold(0, (sum, item) => sum + item.profit);

  void _addToCart(StockItem stockItem) {
    setState(() {
      final existing = _cart.indexWhere((c) => c.stockItem.id == stockItem.id);
      if (existing != -1) {
        if (_cart[existing].quantity < stockItem.quantity) {
          _cart[existing].quantity++;
        } else {
          _showInsufficientStockSnack();
        }
      } else {
        if (stockItem.quantity > 0) {
          _cart.add(_CartItem(stockItem: stockItem));
        } else {
          _showInsufficientStockSnack();
        }
      }
    });
  }

  void _showInsufficientStockSnack() {
    final l10n = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.insufficientStock),
        backgroundColor: AppColors.warning,
      ),
    );
  }

  void _removeFromCart(int index) {
    setState(() => _cart.removeAt(index));
  }

  void _updateQuantity(int index, double qty) {
    if (qty > _cart[index].stockItem.quantity) {
      _showInsufficientStockSnack();
      return;
    }
    if (qty <= 0) {
      _removeFromCart(index);
      return;
    }
    setState(() => _cart[index].quantity = qty);
  }

  void _updateSellPrice(int index, double price) {
    if (price < 0) return;
    setState(() => _cart[index].sellPrice = price);
  }

  void _showEditPriceDialog(int index) {
    final cartItem = _cart[index];
    final controller = TextEditingController(
      text: cartItem.sellPrice.toStringAsFixed(2),
    );
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          '${l10n.sellPrice} - ${cartItem.stockItem.name}',
          style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Show original price
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Original:',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  Text(
                    'Rs. ${cartItem.stockItem.sellPrice.toStringAsFixed(2)}',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
              ],
              autofocus: true,
              style: GoogleFonts.inter(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                prefixText: 'Rs. ',
                prefixStyle: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: AppColors.border),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: AppColors.primary, width: 2),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () {
              final val = double.tryParse(controller.text);
              if (val != null && val > 0) {
                _updateSellPrice(index, val);
              }
              Navigator.pop(ctx);
            },
            child: Text(l10n.save),
          ),
        ],
      ),
    );
  }

  void _showEditQuantityDialog(int index) {
    final cartItem = _cart[index];
    final controller = TextEditingController(
      text: cartItem.quantity.toStringAsFixed(
        cartItem.quantity == cartItem.quantity.roundToDouble() ? 0 : 1,
      ),
    );
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          '${l10n.quantity} - ${cartItem.stockItem.name}',
          style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Available:',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  Text(
                    '${cartItem.stockItem.quantity.toStringAsFixed(0)} ${cartItem.stockItem.unit.name}',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
              ],
              autofocus: true,
              style: GoogleFonts.inter(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: AppColors.border),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: AppColors.primary, width: 2),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () {
              final val = double.tryParse(controller.text);
              if (val != null) {
                _updateQuantity(index, val);
              }
              Navigator.pop(ctx);
            },
            child: Text(l10n.save),
          ),
        ],
      ),
    );
  }

  Future<void> _processSale(AppLocalizations l10n) async {
    if (_cart.isEmpty) return;
    setState(() => _isProcessing = true);

    try {
      final repo = ref.read(salesRepositoryProvider);

      dev.log('🛒 [BillingScreen] Starting sale processing with ${_cart.length} items');

      for (final cartItem in _cart) {
        dev.log('📦 [BillingScreen] Selling: ${cartItem.stockItem.name} '
            'x${cartItem.quantity} @ Rs.${cartItem.sellPrice}');
        await repo.createSale(
          cartItem.stockItem.id,
          cartItem.quantity,
          sellPrice: cartItem.sellPrice,
        );
        dev.log('✅ [BillingScreen] Sale created for: ${cartItem.stockItem.name}');
      }

      dev.log('🎉 [BillingScreen] All sales processed successfully');

      if (!mounted) return;

      ref.invalidate(stockProvider);

      setState(() {
        _cart.clear();
        _isProcessing = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.saleCompleted),
          backgroundColor: AppColors.success,
        ),
      );
    } catch (e, st) {
      dev.log('❌ [BillingScreen] Sale error: $e', error: e, stackTrace: st);
      if (mounted) {
        setState(() => _isProcessing = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${l10n.error}: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final stockAsync = ref.watch(stockProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(l10n.billing),
        actions: [
          if (_cart.isNotEmpty)
            TextButton.icon(
              onPressed: () => setState(() => _cart.clear()),
              icon: const Icon(Icons.clear_all, size: 18),
              label: const Text('Clear'),
              style: TextButton.styleFrom(foregroundColor: AppColors.error),
            ),
        ],
      ),
      body: Column(
        children: [
          // Cart Items
          Expanded(
            flex: 5,
            child: _cart.isEmpty
                ? EmptyStateWidget(
                    icon: Icons.shopping_cart_outlined,
                    title: l10n.cartEmpty,
                    subtitle: l10n.tapToAdd,
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _cart.length,
                    itemBuilder: (context, index) {
                      final cartItem = _cart[index];
                      return _buildCartItemCard(cartItem, index, l10n);
                    },
                  ),
          ),

          // Bottom Summary + Checkout
          Container(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 16,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildSummaryRow(
                    '${l10n.stockItems}: ${_cart.length}',
                    'Rs. ${_total.toStringAsFixed(2)}',
                    isTotal: false,
                  ),
                  const SizedBox(height: 6),
                  _buildSummaryRow(
                    l10n.profit,
                    'Rs. ${_totalProfit.toStringAsFixed(2)}',
                    isTotal: false,
                    color: _totalProfit >= 0 ? AppColors.success : AppColors.error,
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Divider(),
                  ),
                  _buildSummaryRow(
                    l10n.total,
                    'Rs. ${_total.toStringAsFixed(2)}',
                    isTotal: true,
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _cart.isEmpty || _isProcessing
                          ? null
                          : () => _processSale(l10n),
                      child: _isProcessing
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2.5,
                              ),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.check_circle_outline, size: 20),
                                const SizedBox(width: 8),
                                Text(l10n.checkout),
                              ],
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showItemSelector(context, l10n, stockAsync),
        child: const Icon(Icons.add_shopping_cart_rounded, size: 24),
      ),
    );
  }

  Widget _buildCartItemCard(_CartItem cartItem, int index, AppLocalizations l10n) {
    final priceChanged = cartItem.sellPrice != cartItem.stockItem.sellPrice;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: priceChanged
            ? AppColors.warning.withValues(alpha: 0.5)
            : AppColors.divider.withValues(alpha: 0.5),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Item info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      cartItem.stockItem.name,
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    // Tap to edit price
                    GestureDetector(
                      onTap: () => _showEditPriceDialog(index),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.edit_outlined,
                            size: 12,
                            color: priceChanged ? AppColors.warning : AppColors.textHint,
                          ),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              'Rs. ${cartItem.sellPrice.toStringAsFixed(2)}',
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: priceChanged ? AppColors.warning : AppColors.textSecondary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (priceChanged) ...[
                            const SizedBox(width: 6),
                            Text(
                              '(${cartItem.stockItem.sellPrice.toStringAsFixed(0)})',
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                color: AppColors.textHint,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              // Quantity controls
              Container(
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildQtyButton(Icons.remove, () {
                      _updateQuantity(index, cartItem.quantity - 1);
                    }),
                    GestureDetector(
                      onTap: () => _showEditQuantityDialog(index),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Text(
                          cartItem.quantity.toStringAsFixed(
                            cartItem.quantity == cartItem.quantity.roundToDouble() ? 0 : 1,
                          ),
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    _buildQtyButton(Icons.add, () {
                      _updateQuantity(index, cartItem.quantity + 1);
                    }),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              // Subtotal + delete
              SizedBox(
                width: 70, // Fixed width for subtotal area
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Rs.${cartItem.subtotal.toStringAsFixed(0)}',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    GestureDetector(
                      onTap: () => _removeFromCart(index),
                      child: const Icon(
                        Icons.delete_outline,
                        size: 18,
                        color: AppColors.error,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQtyButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Icon(icon, size: 18, color: AppColors.primary),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value,
      {bool isTotal = false, Color? color}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            label,
            style: GoogleFonts.inter(
              fontSize: isTotal ? 18 : 14,
              fontWeight: isTotal ? FontWeight.w700 : FontWeight.w500,
              color: isTotal ? AppColors.textPrimary : AppColors.textSecondary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 12),
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: isTotal ? 22 : 15,
            fontWeight: FontWeight.w700,
            color: color ?? (isTotal ? AppColors.primary : AppColors.textPrimary),
          ),
        ),
      ],
    );
  }

  void _showItemSelector(
    BuildContext context,
    AppLocalizations l10n,
    AsyncValue stockAsync,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (sheetContext, setSheetState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.75,
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
                      children: [
                        Expanded(
                          child: Text(
                            l10n.selectItem,
                            style: GoogleFonts.inter(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Show cart count badge
                        if (_cart.isNotEmpty)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '${_cart.length}',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        const SizedBox(width: 8),
                        FilledButton.icon(
                          onPressed: () => Navigator.pop(sheetContext),
                          icon: const Icon(Icons.check, size: 16),
                          label: Text(
                            l10n.save,
                            style: const TextStyle(fontSize: 13),
                          ),
                          style: FilledButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 0,
                            ),
                            minimumSize: const Size(0, 36),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Search in sheet
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
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
                          prefixIcon: const Icon(Icons.search_rounded,
                              size: 20, color: AppColors.textHint),
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 14),
                        ),
                        onChanged: (v) {
                          setSheetState(() => _searchQuery = v);
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: stockAsync.when(
                      data: (items) {
                        final list = (items as List<StockItem>)
                            .where((i) => i.name
                                .toLowerCase()
                                .contains(_searchQuery.toLowerCase()))
                            .toList();
                        return ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: list.length,
                          itemBuilder: (context, index) {
                            final item = list[index];
                            // Check if already in cart
                            final cartIndex = _cart.indexWhere(
                              (c) => c.stockItem.id == item.id,
                            );
                            final inCart = cartIndex != -1;
                            final cartQty = inCart ? _cart[cartIndex].quantity : 0.0;

                            return Container(
                              margin: const EdgeInsets.only(bottom: 6),
                              decoration: BoxDecoration(
                                color: inCart
                                    ? AppColors.primarySurface.withValues(alpha: 0.3)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(12),
                                border: inCart
                                    ? Border.all(
                                        color: AppColors.primary.withValues(alpha: 0.3),
                                      )
                                    : null,
                              ),
                              child: ListTile(
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 4),
                                leading: Container(
                                  width: 42,
                                  height: 42,
                                  decoration: BoxDecoration(
                                    color: inCart
                                        ? AppColors.primary.withValues(alpha: 0.15)
                                        : AppColors.primarySurface,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: inCart
                                      ? Center(
                                          child: Text(
                                            cartQty.toStringAsFixed(
                                              cartQty == cartQty.roundToDouble()
                                                  ? 0
                                                  : 1,
                                            ),
                                            style: GoogleFonts.inter(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w800,
                                              color: AppColors.primary,
                                            ),
                                          ),
                                        )
                                      : const Icon(Icons.inventory_2_outlined,
                                          color: AppColors.primary, size: 20),
                                ),
                                title: Text(
                                  item.name,
                                  style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                ),
                                subtitle: Text(
                                  '${item.quantity.toStringAsFixed(0)} ${item.unit.name} | ${item.category}',
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                                trailing: Text(
                                  'Rs. ${item.sellPrice.toStringAsFixed(0)}',
                                  style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.primary,
                                  ),
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                onTap: () {
                                  _addToCart(item);
                                  // Stay open! Just refresh the sheet
                                  setSheetState(() {});
                                },
                              ),
                            );
                          },
                        );
                      },
                      loading: () => const Center(
                        child: CircularProgressIndicator(color: AppColors.primary),
                      ),
                      error: (e, _) => Center(child: Text('Error: $e')),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    ).then((_) {
      // Refresh parent after closing sheet
      setState(() {});
    });
  }
}
