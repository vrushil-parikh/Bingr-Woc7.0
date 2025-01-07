import 'package:bingr/screens/home/home_page.dart';
import 'package:bingr/screens/auth/login_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState(){
    super.initState();
    _checkLogInStatus();
  }
  Future<void> _checkLogInStatus() async{
    final pref = await SharedPreferences.getInstance();
    final isLoggedIn = pref.getBool('isLoggedIn') ?? false;
    if(isLoggedIn){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> HomePage()));
    }
    else{
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoginPage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
