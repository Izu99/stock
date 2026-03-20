import 'package:stock/features/auth/presentation/providers/auth_provider.dart';
import 'package:stock/features/admin/data/models/company.dart';
import 'package:stock/core/utils/export_utils.dart';
import 'dart:developer' as dev;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stock/l10n/app_localizations.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_widgets.dart';
import '../../../stock/data/models/stock_item.dart';
import '../../../stock/presentation/providers/stock_provider.dart';
import '../../data/repositories/sales_repository.dart';

class _CartItem {
  final StockItem stockItem;
  double quantity;
  double sellPrice;
  String? error;
  late final TextEditingController qtyController;
  late final FocusNode focusNode;

  double get subtotal => sellPrice * quantity;
  double get profit => (sellPrice - stockItem.buyPrice) * quantity;

  _CartItem({required this.stockItem, this.quantity = 1.0})
    : sellPrice = stockItem.sellPrice {
    qtyController = TextEditingController(
      text: quantity.toStringAsFixed(
        quantity == quantity.roundToDouble() ? 0 : 1,
      ),
    );
    focusNode = FocusNode();
  }

  void dispose() {
    qtyController.dispose();
    focusNode.dispose();
  }
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
  Map<String, dynamic>? _lastInvoiceData;

  @override
  void dispose() {
    for (var item in _cart) {
      item.dispose();
    }
    super.dispose();
  }

  double get _total => _cart.fold(0, (sum, item) => sum + item.subtotal);
  double get _totalProfit => _cart.fold(0, (sum, item) => sum + item.profit);

  void _addToCart(StockItem stockItem) {
    setState(() {
      final existing = _cart.indexWhere((c) => c.stockItem.id == stockItem.id);
      if (existing != -1) {
        if (_cart[existing].quantity < stockItem.quantity) {
          _cart[existing].quantity++;
          _cart[existing].qtyController.text = _cart[existing].quantity
              .toStringAsFixed(
                _cart[existing].quantity ==
                        _cart[existing].quantity.roundToDouble()
                    ? 0
                    : 1,
              );
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
    _cart[index].dispose();
    setState(() => _cart.removeAt(index));
  }

  void _updateQuantity(int index, double qty, {bool updateController = true}) {
    final item = _cart[index];
    if (qty > item.stockItem.quantity) {
      _showInsufficientStockSnack();
      setState(() {
        item.error = 'Max: ${item.stockItem.quantity.toStringAsFixed(0)}';
        item.quantity = qty; // Still update value so UI shows what user typed
        if (updateController) {
          item.qtyController.text = qty.toStringAsFixed(
            qty == qty.roundToDouble() ? 0 : 1,
          );
        }
      });
      return;
    }
    if (qty <= 0) {
      _removeFromCart(index);
      return;
    }
    setState(() {
      item.error = null;
      item.quantity = qty;
      if (updateController) {
        item.qtyController.text = qty.toStringAsFixed(
          qty == qty.roundToDouble() ? 0 : 1,
        );
      }
    });
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
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
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
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
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

  void _showSaleSuccessDialog({
    required Company company,
    required List<_CartItem> soldItems,
    required double soldTotal,
    required String invoiceNumber,
  }) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        title: Column(
          children: [
            const Icon(
              Icons.check_circle_outline_rounded,
              color: AppColors.success,
              size: 64,
            ),
            const SizedBox(height: 16),
            Text(
              l10n.saleCompleted,
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Invoice #: $invoiceNumber',
              style: GoogleFonts.inter(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildSmallActionIcon(
                  assetPath: 'assets/icons/pdf.png',
                  onTap: () async {
                    await ExportUtils.generateInvoicePdf(
                      company: company,
                      cartItems: soldItems,
                      total: soldTotal,
                      invoiceNumber: invoiceNumber,
                    );
                  },
                ),
                const SizedBox(width: 12),
                _buildSmallActionIcon(
                  assetPath: 'assets/icons/excel.png',
                  onTap: () async {
                    await ExportUtils.generateInvoiceExcel(
                      company: company,
                      cartItems: soldItems,
                      total: soldTotal,
                      invoiceNumber: invoiceNumber,
                    );
                  },
                ),
                const SizedBox(width: 12),
                _buildSmallActionIcon(
                  assetPath: 'assets/icons/print.png',
                  onTap: () async {
                    await ExportUtils.generateInvoicePdf(
                      company: company,
                      cartItems: soldItems,
                      total: soldTotal,
                      invoiceNumber: invoiceNumber,
                    );
                  },
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'Close',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w700,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('New Sale'),
          ),
        ],
      ),
    );
  }

  Widget _buildSmallActionIcon({
    required String assetPath,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.divider.withOpacity(0.5)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Image.asset(assetPath, width: 24, height: 24),
      ),
    );
  }

  Future<void> _processSale(AppLocalizations l10n) async {
    if (_cart.isEmpty) return;

    for (int i = 0; i < _cart.length; i++) {
      final item = _cart[i];
      if (item.quantity > item.stockItem.quantity) {
        _showInsufficientStockSnack();
        item.focusNode.requestFocus();
        return;
      }
    }

    setState(() => _isProcessing = true);

    try {
      final repo = ref.read(salesRepositoryProvider);
      final soldItems = List<_CartItem>.from(_cart);
      final soldTotal = _total;
      
      // Fetch sequential bill ID from the backend (e.g., "001")
      final invoiceNumber = await repo.getNextBillId();

      // Prepare item data for the backend
      final checkoutItems = _cart.map((cartItem) => {
        'itemId': cartItem.stockItem.id,
        'quantity': cartItem.quantity,
        'sellPrice': cartItem.sellPrice,
      }).toList();

      // Submit the entire bill at once
      await repo.createSaleBill(
        items: checkoutItems,
        billId: invoiceNumber,
      );


      ref.invalidate(stockProvider);

      if (!mounted) return;

      final company = await ref.read(companyDetailsProvider.future);

      setState(() {
        _isProcessing = false;
        _lastInvoiceData = {
          'company': company,
          'items': soldItems,
          'total': soldTotal,
          'invoiceNumber': invoiceNumber,
        };
      });

      // 1. Clear cart immediately after successful server sync
      setState(() => _cart.clear());

      if (company != null) {
        _showSaleSuccessDialog(
          company: company,
          soldItems: soldItems,
          soldTotal: soldTotal,
          invoiceNumber: invoiceNumber,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.saleCompleted),
            backgroundColor: AppColors.success,
          ),
        );
        setState(() => _cart.clear());
      }
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
          if (_lastInvoiceData != null && _cart.isEmpty)
            TextButton.icon(
              onPressed: () {
                _showSaleSuccessDialog(
                  company: _lastInvoiceData!['company'],
                  soldItems: _lastInvoiceData!['items'],
                  soldTotal: _lastInvoiceData!['total'],
                  invoiceNumber: _lastInvoiceData!['invoiceNumber'],
                );
              },
              icon: const Icon(Icons.history_edu_rounded, size: 20),
              label: const Text('Last Invoice'),
              style: TextButton.styleFrom(foregroundColor: AppColors.primary),
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
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(24),
              ),
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
                    color: _totalProfit >= 0
                        ? AppColors.success
                        : AppColors.error,
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
                                const Icon(
                                  Icons.check_circle_outline,
                                  size: 20,
                                ),
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

  Widget _buildCartItemCard(
    _CartItem cartItem,
    int index,
    AppLocalizations l10n,
  ) {
    final priceChanged = cartItem.sellPrice != cartItem.stockItem.sellPrice;
    final hasError = cartItem.error != null;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: hasError
              ? AppColors.error
              : (priceChanged
                    ? AppColors.warning.withValues(alpha: 0.5)
                    : AppColors.divider.withValues(alpha: 0.5)),
          width: hasError ? 1.5 : 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Row: Item Name and Delete Button
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      cartItem.stockItem.name,
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    // Tap to edit price
                    GestureDetector(
                      onTap: () => _showEditPriceDialog(index),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: priceChanged
                              ? AppColors.warning.withValues(alpha: 0.1)
                              : AppColors.surface,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.edit_outlined,
                              size: 14,
                              color: priceChanged
                                  ? AppColors.warning
                                  : AppColors.textHint,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Rs. ${cartItem.sellPrice.toStringAsFixed(2)}',
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: priceChanged
                                    ? AppColors.warning
                                    : AppColors.textSecondary,
                              ),
                            ),
                            if (priceChanged) ...[
                              const SizedBox(width: 6),
                              Text(
                                '(${cartItem.stockItem.sellPrice.toStringAsFixed(0)})',
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  color: AppColors.textHint,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () => _removeFromCart(index),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.error.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.delete_outline_rounded,
                    size: 20,
                    color: AppColors.error,
                  ),
                ),
              ),
            ],
          ),

          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(height: 1),
          ),

          // Bottom Row: Quantity Controls and Subtotal
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Quantity controls - Large and easy to tap
              GestureDetector(
                onLongPress: () => _showEditQuantityDialog(index),
                child: Container(
                  height: 48, // Taller for better hit area
                  width: 160, // Wider for more space
                  decoration: BoxDecoration(
                    color: hasError
                        ? AppColors.error.withValues(alpha: 0.05)
                        : AppColors.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: hasError ? AppColors.error : AppColors.border,
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    children: [
                      _buildQtyButton(Icons.remove_rounded, () {
                        _updateQuantity(index, cartItem.quantity - 1);
                      }),
                      Expanded(
                        child: TextField(
                          controller: cartItem.qtyController,
                          focusNode: cartItem.focusNode
                            ..addListener(() {
                              if (!cartItem.focusNode.hasFocus) {
                                final val = double.tryParse(
                                  cartItem.qtyController.text,
                                );
                                if (val != null) {
                                  _updateQuantity(index, val);
                                } else {
                                  _updateQuantity(index, cartItem.quantity);
                                }
                              }
                            }),
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                              RegExp(r'^\d*\.?\d{0,2}'),
                            ),
                          ],
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            fontSize: 18, // Larger font for entry
                            fontWeight: FontWeight.w700,
                            color: hasError
                                ? AppColors.error
                                : AppColors.primary,
                          ),
                          decoration: const InputDecoration(
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                            border: InputBorder.none,
                          ),
                          onChanged: (value) {
                            final val = double.tryParse(value);
                            if (val != null && val >= 0) {
                              setState(() {
                                cartItem.quantity = val;
                                if (val > cartItem.stockItem.quantity) {
                                  cartItem.error =
                                      'Max: ${cartItem.stockItem.quantity.toStringAsFixed(0)}';
                                } else {
                                  cartItem.error = null;
                                }
                              });
                            }
                          },
                          onSubmitted: (value) {
                            final val = double.tryParse(value);
                            if (val != null) {
                              _updateQuantity(index, val);
                            }
                          },
                          onTap: () {
                            cartItem.qtyController.selection = TextSelection(
                              baseOffset: 0,
                              extentOffset: cartItem.qtyController.text.length,
                            );
                          },
                        ),
                      ),
                      _buildQtyButton(Icons.add_rounded, () {
                        _updateQuantity(index, cartItem.quantity + 1);
                      }),
                    ],
                  ),
                ),
              ),

              // Subtotal area
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    l10n.subtotal,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: AppColors.textHint,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    'Rs.${cartItem.subtotal.toStringAsFixed(0)}',
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: hasError ? AppColors.error : AppColors.primary,
                    ),
                  ),
                ],
              ),
            ],
          ),

          if (hasError)
            Padding(
              padding: const EdgeInsets.only(top: 8, left: 4),
              child: Row(
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 14,
                    color: AppColors.error,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    cartItem.error!,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: AppColors.error,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildQtyButton(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 44, // Large hit area
        height: double.infinity,
        alignment: Alignment.center,
        child: Icon(icon, size: 22, color: AppColors.primary),
      ),
    );
  }

  Widget _buildSummaryRow(
    String label,
    String value, {
    bool isTotal = false,
    Color? color,
  }) {
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
            color:
                color ?? (isTotal ? AppColors.primary : AppColors.textPrimary),
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
                          prefixIcon: const Icon(
                            Icons.search_rounded,
                            size: 20,
                            color: AppColors.textHint,
                          ),
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
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
                            .where(
                              (i) => i.name.toLowerCase().contains(
                                _searchQuery.toLowerCase(),
                              ),
                            )
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
                            final cartQty = inCart
                                ? _cart[cartIndex].quantity
                                : 0.0;

                            return Container(
                              margin: const EdgeInsets.only(bottom: 6),
                              decoration: BoxDecoration(
                                color: inCart
                                    ? AppColors.primarySurface.withValues(
                                        alpha: 0.3,
                                      )
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(12),
                                border: inCart
                                    ? Border.all(
                                        color: AppColors.primary.withValues(
                                          alpha: 0.3,
                                        ),
                                      )
                                    : null,
                              ),
                              child: ListTile(
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 4,
                                ),
                                leading: Container(
                                  width: 42,
                                  height: 42,
                                  decoration: BoxDecoration(
                                    color: inCart
                                        ? AppColors.primary.withValues(
                                            alpha: 0.15,
                                          )
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
                                      : const Icon(
                                          Icons.inventory_2_outlined,
                                          color: AppColors.primary,
                                          size: 20,
                                        ),
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
                                onLongPress: () {
                                  // Find current index in cart (or add it if not exists)
                                  int cartIndex = _cart.indexWhere(
                                    (c) => c.stockItem.id == item.id,
                                  );
                                  if (cartIndex == -1) {
                                    _addToCart(item);
                                    cartIndex = _cart.length - 1;
                                  }
                                  _showEditQuantityDialog(cartIndex);
                                  setSheetState(() {});
                                },
                              ),
                            );
                          },
                        );
                      },
                      loading: () => const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primary,
                        ),
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
