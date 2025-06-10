class ImageProduct {
  ImageProduct({required this.url});

  final String url;

  factory ImageProduct.fromJson(Map<String, dynamic> json) =>
      ImageProduct(url: json['url'] ?? '');

  Map<String, dynamic> toJson() => {'url': url};
}
