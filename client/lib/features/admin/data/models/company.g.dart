// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'company.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Company _$CompanyFromJson(Map<String, dynamic> json) => _Company(
  id: json['_id'] as String,
  name: json['name'] as String,
  phone: json['phone'] as String,
  address: json['address'] as String,
  owner: Owner.fromJson(json['owner'] as Map<String, dynamic>),
  isActive: json['isActive'] as bool? ?? true,
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$CompanyToJson(_Company instance) => <String, dynamic>{
  '_id': instance.id,
  'name': instance.name,
  'phone': instance.phone,
  'address': instance.address,
  'owner': instance.owner,
  'isActive': instance.isActive,
  'createdAt': instance.createdAt?.toIso8601String(),
};

_Owner _$OwnerFromJson(Map<String, dynamic> json) => _Owner(
  name: json['name'] as String,
  phone: json['phone'] as String,
  whatsapp: json['whatsapp'] as String?,
  email: json['email'] as String?,
);

Map<String, dynamic> _$OwnerToJson(_Owner instance) => <String, dynamic>{
  'name': instance.name,
  'phone': instance.phone,
  'whatsapp': instance.whatsapp,
  'email': instance.email,
};
