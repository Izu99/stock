import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:stock/features/admin/data/models/company.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@freezed
abstract class User with _$User {
  const factory User({
    required String id,
    required String username,
    required String email,
    required String role,
    Company? company,
    String? token,
  }) = _User;

  const User._();
  String? get companyName => company?.name;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
