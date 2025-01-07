import 'package:bingr/pages/login_page/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  _logOut()async{

    await Future.delayed(Duration(seconds: 1));
    final pref = await SharedPreferences.getInstance();
    await pref.setBool('isLoggedIn', false);
    FirebaseAuth.instance.signOut().then((value){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoginPage()));
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          "Home Page",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.indigo,
        actions: [
          IconButton(onPressed: (){
            _logOut();
          }, icon: Icon(Icons.logout))
        ],
      ),
      body: Center(
        child: Text(
          'Home Page',
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
