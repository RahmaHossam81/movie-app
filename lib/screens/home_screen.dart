import 'package:flutter/material.dart';
import 'package:movie/models/movie.dart';
import 'package:movie/screens/movie_details.dart';
import 'package:movie/services/api_service.dart';
import 'package:movie/utils/app_colors.dart';
import 'package:movie/utils/app_assets.dart';
import 'package:movie/utils/app_links.dart';
import 'package:movie/widgets/movie_card.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = "/home";
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Movies>> availableNowMovies;
  late Future<List<Movies>> allMovies;
  int selectedMovieIndex = 0;
  int displayedMoviesCount = 5;

  @override
  void initState() {
    super.initState();
    fetchMovies();
  }

  void fetchMovies() {
    availableNowMovies =
        ApiService.fetchMovies(AppLinksApi.getMoviesAvailableNow);
    allMovies = ApiService.fetchMovies(AppLinksApi.getALlMovies);
  }

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 1:
        Navigator.pushNamed(context, '/search');
        break;
      case 2:
        Navigator.pushNamed(context, '/movies_by_genre');
        break;
      case 3:
        Navigator.pushNamed(context, 'Profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: AppColors.gray,
        selectedItemColor: AppColors.yallow,
        unselectedItemColor: Colors.white,
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
          switch (index) {
            case 1:
              Navigator.pushNamed(context, "/search");
              break;
            case 2:
              Navigator.pushNamed(context, "/browse");
              break;
            case 3:
              Navigator.pushNamed(context, "Profile");
              break;
          }
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: "browse"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
      body: FutureBuilder<List<Movies>>(
        future: availableNowMovies,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
                child: Text("Failed to load movies",
                    style: TextStyle(color: Colors.white)));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
                child: Text("No movies available",
                    style: TextStyle(color: Colors.white)));
          }

          List<Movies> topMovies = snapshot.data!.toList();

          return Stack(
            children: [
              Positioned.fill(
                child: Image.network(
                  topMovies[selectedMovieIndex].posterUrl,
                  fit: BoxFit.cover,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.6),
                      Colors.black,
                    ],
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Image.asset(AppAssets.AvailableNow, width: 267),
                  ),
                  SizedBox(
                    height: 360,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: topMovies.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Align(
                            alignment: Alignment.center,
                            child: TopMovieCard(
                              movie: topMovies[index],
                              isSelected: index == selectedMovieIndex,
                              onTap: () {
          setState(() {
          selectedMovieIndex = index;
          });
          },
                                onDoubleTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    MovieDetailsScreen.routeName,
                                    arguments: topMovies[index].id,
                                  );
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 10),
                  Center(
                    child: Image.asset(AppAssets.WatchNow, width: 354),
                  ),
                  SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Action",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              displayedMoviesCount += 5;
                            });
                          },
                          child: Row(
                            children: [
                              Text(
                                "See More",
                                style: TextStyle(
                                    color: AppColors.yallow,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                              Icon(
                                Icons.arrow_forward_ios,
                                size: 16,
                                color: AppColors.yallow,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10,),
                  Expanded(
                    child: FutureBuilder<List<Movies>>(
                      future: allMovies,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
                          return Center(child: Text("Failed to load movies", style: TextStyle(color: Colors.white)));
                        }

                        List<Movies> bottomMovies = snapshot.data!.take(displayedMoviesCount).toList();

                        return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: bottomMovies.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: BottomMovieCard(
                                movie: bottomMovies[index],
                                onTap: () {},
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}