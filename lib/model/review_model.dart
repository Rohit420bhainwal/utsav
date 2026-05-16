class ReviewModel {
  final String id;
  final String customerName;
  final double rating;
  final String review;
  final DateTime createdAt;

  ReviewModel({
    required this.id,
    required this.customerName,
    required this.rating,
    required this.review,
    required this.createdAt,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json["_id"] ?? "",
      customerName: json["customerId"]?["name"] ?? "Anonymous",
      rating: (json["rating"] ?? 0).toDouble(),
      review: json["review"] ?? "",
      createdAt: DateTime.parse(json["createdAt"]),
    );
  }
}