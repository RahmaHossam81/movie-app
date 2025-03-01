import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  bool isSaved = false;

  /// فحص ما إذا كان الفيلم محفوظًا في Watch List
  void checkIfSaved() async {
    final doc = await FirebaseFirestore.instance
        .collection('watchlist')
        .doc(widget.movieId.toString())
        .get();

    setState(() {
      isSaved = doc.exists;
    });

    print("Check Watchlist: Movie ${widget.movieId} isSaved = $isSaved");
  }

  /// إضافة أو إزالة الفيلم من Watch List
  void toggleWatchList(int movieId, String title, String poster, int year, num rating) async {
    final watchlistRef = FirebaseFirestore.instance.collection('watchlist');
    final doc = watchlistRef.doc(movieId.toString());

    if (isSaved) {
      await doc.delete();
      print("Removed from Watchlist: Movie $movieId");
    } else {
      await doc.set({
        'movieId': movieId,
        'poster': poster,
        'rating': rating,
      });
      print("Added to Watchlist: Movie $movieId");
    }

    setState(() {
      isSaved = !isSaved;
    });
  }

  void saveToHistory(int movieId, String title, String poster, int year, num rating) async {
    final historyRef = FirebaseFirestore.instance.collection('history');
    final historyDoc = await historyRef.doc(movieId.toString()).get();

    if (!historyDoc.exists) {
      await historyRef.doc(movieId.toString()).set({
        'movieId': movieId,
        // 'title': title,
        'poster': poster,
        'rating': rating,
        // 'year': year,
        //  'timestamp': FieldValue.serverTimestamp(),
      });

      print("Saved to History: Movie $movieId");
    } else {
      print("Movie $movieId already in History");
    }
  }
  @override
  void initState() {
    super.initState();
    movieDetails = MovieService.fetchMovieDetails(widget.movieId);

    /// التحقق إذا كان الفيلم في Watch List
    checkIfSaved();

    /// حفظ الفيلم في History عند فتح التفاصيل
    movieDetails.then((data) {
      final movie = data.data?.movie;
      if (movie != null) {
        saveToHistory(
          movie.id!,
          movie.title ?? "No Title",
          _getValidImageUrl(movie.largeCoverImage, movie.mediumCoverImage),
          movie.year ?? 0,
          movie.rating ?? 0.0,
        );
      }
    });
  }
  /// دالة لفحص الروابط والتأكد من أنها صالحة
  String _getValidImageUrl(String? url1, String? url2) {
    if (url1 != null && url1.startsWith("http")) return url1;
    if (url2 != null && url2.startsWith("http")) return url2;
    return ""; // في حالة عدم توفر رابط صحيح
  }

  /// دالة لتحميل الصور مع صورة افتراضية عند الخطأ
  Widget loadImage(String? imageUrl, {double? width, double? height, BoxFit fit = BoxFit.cover}) {
    if (imageUrl == null || imageUrl.isEmpty || !imageUrl.startsWith("http")) {
      return Image.asset(AppAssets.Empty, width: width, height: height, fit: fit);
    }
    return Image.network(
      imageUrl,
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (context, error, stackTrace) {
        return Image.asset(AppAssets.Empty, width: width, height: height, fit: fit);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                        icon: Icon(
                          isSaved ? Icons.bookmark : Icons.bookmark_border,
                          color: Colors.white,
                          size: 35,
                        ),
                        onPressed: () {
                          movieDetails.then((data) {
                            final movie = data.data?.movie;
                            if (movie != null) {
                              toggleWatchList(
                                movie.id!,
                                movie.title ?? "No Title",
                                _getValidImageUrl(movie.largeCoverImage, movie.mediumCoverImage),
                                movie.year ?? 0,
                                movie.rating ?? 0.0,
                              );
                            }
                          });
                        },
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