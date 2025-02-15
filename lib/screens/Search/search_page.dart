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
      "x-rapidapi-key": "3cbe6b1841mshdf9bfd2110f25c3p1784b0jsn3083220044db",
    };

    final url = "https://imdb236.p.rapidapi.com/imdb/autocomplete?query=$query";

    try {
      final response = await http.get(Uri.parse(url), headers: headers);

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);

        print("Autocomplete API Raw Response: $jsonResponse");

        // Ensure the response is a list
        if (jsonResponse is List) {
          // Extract only the titles from the response
          List<String> fetchedSuggestions = jsonResponse.map<String>((item) {
            return item['primaryTitle'] ?? "Unknown";
          }).toList();

          setState(() {
            autocompleteSuggestions = fetchedSuggestions;
            
            showSuggestions = autocompleteSuggestions.isNotEmpty; // Toggle visibility based on suggestions
            print("Updated Autocomplete Suggestions: $autocompleteSuggestions");
          });
        } else {
          print("Unexpected response format: $jsonResponse");
          setState(() {
            autocompleteSuggestions = [];
            showSuggestions = false;
          });
        }
      } else {
        print("Failed to load autocomplete suggestions: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching autocomplete: $e");
    }
  }


  Future<void> fetchSearchResults(String query) async {
    if (query.isEmpty) return;

    setState(() {
      isLoading = true;
      searchResults = [];
      showSuggestions = false;
    });

    const Map<String, String> headers = {
      "x-rapidapi-host": "imdb236.p.rapidapi.com",
      "x-rapidapi-key": "3cbe6b1841mshdf9bfd2110f25c3p1784b0jsn3083220044db",
    };

    final url = "https://imdb236.p.rapidapi.com/imdb/search?type=movie&query=$query&rows=25";

    try {
      final response = await http.get(Uri.parse(url), headers: headers);

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);

        if (jsonResponse == null || !jsonResponse.containsKey('results')) {
          setState(() {
            searchResults = [];
          });
        } else {
          List<dynamic> resultsList = jsonResponse["results"];
          List<Movie> fetchedMovies = resultsList.map((json) => Movie.fromJson(json)).toList();

          setState(() {
            searchResults = fetchedMovies;
          });
        }
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
                onChanged: (query) {
                  fetchAutocompleteSuggestions(query); // This will trigger the fetch of suggestions
                },
                onSubmitted: (query) => fetchSearchResults(query),
              ),

              // Autocomplete Suggestions Box
              if (showSuggestions && autocompleteSuggestions.isNotEmpty)
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
