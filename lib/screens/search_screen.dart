import 'package:flutter/material.dart';
import 'package:movie/models/search_model.dart';
import 'package:movie/utils/app_assets.dart';
import '../services/search_service.dart';

class SearchScreen extends StatefulWidget {
  static const String routeName = "/search";
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<SearchMovie> _movies = [];
  bool _isLoading = false;

  void _searchMovies(String query) async {
    if (query.isEmpty) {
      setState(() {
        _movies = [];
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final movies = await SearchService.searchMovies(query);

    setState(() {
      _movies = movies;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        title: TextField(
          controller: _searchController,
          onChanged: _searchMovies,
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'search',
            hintStyle: TextStyle(color: Colors.white54),
            border: InputBorder.none,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.clear, color: Colors.white),
            onPressed: () {
              _searchController.clear();
              setState(() {
                _movies = [];
              });
            },
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _movies.isEmpty
          ? Center(
        child: Image.asset(
          AppAssets.Empty,
          width: 150,
        ),
      )
          : GridView.builder(
        padding: EdgeInsets.all(10),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.7,
        ),
        itemCount: _movies.length,
        itemBuilder: (context, index) {
          final movie = _movies[index];
          return GestureDetector(
            onTap: () {
              // تنفيذ الإجراء المطلوب عند الضغط على الفيلم
            },
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    movie.posterUrl ?? '',
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.star, color: Colors.yellow, size: 16),
                        SizedBox(width: 4),
                        Text(
                          movie.rating.toString(),
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
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