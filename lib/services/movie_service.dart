import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:movie/models/movie_details.dart';


class MovieService {
  static Future<MovieDetailsModel> fetchMovieDetails(int movieId) async {
    final url =
        'https://yts.mx/api/v2/movie_details.json?movie_id=$movieId&with_cast=true&with_images=true';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return MovieDetailsModel.fromJson(data);
    } else {
      throw Exception('Failed to load movie details');
    }
  }
}