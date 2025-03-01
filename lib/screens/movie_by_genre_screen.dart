import 'package:flutter/material.dart';
import 'package:movie/screens/movie_details.dart';
import 'package:movie/services/browse_service.dart';
import 'package:movie/utils/app_colors.dart';

class MoviesByGenreScreen extends StatefulWidget {
  static const String routeName = "/browse";

  @override
  _MoviesByGenreScreenState createState() => _MoviesByGenreScreenState();
}

class _MoviesByGenreScreenState extends State<MoviesByGenreScreen> {
  List<String> genres = [];
  String selectedGenre = "";
  late Future<List<dynamic>> moviesFuture = Future.value([]); // ✅ تهيئة مبدئية

  @override
  void initState() {
    super.initState();
    _fetchGenres();
  }

  Future<void> _fetchGenres() async {
    try {
      List<String> fetchedGenres = await BrowseService.fetchGenres();
      if (fetchedGenres.isNotEmpty) {
        setState(() {
          genres = fetchedGenres;
          selectedGenre = genres.first;
          moviesFuture = BrowseService.fetchMoviesByGenre(selectedGenre);
        });
      }
    } catch (e) {
      print("Error fetching genres: $e");
    }
  }

  void _changeGenre(String newGenre) {
    setState(() {
      selectedGenre = newGenre;
      moviesFuture = BrowseService.fetchMoviesByGenre(newGenre);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff282A28),
      appBar: AppBar(
        title: Text("Browse Movies"),
        backgroundColor: Color(0xff282A28),
      ),
      body: Column(
        children: [
          // قائمة الأنواع (سكرول أفقي)
          Container(
            height: 50,
            margin: EdgeInsets.symmetric(vertical: 10),
            child: genres.isEmpty
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: genres.length,
              itemBuilder: (context, index) {
                String genre = genres[index];
                bool isSelected = genre == selectedGenre;

                return GestureDetector(
                  onTap: () => _changeGenre(genre),
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 8),
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.yallow : Colors.transparent,
                      border: Border.all(color: AppColors.yallow, width: 2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      genre,
                      style: TextStyle(
                        color: isSelected ? Colors.black : AppColors.yallow,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // قائمة الأفلام
          Expanded(
            child: FutureBuilder<List<dynamic>>(
              future: moviesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError || !snapshot.hasData) {
                  return Center(
                    child: Text("حدث خطأ أثناء تحميل البيانات",
                        style: TextStyle(color: Colors.white)),
                  );
                } else if (snapshot.data!.isEmpty) {
                  return Center(
                    child: Text("لا توجد أفلام متاحة",
                        style: TextStyle(color: Colors.white)),
                  );
                }

                List<dynamic> movies = snapshot.data!;

                return GridView.builder(
                  padding: EdgeInsets.all(16),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.7,
                  ),
                  itemCount: movies.length,
                  itemBuilder: (context, index) {
                    var movie = movies[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          MovieDetailsScreen.routeName,
                          arguments: movie["id"],
                        );
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Stack(
                          children: [
                            Image.network(
                              movie["medium_cover_image"] ?? "",
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: Colors.grey[800],
                                  child: Center(
                                    child: Icon(Icons.error, color: Colors.red),
                                  ),
                                );
                              },
                            ),
                            Positioned(
                              top: 10,
                              left: 10,
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.7),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Row(
                                  children: [
                                    Icon(Icons.star, color: AppColors.yallow, size: 14),
                                    SizedBox(width: 5),
                                    Text(
                                      movie["rating"].toString(),
                                      style: TextStyle(color: Colors.white, fontSize: 12),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}