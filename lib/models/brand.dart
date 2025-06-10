class Brand {
  Brand({
    required this.id,
    required this.name,
    required this.imagePath,
    required this.createdAt,
  });
  
  final String id;
  final String name;
  final String imagePath;
  final String createdAt;

  factory Brand.fromJson(Map<String,dynamic> json){
    return Brand(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
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