import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../DetailView/detail_view_page.dart';


class WatchlistPage extends StatelessWidget {
  final String userId = FirebaseAuth.instance.currentUser?.uid ?? "guest";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(title: const Text("My Watchlist")),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('watchlist')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          var watchlist = snapshot.data!.docs;

          if (watchlist.isEmpty) {
            return const Center(
              child: Text(
                "No movies in your watchlist!",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            );
          }

          return ListView.builder(
            itemCount: watchlist.length,
            itemBuilder: (context, index) {
              var movie = watchlist[index];

              return Container(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white, // Light indigo background
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  tileColor: Colors.indigo, // Indigo tile background
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      movie['poster'],
                      width: 60,
                      height: 90,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset('assets/images/app_logo.png',
                            width: 60, height: 90, fit: BoxFit.cover);
                      },
                    ),
                  ),
                  title: Text(
                    movie['title'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.black87,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.indigo),
                    onPressed: () async {
                      await FirebaseFirestore.instance
                          .collection('users')
                          .doc(userId)
                          .collection('watchlist')
                          .doc(movie.id)
                          .delete();

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Removed from Watchlist!")),
                      );
                    },
                  ),
                  onTap: () {
                    // Navigate to Movie Detail Page
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MovieDetailPage(movieId: movie['movieId']),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
