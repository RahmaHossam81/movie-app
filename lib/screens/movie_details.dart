import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:movie/models/movie_details.dart';
import 'package:movie/services/movie_service.dart';
import 'package:movie/utils/app_assets.dart';
import 'package:movie/utils/app_colors.dart';
import 'package:movie/utils/app_styles.dart';

class MovieDetailsScreen extends StatefulWidget {
  static const routeName = '/movie-details';
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
      // backgroundColor: AppColors.background,
      // appBar: AppBar(
      // title: Text("Movie Details"),
      //  backgroundColor: Colors.transparent,
      //  ),
      body: FutureBuilder<MovieDetailsModel>(
        future: movieDetails,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final movie = snapshot.data?.data?.movie;
          if (movie == null) {
            return Center(child: Text("No movie details available"));
          }

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Image.network(
                      movie.largeCoverImage ?? movie.mediumCoverImage ?? "",
                      width: double.infinity,
                      height: 645,
                      fit: BoxFit.cover,
                    ),
               Container(
                 width: double.infinity,
                 height: 645,
                         decoration: BoxDecoration(
                           gradient:LinearGradient(begin: Alignment.topCenter,
                           end: Alignment.bottomCenter,
                           colors: [
                             Colors.black.withOpacity(0.8),
                             Colors.black.withOpacity(0.2),
                             Colors.black.withOpacity(1),
                           ],
                           stops: [0,0.5,1.5]
                           ),
                         ),

                       ),

                    Positioned(
                      top: 40,
                      left: 10,
                      child: IconButton(
                        icon: Icon(Icons.arrow_back_ios, color: Colors.white, size: 35),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    Positioned(
                      top: 40,
                      right: 10,
                      child: IconButton(
                        icon: Icon(Icons.bookmark_border, color: Colors.white, size: 35),
                        onPressed: () {},
                      ),
                    ),
                    Positioned(
                      top: 248,
                      left: MediaQuery.of(context).size.width / 2 - 30,
                      child: 
                        Center(
                          child: ElevatedButton(onPressed: (){},
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.zero
                              ),
                              child:Image.asset(AppAssets.Video,width: 97,height: 97,fit: BoxFit.cover,) ),
                        )
                    ),

                      Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Align(
                              alignment: Alignment.bottomCenter,
                             child: Padding(
                               padding: const EdgeInsets.only(top: 533),
                               child:
                                SizedBox(
                                  width: double.infinity,
                                  child: Text(
                                    softWrap: true,
                                    movie.title ?? "No Title",
                                    style:
                                      AppStyles.bold24white,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                             ),
                           ),
                            SizedBox(height: 5,),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Padding(
                                padding: const EdgeInsets.only(top:15),
                                child: Text(
                                  '${movie.year ?? "Unknown Year"}',
                                  style:AppStyles.regular20white
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                 //   ),
                  ],
                ),
SizedBox(height: 5,),
                   Padding(
                     padding: const EdgeInsets.all(12),
                     child: Center(
                       child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          minimumSize: Size(398, 58),
                          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                        ),
                        onPressed: () {
                          // تشغيل الفيلم
                        },
                        child: Text("Watch",style: AppStyles.regular20white,),
                                         ),
                     ),
                   ),

                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.favorite, color: Colors.yellow),
                          SizedBox(width: 8),
                          Text('${movie.likeCount ?? 0} Likes'),
                          SizedBox(width: 16),
                          Icon(Icons.access_time_filled_rounded, color: Colors.yellow),
                          SizedBox(width: 8),
                          Text('${movie.runtime ?? 0} min'),
                          SizedBox(width: 16),
                          Icon(Icons.star, color: Colors.yellow),
                          SizedBox(width: 8),
                          Text('${movie.rating ?? 0.0}'),
                        ],
                      ),

                      SizedBox(height: 20),
                      Text(
                        "Screen Shots",
                        style: AppStyles.regular20white,
                      ),
                      SizedBox(height: 10),
                      SizedBox(
                        height: 100,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Wrap(
                            spacing: 10,
                           runSpacing: 10,
                           // scrollDirection: Axis.vertical,
                            children: [
                              if (movie.mediumScreenshotImage1 != null) ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                  child: Image.network(movie.mediumScreenshotImage1!,width:double.infinity,height: 167,fit: BoxFit.cover,)),
                             // SizedBox(width: 10,),
                              if (movie.mediumScreenshotImage2 != null) ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: Image.network(movie.mediumScreenshotImage2!,width:double.infinity,height: 167,fit: BoxFit.cover,)),
                             // SizedBox(width: 10,),
                              if (movie.mediumScreenshotImage3 != null) ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: Image.network(movie.mediumScreenshotImage3!,width: double.infinity,height: 167,fit: BoxFit.cover,)),

                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 500),
                      Text(
                        "Summary",
                        style: AppStyles.regular20white,
                      ),
                      SizedBox(height: 10),
                      Text(movie.descriptionIntro ?? "No summary available"),
                      SizedBox(height: 20),
                      Text(
                        "Cast",
                        style: AppStyles.regular20white,
                      ),
                      SizedBox(height: 10),
                      Column(
                        children: movie.cast?.map((actor) {
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(actor.urlSmallImage ?? ""),
                            ),
                            title: Text(actor.name ?? "Unknown"),
                            subtitle: Text("Character: ${actor.characterName ?? "Unknown"}"),
                          );
                        }).toList() ??
                            [],
                      ),
                      SizedBox(height: 20),
                      Text(
                        "Genres",
                        style: AppStyles.regular20white,
                      ),
                      SizedBox(height: 10),
                      Wrap(
                        spacing: 8,
                        children: movie.genres?.map((genre) => Chip(label: Text(genre))).toList() ?? [],
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