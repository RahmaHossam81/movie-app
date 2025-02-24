import 'package:flutter/material.dart';
import 'package:movie/models/movie.dart';
import 'package:movie/screens/movie_details.dart';
import 'package:movie/utils/app_colors.dart';

class TopMovieCard extends StatelessWidget {
  final Movies movie;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onDoubleTap;


  const TopMovieCard({
    Key? key,
    required this.movie,
    required this.isSelected,
    required this.onTap,
    required this.onDoubleTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = isSelected ? 234 : 184;
    double height = isSelected ? 351 : 277;

    return GestureDetector(
      onTap: onTap,
      onDoubleTap: () {
        Navigator.pushNamed(
          context,
          MovieDetailsScreen.routeName,
          arguments:movie.id, // تمرير كائن الفيلم للصفحة الجديدة
        );
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12),
        child: SizedBox(
          width: width,
          height: height,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Stack(
              children: [
                Image.network(
                  movie.posterUrl,
                  fit: BoxFit.cover,
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
                          movie.rating.toString(),
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class BottomMovieCard extends StatelessWidget {
  final Movies movie;
  final VoidCallback onTap;

  const BottomMovieCard({
    Key? key,
    required this.movie,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
         MovieDetailsScreen.routeName,
          arguments: movie.id, // تمرير كائن الفيلم للصفحة الجديدة
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              Image.network(
                movie.posterUrl,
                fit: BoxFit.cover,
                width: 150,
                height: 200,
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
                        movie.rating.toString(),
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}