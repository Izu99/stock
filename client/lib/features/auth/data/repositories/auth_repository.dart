import 'package:google_sign_in/google_sign_in.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/widgets/api_provider.dart';
import '../../../../core/network/api_client.dart';
import '../../data/models/user.dart';

part 'auth_repository.g.dart';

abstract class AuthRepository {
  Future<User?> login(String username, String password);
  Future<User?> loginWithGoogle();
  Future<void> logout();
  Future<User?> getCurrentUser();
}

class AuthRepositoryImpl implements AuthRepository {
  final ApiClient _apiClient;
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
  bool _isInitialized = false;

  AuthRepositoryImpl(this._apiClient);

  Future<void> _ensureInitialized() async {
    if (!_isInitialized) {
      await _googleSignIn.initialize(
        serverClientId: '816656670559-vm76k9a0e51c993gd8ec9l334qra8k9f.apps.googleusercontent.com',
      );
      _isInitialized = true;
    }
  }

  @override
  Future<User?> login(String username, String password) async {
    try {
      print('[AUTH REPO] Attempting login for: $username');
      final response = await _apiClient.dio.post(
        'auth/login',
        data: {'username': username, 'password': password},
      );

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
  Future<User?> loginWithGoogle() async {
    try {
      print('[AUTH REPO] Starting Google login...');
      await _ensureInitialized();

      // 1. Sign out first to allow account selection
      try {
        await _googleSignIn.signOut();
      } catch (_) {}

      // 2. Trigger authentication (modern v7+ API)
      final GoogleSignInAccount? googleUser = await _googleSignIn.authenticate(
        scopeHint: ['email', 'profile'],
      );

      if (googleUser == null) return null;

      // 3. Get tokens
      final GoogleSignInAuthentication googleAuth = googleUser.authentication;
      final String? idToken = googleAuth.idToken;

      if (idToken == null) {
        print('[AUTH REPO] Google idToken is null');
        return null;
      }

      // 4. Send to backend
      final response = await _apiClient.dio.post(
        'auth/google',
        data: {'idToken': idToken},
      );

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
      print('[AUTH REPO] Google login error: $e');
      rethrow;
    }
  }

  @override
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    try {
      await _ensureInitialized();
      await _googleSignIn.signOut();
    } catch (_) {}
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
