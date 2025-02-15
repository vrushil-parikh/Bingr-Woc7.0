import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../models/movie_model.dart';
import '../DetailView/detail_view_page.dart';
import 'dart:convert';
class TvShowsPage extends StatefulWidget {
  final String apiUrl;
  final String title;
  const TvShowsPage({Key? key, required this.apiUrl, required this.title}): super(key: key);

  @override
  State<TvShowsPage> createState() => _TvShowsPageState();
}

class _TvShowsPageState extends State<TvShowsPage> {
  List<Movie> movies = [];
  bool isLoading = false;
  int currentPage = 1;
  final int pageSize = 20;
  void initState() {
    super.initState();
    fetchMovies();
  }

  Future<void> fetchMovies() async {
    if (isLoading) return;
    setState(() => isLoading = true);

    const Map<String, String> headers = {
      "x-rapidapi-host": "imdb236.p.rapidapi.com",
      "x-rapidapi-key": "3cbe6b1841mshdf9bfd2110f25c3p1784b0jsn3083220044db",
    };

    try {
      final response = await http.get(
          Uri.parse(widget.apiUrl), headers: headers);
      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = jsonDecode(response.body);
        List<Movie> fetchedMovies = jsonResponse.map((json) =>
            Movie.fromJson(json)).toList();
        setState(() {
          movies.addAll(fetchedMovies);
        });
      } else {
        print("Failed to load movies: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching movies: $e");
    } finally {
      setState(() => isLoading = false);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: movies.isEmpty && isLoading
          ? const Center(child: CircularProgressIndicator()) // Show loader if loading initially
          : GridView.builder(
        padding: const EdgeInsets.all(8),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.7,
        ),
        itemCount: movies.length,
        itemBuilder: (context, index) {
          final movie = movies[index];
          return buildMovieCard(movie);
        },
      ),
    );
  }
  Widget buildMovieCard(Movie movie) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MovieDetailPage(movieId: movie.id)),
        );
      },
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              movie.imageUrl ?? 'https://via.placeholder.com/150',
              fit: BoxFit.cover,
              width: 150,
              height: 200,
              errorBuilder: (context, error, stackTrace) {
                return Image.asset('assets/images/app_logo.png', fit: BoxFit.cover, width: 150, height: 200);
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(4),
            width: 150,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  movie.title,
                  style: const TextStyle(overflow: TextOverflow.clip, color: Colors.black, fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (movie.averageRating != null)
                  Text("⭐ ${movie.averageRating}", style: const TextStyle(color: Colors.black)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}