import 'dart:convert';
import 'package:http/http.dart' as http;

class BrowseService {
  static const String _baseUrl = "https://yts.mx/api/v2/list_movies.json";

  // جلب جميع الأنواع المتاحة في الأفلام
  static Future<List<String>> fetchGenres() async {
    final response = await http.get(Uri.parse(_baseUrl));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> moviesJson = data["data"]["movies"];

      Set<String> genres = {};

      for (var movie in moviesJson) {
        if (movie["genres"] != null) {
          genres.addAll(List<String>.from(movie["genres"]));
        }
      }

      return genres.toList();
    } else {
      throw Exception("Failed to load genres");
    }
  }

  // جلب الأفلام حسب النوع
  static Future<List<dynamic>> fetchMoviesByGenre(String genre) async {
    final response = await http.get(Uri.parse("$_baseUrl?genre=$genre"));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return data["data"]["movies"] ?? [];
    } else {
      throw Exception("Failed to load movies");
    }
  }
}