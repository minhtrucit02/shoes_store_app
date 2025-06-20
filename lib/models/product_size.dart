
class ProductSize {
  ProductSize({
    required this.size,
    required this.quantity,
  });
  final int size;
  final int quantity;

  factory ProductSize.fromJson(Map<String, dynamic> json) => ProductSize(
      size: json['size'] ?? 0,
      quantity: json['quantity'] ?? 0
  );

  Map<String, dynamic> toJson() => {
    'size': size,
    'quantity':quantity,
  };

}
