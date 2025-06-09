class Brand {
  Brand({
    required this.id,
    required this.name,
    required this.imagePath,
    required this.createdAt,
  });
  
  final int id;
  final String name;
  final String imagePath;
  final String createdAt;

  factory Brand.fromJson(Map<String,dynamic> json){
    return Brand(
      id: json['id'] ?? 0,
      name: json['brand'] ?? '',
      imagePath: json['imagePath'] ?? '',
      createdAt: json['createdAt'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'brand': name,
    'imagePath': imagePath,
    'createdAt': createdAt,
  };
}