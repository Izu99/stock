import 'package:flutter/material.dart';
import '../../../../core/theme/modern_theme.dart';
import '../../../../core/widgets/modern_buttons.dart';
import '../../../../core/widgets/modern_stat_card.dart';

class ModernStockListScreen extends StatefulWidget {
  const ModernStockListScreen({super.key});

  @override
  State<ModernStockListScreen> createState() => _ModernStockListScreenState();
}

class _ModernStockListScreenState extends State<ModernStockListScreen> {
  String selectedCategory = 'All';
  final List<String> categories = [
    'All',
    'Tools',
    'Paint',
    'Electrical',
    'Plumbing',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ModernTheme.backgroundLight,
      appBar: AppBar(
        title: const Text('Stock Items'),
        actions: [
          ModernIconButton(
            icon: Icons.qr_code_scanner,
            onPressed: () {
              // Open scanner
            },
            gradient: ModernTheme.purpleGradient,
            size: 40,
          ),
          const SizedBox(width: 8),
          ModernIconButton(
            icon: Icons.filter_list,
            onPressed: () {
              // Show filters
            },
            backgroundColor: ModernTheme.backgroundLight,
            iconColor: ModernTheme.textPrimary,
            size: 40,
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Column(
        children: [
          // Stats Overview
          ModernStatCardGrid(
            stats: [
              ModernStatCardCompactData(
                title: 'Total Items',
                value: '248',
                icon: Icons.inventory_2,
                color: ModernTheme.primaryBlue,
              ),
              ModernStatCardCompactData(
                title: 'Low Stock',
                value: '12',
                icon: Icons.warning_amber_rounded,
                color: ModernTheme.primaryOrange,
              ),
              ModernStatCardCompactData(
                title: 'Total Value',
                value: '\$45.2K',
                icon: Icons.attach_money,
                color: ModernTheme.primaryGreen,
              ),
              ModernStatCardCompactData(
                title: 'Categories',
                value: '8',
                icon: Icons.category,
                color: ModernTheme.primaryPurple,
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Category Filter
          SizedBox(
            height: 40,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              separatorBuilder: (context, index) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final category = categories[index];
                return ModernChip(
                  label: category,
                  isSelected: selectedCategory == category,
                  color: ModernTheme.primaryBlue,
                  onTap: () {
                    setState(() {
                      selectedCategory = category;
                    });
                  },
                );
              },
            ),
          ),

          const SizedBox(height: 16),

          // Stock Items List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: 10, // Example count
              itemBuilder: (context, index) {
                return _buildStockItemCard(context, index);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: ModernFAB(
        icon: Icons.add,
        label: 'Add Item',
        gradient: ModernTheme.greenGradient,
        onPressed: () {
          // Add new item
        },
      ),
    );
  }

  Widget _buildStockItemCard(BuildContext context, int index) {
    final isLowStock = index % 4 == 0; // Example condition

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            // Navigate to item details
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Item Icon
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: _getGradientForIndex(index),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.hardware,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                // Item Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Hammer ${index + 1}',
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(fontWeight: FontWeight.w600),
                            ),
                          ),
                          if (isLowStock)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: ModernTheme.primaryOrange.withOpacity(
                                  0.1,
                                ),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                'Low Stock',
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(
                                      color: ModernTheme.primaryOrange,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 10,
                                    ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Tools • SKU: HM${1000 + index}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: ModernTheme.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          _buildInfoChip(
                            context,
                            Icons.inventory_2,
                            '${45 - index * 3} pcs',
                            ModernTheme.primaryBlue,
                          ),
                          const SizedBox(width: 8),
                          _buildInfoChip(
                            context,
                            Icons.attach_money,
                            '\$${(15.99 + index * 2).toStringAsFixed(2)}',
                            ModernTheme.primaryGreen,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: ModernTheme.textSecondary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(
    BuildContext context,
    IconData icon,
    String text,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            text,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  LinearGradient _getGradientForIndex(int index) {
    final gradients = [
      ModernTheme.blueGradient,
      ModernTheme.greenGradient,
      ModernTheme.purpleGradient,
      ModernTheme.orangeGradient,
      ModernTheme.tealGradient,
    ];
    return gradients[index % gradients.length];
  }
}
