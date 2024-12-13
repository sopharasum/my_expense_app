class CategoryResponse {
  final List<Category> data;

  CategoryResponse({required this.data});

  factory CategoryResponse.fromJson(Map<String, dynamic> map) {
    return CategoryResponse(
      data: List<Category>.from(map["data"].map((x) => Category.fromJson(x))),
    );
  }
}

class Category {
  final int? categoryId;
  final String? categoryName;
  final String? categoryType;

  Category({
    this.categoryId,
    this.categoryName,
    this.categoryType,
  });

  factory Category.fromJson(Map<String, dynamic> map) {
    return Category(
      categoryId: map["id"],
      categoryName: map["name"],
      categoryType: map["type"],
    );
  }
}
