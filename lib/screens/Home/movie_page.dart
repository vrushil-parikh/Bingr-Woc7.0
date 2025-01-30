import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import '../../models/movie_model.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
class MoviePage extends StatefulWidget {
  const MoviePage({super.key});

  @override
  State<MoviePage> createState() => _MoviePageState();
}

class _MoviePageState extends State<MoviePage> {
  List<Map<String, dynamic>> moviesJsonList = [];

  @override
  void initState() {
    super.initState();
    fetchMovies();
  }

  Future<void> fetchMovies() async {
    final url = Uri.parse("https://imdb236.p.rapidapi.com/imdb/india/upcoming");
    final headers = {
      "x-rapidapi-host": "imdb236.p.rapidapi.com",
      "x-rapidapi-key": "fc3ca915a4msh5db06750d7fa8c4p1523b6jsn34cef66d73af",
    };

    try {
      final response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        debugPrint("Raw JSON Response: ${response.body}", wrapWidth: 1024);
        List<dynamic> data = jsonDecode(response.body);

        setState(() {
          moviesJsonList = data.map((movie) => Map<String, dynamic>.from(movie)).toList();
        });
      } else {
        print("Failed to load data: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Movie> movies =
        moviesJsonList.map((json) => Movie.fromJson(json)).toList();
    return Scaffold(
      body: moviesJsonList.isEmpty? Center(child: CircularProgressIndicator(),) : Center(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20,),
              // Featured Movies Carousel
              CarouselSlider(
                options: CarouselOptions(
                  height: 400,
                  viewportFraction: 0.8,
                  enlargeCenterPage: true,
                  autoPlay: true,
                  autoPlayInterval: const Duration(seconds: 5),
                ),
                items:
                    movies.where((movie) => movie.imageUrl != null).map((movie) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 5.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          image: DecorationImage(
                            image: NetworkImage(movie.imageUrl!),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(0.8),
                              ],
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  movie.title,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                if (movie.description != null)
                                  Text(
                                    movie.description!,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.8),
                                      fontSize: 14,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }).toList(),
              ),
        
              const SizedBox(height: 20),
        
              // Genre-based Horizontal Lists
              ..._buildGenreSections(movies),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildGenreSections(List<Movie> movies) {
    // Get unique genres
    final Set<String> genres = {};
    for (var movie in movies) {
      genres.addAll(movie.genres);
    }

    return genres.map((genre) {
      final genreMovies =
          movies.where((movie) => movie.genres.contains(genre)).toList();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text(
              genre,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: genreMovies.length,
              itemBuilder: (context, index) {
                final movie = genreMovies[index];
                return Container(
                  width: 130,
                  margin: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                              image: NetworkImage(
                                movie.imageUrl ??
                                    'https://via.placeholder.com/130x180',
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        movie.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                      if (movie.rating != null)
                        Row(
                          children: [
                            const Icon(
                              Icons.star,
                              color: Colors.amber,
                              size: 16,
                            ),
                            Text(
                              movie.rating!.toString(),
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      );
    }).toList();
  }
}
