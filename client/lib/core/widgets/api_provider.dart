import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../network/api_client.dart';

part 'api_provider.g.dart';

@riverpod
ApiClient apiClient(Ref ref) {
  return ApiClient();
}
