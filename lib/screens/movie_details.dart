import 'package:flutter/material.dart';
import 'package:movie/models/movie_details.dart';
import '../services/movie_service.dart';

class MovieDetailsScreen extends StatefulWidget {
  static const String routeName = "/moviedetails";
  final int movieId;

  const MovieDetailsScreen({Key? key, required this.movieId}) : super(key: key);

  @override
  _MovieDetailsScreenState createState() => _MovieDetailsScreenState();
}

class _MovieDetailsScreenState extends State<MovieDetailsScreen> {
  late Future<MovieDetailsModel> movieDetails;

  @override
  void initState() {
    super.initState();
    movieDetails = MovieService.fetchMovieDetails(widget.movieId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Movie Details"),
      ),
      body: FutureBuilder<MovieDetailsModel>(
        future: movieDetails,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.data?.movie == null) {
            return Center(child: Text("No data available"));
          }

          final movie = snapshot.data!.data!.movie!;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(movie.largeCoverImage ?? ''),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(movie.title ?? 'Unknown',
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold)),
                      SizedBox(height: 10),
                      Text("Rating: ${movie.rating?.toString() ?? 'N/A'}"),
                      Text("Year: ${movie.year?.toString() ?? 'N/A'}"),
                      Text("Runtime: ${movie.runtime?.toString() ?? 'N/A'} mins"),
                      SizedBox(height: 10),
                      Text("Genres: ${movie.genres?.join(', ') ?? 'N/A'}"),
                      SizedBox(height: 10),
                      Text("Description:",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(movie.descriptionFull ?? 'No description available'),
                      SizedBox(height: 10),
                      if (movie.cast != null && movie.cast!.isNotEmpty)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Cast:",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18)),
                            SizedBox(height: 5),
                            ...movie.cast!.map((actor) => ListTile(
                              leading: actor.urlSmallImage != null
                                  ? Image.network(actor.urlSmallImage!)
                                  : Icon(Icons.person),
                              title: Text(actor.name ?? 'Unknown'),
                              subtitle: Text(actor.characterName ?? 'Unknown'),
                            )),
                          ],
                        ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}