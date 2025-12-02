import 'dart:convert';

/// -------------------
/// TOP LEVEL RESPONSE
/// -------------------
class AllMerchantsResponse {
  final MerchantData? data;
  final List<dynamic>? errors;
  final bool? success;
  final int? statusCode;

  AllMerchantsResponse({
    this.data,
    this.errors,
    this.success,
    this.statusCode,
  });

  factory AllMerchantsResponse.fromJson(Map<String, dynamic> json) {
    return AllMerchantsResponse(
      data: json['data'] != null ? MerchantData.fromJson(json['data']) : null,
      errors: json['errors'] ?? [],
      success: json['success'],
      statusCode: json['status_code'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data?.toJson(),
      'errors': errors,
      'success': success,
      'status_code': statusCode,
    };
  }
}

/// -------------------
/// WRAPPER → data
/// -------------------
class MerchantData {
  final int? currentPage;
  final List<Merchant>? data;
  final String? firstPageUrl;
  final int? from;
  final int? lastPage;
  final String? lastPageUrl;
  final List<PageLink>? links;
  final String? nextPageUrl;
  final String? path;
  final int? perPage;
  final String? prevPageUrl;
  final int? to;
  final int? total;

  MerchantData({
    this.currentPage,
    this.data,
    this.firstPageUrl,
    this.from,
    this.lastPage,
    this.lastPageUrl,
    this.links,
    this.nextPageUrl,
    this.path,
    this.perPage,
    this.prevPageUrl,
    this.to,
    this.total,
  });

  factory MerchantData.fromJson(Map<String, dynamic> json) {
    return MerchantData(
      currentPage: json['current_page'],
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => Merchant.fromJson(e))
          .toList(),
      firstPageUrl: json['first_page_url'],
      from: json['from'],
      lastPage: json['last_page'],
      lastPageUrl: json['last_page_url'],
      links: (json['links'] as List<dynamic>?)
          ?.map((e) => PageLink.fromJson(e))
          .toList(),
      nextPageUrl: json['next_page_url'],
      path: json['path'],
      perPage: json['per_page'],
      prevPageUrl: json['prev_page_url'],
      to: json['to'],
      total: json['total'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'current_page': currentPage,
      'data': data?.map((e) => e.toJson()).toList(),
      'first_page_url': firstPageUrl,
      'from': from,
      'last_page': lastPage,
      'last_page_url': lastPageUrl,
      'links': links?.map((e) => e.toJson()).toList(),
      'next_page_url': nextPageUrl,
      'path': path,
      'per_page': perPage,
      'prev_page_url': prevPageUrl,
      'to': to,
      'total': total,
    };
  }
}

/// -------------------
/// MERCHANT MODEL (exact backend order)
/// -------------------
class Merchant {
  final int? id;
  final String? merchantName;
  final String? icon;
  final String? websiteUrl;
  final String? description;
  final String? productImage;
  final String? logo;
  final String? mode;

  Merchant({
    this.id,
    this.merchantName,
    this.icon,
    this.websiteUrl,
    this.description,
    this.productImage,
    this.logo,
    this.mode,
  });

  factory Merchant.fromJson(Map<String, dynamic> json) {
    return Merchant(
      id: json['id'],
      merchantName: json['merchant_name'],
      icon: json['icon'],
      websiteUrl: json['website_url'],
      description: json['description'],
      productImage: json['product_image'],
      logo: json['logo'],
      mode: json['mode'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'merchant_name': merchantName,
      'icon': icon,
      'website_url': websiteUrl,
      'description': description,
      'product_image': productImage,
      'logo': logo,
      'mode': mode,
    };
  }
}

/// -------------------
/// PAGINATION LINKS
/// -------------------
class PageLink {
  final String? url;
  final String? label;
  final bool? active;

  PageLink({
    this.url,
    this.label,
    this.active,
  });

  factory PageLink.fromJson(Map<String, dynamic> json) {
    return PageLink(
      url: json['url'],
      label: json['label'],
      active: json['active'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'label': label,
      'active': active,
    };
  }
}