class Movie {
  final String id;
  final String title;
  final String? description;
  final String? imageUrl;
  final String? releaseDate;
  final List<String> genres;
  final double? rating;

  Movie({
    required this.id,
    required this.title,
    this.description,
    this.imageUrl,
    this.releaseDate,
    required this.genres,
    this.rating,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'],
      title: json['primaryTitle'],
      description: json['description'],
      imageUrl: json['primaryImage'],
      releaseDate: json['releaseDate'],
      genres: List<String>.from(json['genres'] ?? []),
      rating: json['averageRating']?.toDouble(),
    );
  }
}