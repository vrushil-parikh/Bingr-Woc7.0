import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MovieDetailPage extends StatefulWidget {
  final String movieId;

  const MovieDetailPage({super.key, required this.movieId});

  @override
  _MovieDetailPageState createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  Map<String, dynamic>? movieDetails;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String userId = FirebaseAuth.instance.currentUser?.uid ?? "guest";
  bool isInWatchlist = false; // Track whether the movie is in the watchlist

  @override
  void initState() {
    super.initState();
    fetchMovieDetails();
    checkIfInWatchlist();
  }

  /// Fetch movie details from API
  Future<void> fetchMovieDetails() async {
    const String apiKey = "3cbe6b1841mshdf9bfd2110f25c3p1784b0jsn3083220044db";
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
      print("Failed to fetch movie details: ${response.statusCode}");
    }
  }

  /// Check if movie is already in watchlist
  Future<void> checkIfInWatchlist() async {
    final doc = await _firestore
        .collection('users')
        .doc(userId)
        .collection('watchlist')
        .doc(widget.movieId)
        .get();

    setState(() {
      isInWatchlist = doc.exists;
    });
  }

  /// Add movie to watchlist
  Future<void> addToWatchlist() async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('watchlist')
          .doc(widget.movieId)
          .set({
        'movieId': widget.movieId,
        'title': movieDetails?["primaryTitle"] ?? "Unknown",
        'poster': movieDetails?["primaryImage"] ?? "",
        'timestamp': FieldValue.serverTimestamp(),
      });

      setState(() {
        isInWatchlist = true;
      });

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Added to Watchlist!')));
    } catch (e) {
      print("Error adding to watchlist: $e");
    }
  }

  /// Remove movie from watchlist
  Future<void> removeFromWatchlist() async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('watchlist')
          .doc(widget.movieId)
          .delete();

      setState(() {
        isInWatchlist = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Removed from Watchlist!')));
    } catch (e) {
      print("Error removing from watchlist: $e");
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
            // Movie Poster with Default Image Handling
            Image.network(
              movieDetails?["primaryImage"] ?? '',
              width: double.infinity,
              height: 300,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Image.asset(
                  'assets/images/app_logo.png', // Default image
                  width: double.infinity,
                  height: 300,
                  fit: BoxFit.cover,
                );
              },
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    movieDetails?["primaryTitle"] ?? "Unknown Title",
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text("⭐ ${movieDetails?["averageRating"] ?? "N/A"} / 10"),
                  Text("Genres: ${movieDetails?["genres"]?.join(", ") ?? "N/A"}"),
                  Text("Duration: ${movieDetails?["runtimeMinutes"] ?? "N/A"} mins"),
                  Text("Release Year: ${movieDetails?["startYear"] ?? "N/A"}"),
                  const SizedBox(height: 10),
                  Text("Director: ${movieDetails?["directors"]?[0]["fullName"] ?? "N/A"}"),
                  const SizedBox(height: 10),
                  Text(
                    "Description: ${movieDetails?["description"] ?? "No description available."}",
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
              onPressed: isInWatchlist ? removeFromWatchlist : addToWatchlist,
              child: Text(isInWatchlist ? "Remove from Watchlist" : "Add to Watchlist"),
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
