import 'package:flutter/material.dart';
import '../../../../core/theme/modern_theme.dart';
import '../../../../core/widgets/feature_card.dart';

class ModernDashboardScreen extends StatefulWidget {
  const ModernDashboardScreen({super.key});

  @override
  State<ModernDashboardScreen> createState() => _ModernDashboardScreenState();
}

class _ModernDashboardScreenState extends State<ModernDashboardScreen> {
  int lowStockCount = 5; // Example count
  int pendingOrdersCount = 3; // Example count

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ModernTheme.backgroundLight,
      body: CustomScrollView(
        slivers: [
          // Modern App Bar
          SliverAppBar(
            expandedHeight: 180,
            floating: false,
            pinned: true,
            backgroundColor: Colors.white,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF2196F3), Color(0xFF1976D2)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'Stock Manager',
                          style: Theme.of(context).textTheme.displaySmall
                              ?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Manage your inventory efficiently',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: Colors.white.withOpacity(0.9)),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            leading: IconButton(
              icon: const Icon(Icons.menu, color: Colors.white),
              onPressed: () {
                // Open drawer
              },
            ),
            actions: [
              IconButton(
                icon: const Icon(
                  Icons.notifications_outlined,
                  color: Colors.white,
                ),
                onPressed: () {
                  // Show notifications
                },
              ),
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: CircleAvatar(
                  backgroundColor: Colors.white.withOpacity(0.2),
                  child: const Icon(Icons.person, color: Colors.white),
                ),
              ),
            ],
          ),

          // Premium Banner (like Helakuru PRO)
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFF6B6B), Color(0xFFE91E63)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFE91E63).withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Unlock All Features',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'with Stock Manager PRO',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: Colors.white.withOpacity(0.9)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    children: [
                      OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: const BorderSide(color: Colors.white, width: 2),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                        ),
                        child: const Text('Try it'),
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: ModernTheme.primaryRed,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                        ),
                        child: const Text('Activate'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Quick Actions Section
          SliverToBoxAdapter(
            child: FeatureCardGrid(
              title: 'QUICK ACTIONS',
              features: [
                FeatureCardData(
                  icon: Icons.add_shopping_cart,
                  label: 'New Sale',
                  gradient: ModernTheme.blueGradient,
                  onTap: () {
                    // Navigate to new sale
                  },
                ),
                FeatureCardData(
                  icon: Icons.inventory_2,
                  label: 'Add Stock',
                  gradient: ModernTheme.greenGradient,
                  onTap: () {
                    // Navigate to add stock
                  },
                ),
                FeatureCardData(
                  icon: Icons.qr_code_scanner,
                  label: 'Scan Item',
                  gradient: ModernTheme.purpleGradient,
                  onTap: () {
                    // Open barcode scanner
                  },
                ),
                FeatureCardData(
                  icon: Icons.receipt_long,
                  label: 'Expenses',
                  gradient: ModernTheme.orangeGradient,
                  onTap: () {
                    // Navigate to expenses
                  },
                ),
              ],
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 8)),

          // Stock Management Section
          SliverToBoxAdapter(
            child: FeatureCardGrid(
              title: 'STOCK MANAGEMENT',
              features: [
                FeatureCardData(
                  icon: Icons.inventory,
                  label: 'All Items',
                  gradient: ModernTheme.tealGradient,
                  onTap: () {
                    // Navigate to all items
                  },
                ),
                FeatureCardData(
                  icon: Icons.warning_amber_rounded,
                  label: 'Low Stock',
                  gradient: ModernTheme.orangeGradient,
                  onTap: () {
                    // Navigate to low stock
                  },
                  badge: NotificationBadge(count: lowStockCount),
                ),
                FeatureCardData(
                  icon: Icons.history,
                  label: 'Movement',
                  gradient: ModernTheme.purpleGradient,
                  onTap: () {
                    // Navigate to stock movement
                  },
                ),
                FeatureCardData(
                  icon: Icons.delete_outline,
                  label: 'Wastage',
                  gradient: ModernTheme.redGradient,
                  onTap: () {
                    // Navigate to wastage
                  },
                ),
              ],
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 8)),

          // Reports & Analytics Section
          SliverToBoxAdapter(
            child: FeatureCardGrid(
              title: 'REPORTS & ANALYTICS',
              features: [
                FeatureCardData(
                  icon: Icons.analytics,
                  label: 'Analytics',
                  gradient: ModernTheme.blueGradient,
                  onTap: () {
                    // Navigate to analytics
                  },
                ),
                FeatureCardData(
                  icon: Icons.trending_up,
                  label: 'Profit',
                  gradient: ModernTheme.greenGradient,
                  onTap: () {
                    // Navigate to profit report
                  },
                ),
                FeatureCardData(
                  icon: Icons.picture_as_pdf,
                  label: 'Export PDF',
                  gradient: ModernTheme.redGradient,
                  onTap: () {
                    // Export to PDF
                  },
                ),
                FeatureCardData(
                  icon: Icons.table_chart,
                  label: 'Export CSV',
                  gradient: ModernTheme.tealGradient,
                  onTap: () {
                    // Export to CSV
                  },
                ),
              ],
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 8)),

          // Settings Section
          SliverToBoxAdapter(
            child: FeatureCardGrid(
              title: 'SETTINGS',
              features: [
                FeatureCardData(
                  icon: Icons.person,
                  label: 'Profile',
                  gradient: ModernTheme.purpleGradient,
                  onTap: () {
                    // Navigate to profile
                  },
                ),
                FeatureCardData(
                  icon: Icons.business,
                  label: 'Company',
                  gradient: ModernTheme.blueGradient,
                  onTap: () {
                    // Navigate to company settings
                  },
                ),
                FeatureCardData(
                  icon: Icons.settings,
                  label: 'Settings',
                  gradient: ModernTheme.tealGradient,
                  onTap: () {
                    // Navigate to settings
                  },
                ),
                FeatureCardData(
                  icon: Icons.help_outline,
                  label: 'Help',
                  gradient: ModernTheme.orangeGradient,
                  onTap: () {
                    // Navigate to help
                  },
                ),
              ],
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),
    );
  }
}
