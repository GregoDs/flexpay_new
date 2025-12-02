import 'package:json_annotation/json_annotation.dart';

part 'kapu_shops_model.g.dart';

@JsonSerializable()
class OutletResponse {
  final dynamic? data;
  final List<dynamic>? errors;
  final bool? success;
  @JsonKey(name: 'status_code')
  final int? statusCode;

  OutletResponse({
    this.data,
    this.errors,
    this.success,
    this.statusCode,
  });

  factory OutletResponse.fromJson(Map<String, dynamic> json) =>
      _$OutletResponseFromJson(json);

  Map<String, dynamic> toJson() => _$OutletResponseToJson(this);

  List<Outlet>? get outlets {
    if (data is List) {
      return (data as List)
          .whereType<Map<String, dynamic>>()
          .map((e) => Outlet.fromJson(e))
          .toList();
    }
    return null;
  }

  Map<String, List<String>>? get validationErrors {
    if (data is Map<String, dynamic>) {
      return (data as Map<String, dynamic>)
          .map((key, value) => MapEntry(key, List<String>.from(value ?? [])));
    }
    return null;
  }
}

@JsonSerializable()
class Outlet {
  final int? id; 
  @JsonKey(name: 'outlet_name')
  final String? outletName; 

  Outlet({
    this.id,
    this.outletName,
  });

  factory Outlet.fromJson(Map<String, dynamic> json) => _$OutletFromJson(json);
  Map<String, dynamic> toJson() => _$OutletToJson(this);
}