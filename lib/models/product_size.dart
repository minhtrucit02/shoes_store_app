
class ProductSize {
  ProductSize({
    required this.size,
    required this.quantity,
  });
  final int size;
  final int quantity;

  factory ProductSize.fromJson(Map<String, dynamic> json) => ProductSize(
      size: json['size'],
      quantity: json['quantity']
  );

  Map<String, dynamic> toJson() => {
    'size': size,
    'quantity':quantity,
  };

}
