import 'dart:convert';
import 'package:http/http.dart' as http;

class MovieSummaryService {
  // وظيفة للحصول على الـ summary من API
  Future<String> getMovieSummary(int movieId) async {
    final url = 'https://yts.mx/api/v2/movie_details.json?movie_id=$movieId';

    // إرسال الطلب إلى الـ API
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final summary = data['data']['movie']['summary'];
      return summary;
    } else {
      throw Exception('فشل في تحميل تفاصيل الفيلم');
    }
  }
}