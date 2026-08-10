class CategoryModel {
  final String id;
  final String name;
  final String slug;
  final String? parentId;

  CategoryModel({
    required this.id,
    required this.name,
    required this.slug,
    this.parentId,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    final parent = json["parentId"];

    String? parentId;

    if (parent == null) {
      parentId = null;
    } else if (parent is String) {
      parentId = parent;
    } else if (parent is Map<String, dynamic>) {
      parentId = parent["_id"]?.toString();
    }

    return CategoryModel(
      id: json["_id"]?.toString() ?? "",
      name: json["name"]?.toString() ?? "",
      slug: json["slug"]?.toString() ?? "",
      parentId: parentId,
    );
  }
}