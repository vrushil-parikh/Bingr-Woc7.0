import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../../models/movie_model.dart';
import '../DetailView/detail_view_page.dart';
import 'package:http/http.dart' as http;

import '../Movies/movie_drawer_page.dart';

class MoviePage extends StatefulWidget {
  const MoviePage({super.key});

  @override
  _MoviePageState createState() => _MoviePageState();
}

class _MoviePageState extends State<MoviePage> {
  List<Movie> trendingMovies = [];
  List<Movie> topMovies = [];
  List<Movie> topTVShows = [];
  List<Movie> upcomingMovies = [];

  @override
  void initState() {
    super.initState();
    fetchTrendingMovies();
    fetchTopMovies();
    fetchTopTvShows();
    fetchUpcomingMovies();
  }

  Future<void> fetchTrendingMovies() async {
    await fetchMoviesFromApi("https://imdb236.p.rapidapi.com/imdb/most-popular-movies", (movies) => setState(() => trendingMovies = movies));
  }

  Future<void> fetchTopMovies() async {
    await fetchMoviesFromApi("https://imdb236.p.rapidapi.com/imdb/top250-movies", (movies) => setState(() => topMovies = movies));
  }

  Future<void> fetchTopTvShows() async {
    await fetchMoviesFromApi("https://imdb236.p.rapidapi.com/imdb/most-popular-tv", (movies) => setState(() => topTVShows = movies));
  }

  Future<void> fetchUpcomingMovies() async {
    await fetchMoviesFromApi("https://imdb236.p.rapidapi.com/imdb/india/upcoming", (movies) => setState(() => upcomingMovies = movies));
  }

  Future<void> fetchMoviesFromApi(String apiUrl, Function(List<Movie>) callback) async {
    const Map<String, String> headers = {
      "x-rapidapi-host": "imdb236.p.rapidapi.com",
      "x-rapidapi-key": "3cbe6b1841mshdf9bfd2110f25c3p1784b0jsn3083220044db",
    };

    try {
      final response = await http.get(Uri.parse(apiUrl), headers: headers);
      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = jsonDecode(response.body);
        List<Movie> movies = jsonResponse.map((json) => Movie.fromJson(json)).toList();
        callback(movies);
      } else {
        print("Failed to load data: \${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching data: \$e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 15,),
            if (trendingMovies.isNotEmpty)
              CarouselSlider(
                options: CarouselOptions(autoPlay: true, height: 350),
                items: trendingMovies.map((movie) => BuildCarouselCard(movie)).toList(),
              ),
            buildMovieSection("Top 250 Movies", topMovies),
            buildMovieSection("Top TV Shows", topTVShows),
            buildMovieSection("Upcoming Movies", upcomingMovies),
          ],
        ),
      ),
    );
  }
  Widget BuildCarouselCard(Movie movie) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MovieDetailPage(movieId: movie.id),
          ),
        );
      },
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              movie.imageUrl ?? 'https://via.placeholder.com/150',
              fit: BoxFit.cover,
              width: 250,
              height: 300,
              errorBuilder: (context, error, stackTrace) {
                return Image.asset(
                  'assets/images/app_logo.png', // Make sure you have a local placeholder image
                  fit: BoxFit.cover,
                  width: 250,
                  height: 300,
                );
              },
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                movie.title,
                style: const TextStyle(
                  fontSize: 20,
                  overflow: TextOverflow.clip,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              if (movie.averageRating != null)
                Text(
                  "⭐${movie.averageRating}",
                  style: const TextStyle(color: Colors.black),
                ),
            ],
          ),
        ],
      ),
    );
  }



  Widget buildMovieCard(Movie movie) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MovieDetailPage(movieId: movie.id),
          ),
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
                return Image.asset(
                  'assets/images/app_logo.png', // Local fallback image
                  fit: BoxFit.cover,
                  width: 150,
                  height: 200,
                );
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
                  style: const TextStyle(
                    overflow: TextOverflow.clip,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (movie.averageRating != null)
                  Text(
                    "⭐ ${movie.averageRating}",
                    style: const TextStyle(color: Colors.black),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }




  Widget buildMovieSection(String title, List<Movie> movies) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold)),
              TextButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MovieListPage(apiUrl: "https://imdb236.p.rapidapi.com/imdb/top250-movies", title: "Top Movies")),
                ),
                child: const Text("More", style: TextStyle(color: Colors.blue)),
              ),
            ],
          ),
          SizedBox(
            height: 260,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: min(movies.length,10),
              itemBuilder: (context, index) {
                final movie = movies[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildMovieCard(movie),
                      const SizedBox(height: 5),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
