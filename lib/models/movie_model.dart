class Movie {
  final String id;
  final String title;
  final String? imageUrl;
  final String? description;
  final String? releaseDate;
  final double? averageRating;
  final List<String>? genres;

  Movie({
    required this.id,
    required this.title,
    this.imageUrl,
    this.description,
    this.releaseDate,
    this.averageRating,
    this.genres,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json["id"],
      title: json["primaryTitle"] ?? json["originalTitle"] ?? "Unknown Title",
      imageUrl: json["primaryImage"],
      description: json["description"],
      releaseDate: json["releaseDate"],
      averageRating: json["averageRating"]?.toDouble(),
      genres: (json["genres"] as List?)?.map((g) => g.toString()).toList() ?? [],
    );
  }
}
