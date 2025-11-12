class Brand {
  final int id;
  final String name;
  final String? logoUrl;
  final String? description;
  final DateTime? createdAt;

  Brand({required this.id, required this.name, this.logoUrl, this.description, this.createdAt});

  factory Brand.fromJson(Map<String, dynamic> json) {
    return Brand(
      id: json['id'],
      name: json['name'],
      logoUrl: json['logo_url'],
      description: json['description'],
      createdAt: DateTime.tryParse(json['created_at'] ?? ''),
    );
  }
}
