import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../models/movie_model.dart';
import '../DetailView/detail_view_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController searchController = TextEditingController();
  List<Movie> searchResults = [];
  List<String> autocompleteSuggestions = [];
  bool isLoading = false;
  bool showSuggestions = false;

  Future<void> fetchAutocompleteSuggestions(String query) async {
    if (query.isEmpty) {
      setState(() {
        autocompleteSuggestions = [];
        showSuggestions = false;
      });
      return;
    }

    const Map<String, String> headers = {
      "x-rapidapi-host": "imdb236.p.rapidapi.com",
      "x-rapidapi-key": "fc3ca915a4msh5db06750d7fa8c4p1523b6jsn34cef66d73af",
    };

    final url = "https://imdb236.p.rapidapi.com/imdb/autocomplete?query=$query";

    try {
      final response = await http.get(Uri.parse(url), headers: headers);
      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = jsonDecode(response.body);
        setState(() {
          autocompleteSuggestions = jsonResponse.map((item) => item["title"].toString()).toList();
          showSuggestions = autocompleteSuggestions.isNotEmpty;
        });
      } else {
        setState(() => showSuggestions = false);
        print("Failed to load autocomplete: ${response.statusCode}");
      }
    } catch (e) {
      setState(() => showSuggestions = false);
      print("Error fetching autocomplete: $e");
    }
  }

  Future<void> fetchSearchResults(String query) async {
    if (query.isEmpty) return;

    setState(() {
      isLoading = true;
      searchResults = [];
      showSuggestions = false; // Hide suggestions when search is performed
    });

    const Map<String, String> headers = {
      "x-rapidapi-host": "imdb236.p.rapidapi.com",
      "x-rapidapi-key": "fc3ca915a4msh5db06750d7fa8c4p1523b6jsn34cef66d73af",
    };

    final url = "https://imdb236.p.rapidapi.com/imdb/search?type=movie&query=$query&rows=25";

    try {
      final response = await http.get(Uri.parse(url), headers: headers);
      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = jsonDecode(response.body);
        List<Movie> fetchedMovies = jsonResponse.map((json) => Movie.fromJson(json)).toList();
        setState(() {
          searchResults = fetchedMovies;
        });
      } else {
        print("Failed to load search results: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching search results: $e");
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => showSuggestions = false), // Hide suggestions when tapping outside
      child: Scaffold(
        appBar: AppBar(title: const Text("Search Movies")),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: "Search for movies...",
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onChanged: (query) => fetchAutocompleteSuggestions(query),
                onSubmitted: (query) => fetchSearchResults(query),
              ),

              // Autocomplete Suggestions Box
              if (showSuggestions)
                Container(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.3, // Limit height
                  ),
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)],
                  ),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: autocompleteSuggestions.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(autocompleteSuggestions[index]),
                        onTap: () {
                          searchController.text = autocompleteSuggestions[index];
                          fetchSearchResults(autocompleteSuggestions[index]);
                          setState(() => showSuggestions = false);
                        },
                      );
                    },
                  ),
                ),

              const SizedBox(height: 10),

              // Search Results Grid
              Expanded(
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : searchResults.isEmpty
                    ? const Center(child: Text("No results found"))
                    : GridView.builder(
                  padding: const EdgeInsets.all(8),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 0.7,
                  ),
                  itemCount: searchResults.length,
                  itemBuilder: (context, index) {
                    final movie = searchResults[index];
                    return buildMovieCard(movie);
                  },
                ),
              ),
            ],
          ),
        ),
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
                return Image.asset('assets/images/placeholder.jpg', fit: BoxFit.cover, width: 150, height: 200);
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
