import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/dashboard/presentation/screens/dashboard_screen.dart';
import '../../features/stock/presentation/screens/stock_list_screen.dart';
import '../../features/stock/presentation/screens/category_screen.dart';
import '../../features/sales/presentation/screens/billing_screen.dart';
import '../../features/expenses/presentation/screens/expenses_screen.dart';
import '../../features/income/presentation/screens/income_screen.dart';
import '../../features/reports/presentation/screens/reports_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';
import '../../features/admin/presentation/screens/admin_dashboard_screen.dart';
import '../../features/admin/presentation/screens/company_list_screen.dart';
import '../../features/admin/presentation/screens/add_company_screen.dart';
import '../../features/admin/data/models/company.dart';
import '../../features/dashboard/presentation/screens/main_screen.dart';

final router = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
    GoRoute(
      path: '/admin',
      builder: (context, state) => const AdminDashboardScreen(),
      routes: [
        GoRoute(
          path: 'companies',
          builder: (context, state) => const CompanyListScreen(),
        ),
        GoRoute(
          path: 'companies/add',
          builder: (context, state) => const AddCompanyScreen(),
        ),
        GoRoute(
          path: 'companies/edit',
          builder: (context, state) =>
              AddCompanyScreen(company: state.extra as Company?),
        ),
      ],
    ),
    ShellRoute(
      builder: (context, state, child) => MainScreen(child: child),
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const DashboardScreen(),
          routes: [
            GoRoute(
              path: 'stock',
              builder: (context, state) => const StockListScreen(),
              routes: [
                GoRoute(
                  path: 'categories',
                  builder: (context, state) => const CategoryScreen(),
                ),
              ],
            ),
            GoRoute(
              path: 'billing',
              builder: (context, state) => const BillingScreen(),
            ),
            GoRoute(
              path: 'expenses',
              builder: (context, state) => const ExpensesScreen(),
            ),
            GoRoute(
              path: 'income',
              builder: (context, state) => const IncomeScreen(),
            ),
            GoRoute(
              path: 'reports',
              builder: (context, state) => const ReportsScreen(),
            ),
            GoRoute(
              path: 'settings',
              builder: (context, state) => const SettingsScreen(),
            ),
          ],
        ),
      ],
    ),
  ],
);
