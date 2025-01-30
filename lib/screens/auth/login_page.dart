import 'package:bingr/screens/auth/forgot_password_page.dart';
import 'package:bingr/screens/home/home_page.dart';
import 'package:bingr/screens/auth/signup_page.dart';
import 'package:bingr/widgets/input_helper.dart';
import 'package:bingr/widgets/uihelper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  login(String email, String password) async {
    if (email == "" || password == "") {
      UiHelper.CustomAlertBox(context, "Enter the required fields");
    } else {
      UserCredential? usercredential;
      try {
        usercredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password)
            .then((value) async {
          await Future.delayed(Duration(seconds: 1));
          final prefs = await SharedPreferences.getInstance();
          await prefs.setBool('isLoggedIn', true);
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
              (route) => false);
        });
      } on FirebaseAuthException catch (e) {
        UiHelper.CustomAlertBox(context, e.code.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final GoogleSignIn _googleSignIn = GoogleSignIn();
    final themeColor = Theme.of(context).primaryColor;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 50,
            ),
            Container(
                alignment: Alignment.topLeft,
                height: 200,
                child: Image.asset("assets/images/app_logo.png")),
            Column(
              children: [
                Text(
                  "Welcome Back,",
                  style: TextStyle(
                      fontFamily: "MyCustomFont",
                      fontSize: 30,
                      color: themeColor),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25, vertical: 0),
                  child: Text(
                    "Login to start Binge,",
                    style: TextStyle(
                        fontFamily: "MyCustomFont",
                        fontSize: 20,
                        color: themeColor),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 8),
              child: TextField(
                obscureText: false,
                controller: emailController,
                decoration: InputDecoration(
                    hintText: "Email",
                    hintStyle: TextStyle(color: themeColor),
                    prefixIcon: Icon(
                      Icons.email_outlined,
                      color: themeColor,
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: themeColor, width: 1)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: themeColor, width: 2)),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8))),
              ),
            ), //Input Email
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 8),
              child: CustomPasswordTextField(controller: passwordController, hintText: "password", iconData: Icons.key,)
            ), //Input Password
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15),
              alignment: Alignment.centerRight,
              child: TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ForgetPasswordPage()));
                  },
                  child: Text(
                    "Forgot Password?",
                    style: TextStyle(
                        color: Colors.lightBlueAccent,
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                  )),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 25),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      maximumSize: Size(
                        MediaQuery.of(context).size.width - 16,
                        50,
                      ),
                      minimumSize: Size(
                        MediaQuery.of(context).size.width - 16,
                        50,
                      ),
                      overlayColor: themeColor,
                      elevation: 0,
                      backgroundColor: themeColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5))),
                  onPressed: () {
                    login(emailController.text.toString(),
                        passwordController.text.toString());
                  },
                  child: Text(
                    "LOGIN",
                    style: TextStyle(color: Colors.white, fontSize: 22),
                  )),
            ), //Login Button
            Center(
                child: Text(
              "OR",
              style: TextStyle(
                color: themeColor,
              ),
            )),
            Center(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(width: 2,color: themeColor)
                ),
                child: ElevatedButton.icon(
                  onPressed: () async {
                    try {
                      final GoogleSignInAccount? user = await _googleSignIn.signIn();
                      if (user != null) {
                        print('Signed in: ${user.displayName}');
                      }
                    } catch (error) {
                      print('Error signing in: $error');
                    }
                  },
                  icon: Image.asset(
                    'assets/images/google_logo.png', // Add Google logo in your assets
                    height: 24,
                  ),
                  label: Text('Sign in with Google'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    maximumSize: Size(
                      MediaQuery.of(context).size.width - 64,
                      50,
                    ),
                    minimumSize: Size(
                      MediaQuery.of(context).size.width - 64,
                      50,
                    ),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                    foregroundColor: Colors.black,
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    textStyle: TextStyle(fontSize: 16, color: themeColor),
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Don't Have an Account?",
                  style: TextStyle(fontSize: 16,color: themeColor),
                ),
                TextButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => SignupPage()));
                    },
                    child: Text(
                      "Signup",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500,color: Colors.lightBlueAccent),
                    )),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
