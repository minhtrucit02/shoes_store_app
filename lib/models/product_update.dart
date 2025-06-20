class ProductUpdate{
  ProductUpdate({
    required this.productId,
    required this.productSize,
    required this.quantity,
    required this.imageUrl,
});
  final String productId;
  final int productSize;
  final int quantity;
  final String imageUrl;
}