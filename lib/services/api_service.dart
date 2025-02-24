import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:movie/models/movie.dart';

class ApiService {
  static Future<List<Movies>> fetchMovies(String apiUrl) async {
    final url = Uri.parse(apiUrl);

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final moviesList = data['data']['movies'] as List;

      return moviesList.map((json) => Movies.fromJson(json)).toList();
    } else {
      throw Exception("Failed to load movies");
    }
  }
}