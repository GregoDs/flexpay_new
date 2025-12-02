// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chama_products_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChamaProduct _$ChamaProductFromJson(Map<String, dynamic> json) => ChamaProduct(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  expirationTime: json['expiration_time'] as String,
  monthlyPrice: (json['monthly_price'] as num).toInt(),
  targetAmount: (json['target_amount'] as num).toInt(),
);

Map<String, dynamic> _$ChamaProductToJson(ChamaProduct instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'expiration_time': instance.expirationTime,
      'monthly_price': instance.monthlyPrice,
      'target_amount': instance.targetAmount,
    };

ChamaProductsResponse _$ChamaProductsResponseFromJson(
  Map<String, dynamic> json,
) => ChamaProductsResponse(
  data: (json['data'] as List<dynamic>)
      .map((e) => ChamaProduct.fromJson(e as Map<String, dynamic>))
      .toList(),
  errors: json['errors'] as List<dynamic>,
  success: json['success'] as bool,
  statusCode: (json['status_code'] as num).toInt(),
);

Map<String, dynamic> _$ChamaProductsResponseToJson(
  ChamaProductsResponse instance,
) => <String, dynamic>{
  'data': instance.data,
  'errors': instance.errors,
  'success': instance.success,
  'status_code': instance.statusCode,
};

UserChama _$UserChamaFromJson(Map<String, dynamic> json) => UserChama(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  totalSavings: json['total_savings'] as String,
);

Map<String, dynamic> _$UserChamaToJson(UserChama instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'total_savings': instance.totalSavings,
};

UserChamasResponse _$UserChamasResponseFromJson(Map<String, dynamic> json) =>
    UserChamasResponse(
      data: (json['data'] as List<dynamic>)
          .map((e) => UserChama.fromJson(e as Map<String, dynamic>))
          .toList(),
      errors: json['errors'] as List<dynamic>,
      success: json['success'] as bool,
      statusCode: (json['status_code'] as num).toInt(),
    );

Map<String, dynamic> _$UserChamasResponseToJson(UserChamasResponse instance) =>
    <String, dynamic>{
      'data': instance.data,
      'errors': instance.errors,
      'success': instance.success,
      'status_code': instance.statusCode,
    };
