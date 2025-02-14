import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MovieDetailPage extends StatefulWidget {
  final String movieId;

  const MovieDetailPage({super.key, required this.movieId});

  @override
  _MovieDetailPageState createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  Map<String, dynamic>? movieDetails;

  @override
  void initState() {
    super.initState();
    fetchMovieDetails();
  }

  Future<void> fetchMovieDetails() async {
    const String apiKey = "fc3ca915a4msh5db06750d7fa8c4p1523b6jsn34cef66d73af";
    final String url = "https://imdb236.p.rapidapi.com/imdb/${widget.movieId}";

    final response = await http.get(Uri.parse(url), headers: {
      "x-rapidapi-host": "imdb236.p.rapidapi.com",
      "x-rapidapi-key": apiKey,
    });

    if (response.statusCode == 200) {
      setState(() {
        movieDetails = jsonDecode(response.body);
      });
    } else {
      print("Failed to fetch movie details: \${response.statusCode}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(movieDetails?['primaryTitle'] ?? 'Loading...')),
      body: movieDetails == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Movie Poster
            Image.network(
              movieDetails!["primaryImage"] ?? '',
              width: double.infinity,
              height: 300,
              fit: BoxFit.cover,
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    movieDetails!["primaryTitle"],
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text("⭐ ${movieDetails!["averageRating"]} / 10"),
                  Text("Genres: ${movieDetails!["genres"].join(", ")}"),
                  Text("Duration: ${movieDetails!["runtimeMinutes"]} mins"),
                  Text("Release Year: ${movieDetails!["startYear"]}"),
                  const SizedBox(height: 10),
                  Text("Director: ${movieDetails!["directors"][0]["fullName"]}"),
                  const SizedBox(height: 10),
                  Text(
                    "Description: ${movieDetails!["description"]}",
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () {
                // Add to Watchlist Logic
                print("Added to Watchlist");
              },
              child: const Text("Add to Watchlist"),
            ),
            ElevatedButton(
              onPressed: () {
                // Show Trailer Logic (Needs Trailer URL Handling)
                print("Watch Trailer");
              },
              child: const Text("Watch Trailer"),
            ),
          ],
        ),
      ),
    );
  }
}
