class AppCategory {
  final int categoryId;
  final String categoryName;
  final String categoryColor;

  AppCategory({
    required this.categoryId,
    required this.categoryName,
    required this.categoryColor,
  });

  // CRUD OP's For Categories
  // Create operation
  
  // Read operation
  factory AppCategory.fromMap(Map<String, dynamic> map) {
    return AppCategory(
      categoryId: map['CategoryId'] as int,
      categoryName: map['CategoryName'] as String,
      categoryColor: map['CategoryColor'] as String,
    );
  }
}
