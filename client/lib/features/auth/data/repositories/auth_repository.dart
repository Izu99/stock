import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/widgets/api_provider.dart';
import '../../../../core/network/api_client.dart';
import '../../data/models/user.dart';

part 'auth_repository.g.dart';

abstract class AuthRepository {
  Future<User?> login(String username, String password);
  Future<void> logout();
  Future<User?> getCurrentUser();
}

class AuthRepositoryImpl implements AuthRepository {
  final ApiClient _apiClient;

  AuthRepositoryImpl(this._apiClient);

  @override
  Future<User?> login(String username, String password) async {
    try {
      print('[AUTH REPO] Attempting login for: $username');
      final response = await _apiClient.dio.post('/auth/login', data: {
        'username': username,
        'password': password,
      });

      if (response.statusCode == 200) {
        final user = User.fromJson(response.data);
        if (user.token != null) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('auth_token', user.token!);
        }
        return user;
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }

  @override
  Future<User?> getCurrentUser() async {
    // Implement if there's a /auth/me endpoint
    return null;
  }
}

@riverpod
AuthRepository authRepository(Ref ref) {
  return AuthRepositoryImpl(ref.watch(apiClientProvider));
}
