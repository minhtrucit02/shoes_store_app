
class ImageProduct {
  ImageProduct({required this.imagePath});

  final String imagePath;

  factory ImageProduct.fromJson(Map<String, dynamic> json) =>
      ImageProduct(imagePath: json['imagePath']);

  Map<String, dynamic> toJson() => {'imagePath': imagePath};
}