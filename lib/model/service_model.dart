class ServiceModel {
  final String id;
  final String title;
  final String city;
  final double price;
  final String pricingModel;
  final String description;
  final String categoryName;
  final String vendorName;
  final String vendorAddress;
  final String vendorId;
  final double rating;
  final int totalReviews;
  final List<String> images;

  ServiceModel({
    required this.id,
    required this.title,
    required this.city,
    required this.price,
    required this.pricingModel,
    required this.description,
    required this.categoryName,
    required this.vendorName,
    required this.vendorAddress,
    required this.vendorId,
    required this.rating,
    required this.totalReviews,
    required this.images,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json["_id"] ?? "",
      title: json["title"] ?? "",
      price: (json["price"] ?? 0).toDouble(),
      pricingModel: json["pricingModel"] ?? "",
      city: json["vendorId"]?["city"] ?? "",
      description: json["description"] ?? "",
      categoryName: json["categoryId"]?["name"] ?? "",
      vendorName: json["vendorId"]?["businessName"] ?? "",
      vendorAddress:json["vendorId"]?["address"]??"",
      vendorId: json["vendorId"]?["_id"] ?? "",
      rating: (json["avgRating"] ?? 0).toDouble(),
      totalReviews: json["totalReviews"] ?? 0,
      images: json["images"] != null
          ? List<String>.from(json["images"])
          : [],
    );
  }
}