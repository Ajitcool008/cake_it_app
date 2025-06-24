/// A model class representing a cake entity with improved validation and error handling.
class Cake {
  const Cake({
    required this.title,
    required this.description,
    required this.image,
  });

  final String title;
  final String description;
  final String image;

  /// Creates a Cake instance from JSON with proper validation
  factory Cake.fromJson(Map<String, dynamic> json) {
    // Validate required fields and provide fallbacks
    final title = json['title']?.toString() ?? 'Unknown Cake';
    final description = json['desc']?.toString() ?? 'No description available';
    final image = json['image']?.toString() ?? '';

    return Cake(
      title: title,
      description: description,
      image: image,
    );
  }

  /// Converts the Cake instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'desc': description,
      'image': image,
    };
  }

  /// Creates a copy of this cake with updated fields
  Cake copyWith({
    String? title,
    String? description,
    String? image,
  }) {
    return Cake(
      title: title ?? this.title,
      description: description ?? this.description,
      image: image ?? this.image,
    );
  }

  /// Checks if the cake has a valid image URL
  bool get hasValidImage => image.isNotEmpty && Uri.tryParse(image) != null;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Cake &&
          runtimeType == other.runtimeType &&
          title == other.title &&
          description == other.description &&
          image == other.image;

  @override
  int get hashCode => title.hashCode ^ description.hashCode ^ image.hashCode;

  @override
  String toString() =>
      'Cake(title: $title, description: $description, image: $image)';
}
