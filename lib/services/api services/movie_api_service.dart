import 'dart:convert';
import 'package:http/http.dart' as http;

class MovieApiService {
  static const String _baseUrl = "https://imdb236.p.rapidapi.com/imdb/india/upcoming";
  static const String _apiKey = "3cbe6b1841mshdf9bfd2110f25c3p1784b0jsn3083220044db"; // Replace with your API key
  static const String _apiHost = "imdb236.p.rapidapi.com";

  // Function to fetch movies
  Future<List<dynamic>> fetchUpcomingMovies() async {
    final response = await http.get(
      Uri.parse(_baseUrl),
      headers: {
        "x-rapidapi-key": _apiKey,
        "x-rapidapi-host": _apiHost,
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body); // Convert JSON response to a list
    } else {
      throw Exception("Failed to load movies");
    }
  }
}
