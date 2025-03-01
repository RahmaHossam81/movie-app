class SearchMovie {
  final String title;
  final String posterUrl;
  final double rating;

  SearchMovie({
    required this.title,
    required this.posterUrl,
    required this.rating,
  });

  factory SearchMovie.fromJson(Map<String, dynamic> json) {
    return SearchMovie(
      title: json['title'] ?? "Unknown Title",
      posterUrl: json['medium_cover_image'] ?? "",
      rating: (json['rating'] ?? 0).toDouble(),
    );
  }
}