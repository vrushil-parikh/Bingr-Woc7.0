import 'package:bingr/screens/Home/movie_page.dart';
import 'package:bingr/screens/Search/search_page.dart';
import 'package:bingr/screens/WatchList/favourite_page.dart';
import 'package:bingr/screens/auth/login_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../resources/app_strings.dart';
import '../../resources/app_values.dart';
import '../Movies/movie_drawer_page.dart';
import '../TV Shows/tv_shows_page.dart';
import '../WatchList/watchlist_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String userName = "Guest";
  String userEmail = "No Email";
  bool isLoading = true; // Loading indicator

  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try {
      debugPrint("Fetching user data...");

      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        debugPrint("No logged-in user found.");
        return;
      }

      debugPrint("User ID: ${user.uid}");

      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection("users")
          .doc(user.uid)
          .get();

      setState(() {
        if (userDoc.exists) {
          debugPrint("User Data: ${userDoc.data()}");
          userName = userDoc.get("name") ?? user.displayName ?? "No Name";
          userEmail = userDoc.get("email") ?? user.email ?? "No Email";
        } else {
          // If Google login user doesn't exist in Firestore, update it
          userName = user.displayName ?? "No Name";
          userEmail = user.email ?? "No Email";

          FirebaseFirestore.instance.collection("users").doc(user.uid).set({
            "name": userName,
            "email": userEmail,
            "createdAt": DateTime.now(),
          });
        }
        isLoading = false;
      });
    } catch (e) {
      debugPrint("Error fetching user data: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _logOut() async {
    await Future.delayed(const Duration(seconds: 1));
    final pref = await SharedPreferences.getInstance();
    await pref.setBool('isLoggedIn', false);
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const LoginPage()));
  }

  final List<Widget> _screens = [
     MoviePage(), // Your existing HomePage
     SearchPage(),
     WatchlistPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          title: const Text(
            "Binger",
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          backgroundColor: Colors.indigo,
        ),
        body: IndexedStack(
          index: _selectedIndex,
          children: _screens,
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(
              label: AppStrings.movies,
              icon: Icon(
                Icons.movie_creation_rounded,
                size: AppSize.s20,
              ),
            ),
            BottomNavigationBarItem(
              label: AppStrings.search,
              icon: Icon(
                Icons.search_rounded,
                size: AppSize.s20,
              ),
            ),
            BottomNavigationBarItem(
              label: AppStrings.watchlist,
              icon: Icon(
                Icons.bookmark_rounded,
                size: AppSize.s20,
              ),
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: (index) => _onItemTapped(index),
        ),
        drawer: Drawer(
          child: Container(
            color: Colors.white,
            child: Column(
              mainAxisAlignment:
              MainAxisAlignment.spaceBetween, // Pushes logout button down
              children: [
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      UserAccountsDrawerHeader(
                        decoration: const BoxDecoration(
                          color: Colors.indigo,
                        ),
                        currentAccountPicture: const CircleAvatar(child: Icon(Icons.account_circle,color: Colors.white,size: 80,),backgroundColor: Colors.transparent,),
                        accountName: Text(userName),
                        accountEmail: Text(userEmail),
                      ),
                      ListTile(
                        leading:
                        const Icon(Icons.movie, color: Colors.black),
                        title: const Text('Movies',
                            style: TextStyle(color: Colors.black)),
                        onTap: () {
                          Navigator.pop(context); // Close drawer
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MovieListPage(
                                      apiUrl:
                                      "https://imdb236.p.rapidapi.com/imdb/top250-movies",
                                      title: "Top Movies")));
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.tv, color: Colors.black),
                        title: const Text('TV Shows',
                            style: TextStyle(color: Colors.black)),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => TvShowsPage(
                                    apiUrl:
                                    "https://imdb236.p.rapidapi.com/imdb/top250-tv",
                                    title: "Popular TV Shows",
                                  )));
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.favorite, color: Colors.black),
                        title: const Text('Favourite',
                            style: TextStyle(color: Colors.black)),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => FavouritePage()));
                        },
                      ),
                    ],
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.black),
                  title: const Text('Logout',
                      style: TextStyle(color: Colors.black)),
                  onTap: () {
                    Navigator.pop(context); // Close drawer
                    _logOut();
                  },
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ));
  }
}
