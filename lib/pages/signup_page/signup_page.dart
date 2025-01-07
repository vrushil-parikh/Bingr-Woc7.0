import 'package:bingr/pages/home_page/home_page.dart';
import 'package:bingr/uihelper/uihelper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});
  @override
  State<StatefulWidget> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  signUp(String email, String password) async {
    if (email == "" || password == "") {
      UiHelper.CustomAlertBox(context, "Enter required fields");
    } else {
      UserCredential? usercredential;
      try {
        usercredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password)
            .then((value)async{
              await Future.delayed(Duration(seconds: 1));
              final prefs = await SharedPreferences.getInstance();
              await prefs.setBool('isLoggedIn',true);
          Navigator.pushAndRemoveUntil(
              context, MaterialPageRoute(builder: (context) => HomePage()),(route)=>false);
        });
        FirebaseAuth.instance.setPersistence(Persistence.LOCAL);
      } on FirebaseAuthException catch (e) {
        return UiHelper.CustomAlertBox(context, e.code.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          "Signup Page",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.indigo,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          UiHelper.CustomeTextField(
              emailController, "Email", Icons.email, false),
          UiHelper.CustomeTextField(
              passwordController, "Password", Icons.password, false),
          SizedBox(
            height: 10,
          ),
          UiHelper.CustomeButton(() {
            signUp(emailController.text.toString(), passwordController.text.toString());
          }, "Sign Up")
        ],
      ),
    );
  }
}
