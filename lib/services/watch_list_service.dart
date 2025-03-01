import 'package:cloud_firestore/cloud_firestore.dart';

class WatchlistService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<void> addToWatchlist(String userId, Map<String, dynamic> movie) async {
    await _firestore
        .collection('watchlist')
        .doc(userId)
        .collection('movies')
        .doc(movie['id'].toString())
        .set(movie);
  }

  static Future<void> removeFromWatchlist(String userId, String movieId) async {
    await _firestore
        .collection('watchlist')
        .doc(userId)
        .collection('movies')
        .doc(movieId)
        .delete();
  }

  static Future<bool> isMovieInWatchlist(String userId, String movieId) async {
    var doc = await _firestore
        .collection('watchlist')
        .doc(userId)
        .collection('movies')
        .doc(movieId)
        .get();
    return doc.exists;
  }
}