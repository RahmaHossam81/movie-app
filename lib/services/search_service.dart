import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/search_model.dart';

class SearchService {
  static Future<List<SearchMovie>> searchMovies(String query) async {
    final url = Uri.parse("https://yts.mx/api/v2/list_movies.json?query_term=$query");

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final List<dynamic> moviesJson = jsonData['data']['movies'] ?? [];

        return moviesJson.map((movie) => SearchMovie.fromJson(movie)).toList();
      } else {
        throw Exception("Failed to load movies");
      }
    } catch (e) {
      print("Error fetching search results: $e");
      return [];
    }
  }
}