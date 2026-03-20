import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:stock/features/admin/data/models/company.dart';
import '../../data/models/user.dart';
import '../../data/repositories/auth_repository.dart';

part 'auth_provider.g.dart';

@Riverpod(keepAlive: true)
class Auth extends _$Auth {
  @override
  FutureOr<User?> build() {
    return ref.watch(authRepositoryProvider).getCurrentUser();
  }

  Future<void> login(String username, String password) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(authRepositoryProvider).login(username, password),
    );
  }

  Future<void> loginWithGoogle() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(authRepositoryProvider).loginWithGoogle(),
    );
  }

  Future<void> logout() async {
    state = const AsyncLoading();
    await ref.read(authRepositoryProvider).logout();
    state = const AsyncData(null);
  }
}

// Separate provider to easily access just the company details
@Riverpod(keepAlive: true)
Future<Company?> companyDetails(Ref ref) async {
  final user = await ref.watch(authProvider.future);
  if (user == null || user.company == null) {
    return null;
  }
  return user.company;
}
