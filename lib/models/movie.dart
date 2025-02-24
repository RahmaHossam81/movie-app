class Movies {
  final String title;
  final String posterUrl;
  final double rating;
  final int id;


  Movies({
    required this.title,
    required this.posterUrl,
    required this.rating,
    required this.id,
  });

  factory Movies.fromJson(Map<String, dynamic> json) {
    return Movies(
      title: json['title'] ?? 'Unknown',
      posterUrl: json['medium_cover_image'] ?? '',
      rating: (json['rating'] ?? 0).toDouble(),
      id: json['id'] ?? '0',
    );
  }
}