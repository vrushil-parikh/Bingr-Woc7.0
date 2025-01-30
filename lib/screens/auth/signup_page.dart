import 'package:bingr/screens/home/home_page.dart';
import 'package:bingr/widgets/uihelper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../widgets/input_helper.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<StatefulWidget> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  bool _isLoading = false; // Track loading state

  signUp(String email, String password, String userName) async {
    if (email.isEmpty || password.isEmpty || userName.isEmpty) {
      UiHelper.CustomAlertBox(context, "Enter required fields");
      return;
    }

    setState(() {
      _isLoading = true; // Show progress indicator
    });

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      User? user = userCredential.user;

      if (user != null) {
        debugPrint("User Created: ${user.uid}");

        // Store login state in SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);

        // Update display name in Firebase Auth
        await user.updateDisplayName(userName);
        await user.reload();
        user = FirebaseAuth.instance.currentUser;

        // Store user data in Firestore
        await FirebaseFirestore.instance.collection("users").doc(user?.uid).set({
          "name": userName,
          "email": email,
          "createdAt": DateTime.now(),
        });

        debugPrint("User details updated in Firestore");

        // Set Firebase Auth persistence


        // Navigate to Home Page
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
          );
        }
      }
    } on FirebaseAuthException catch (e) {
      debugPrint("Firebase Auth Error: ${e.code}");
      UiHelper.CustomAlertBox(context, e.message ?? "Signup failed");
    } catch (e) {
      debugPrint("Signup Error: $e");
      UiHelper.CustomAlertBox(context, "An unexpected error occurred");
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false; // Hide progress indicator
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var themeColor = Theme.of(context).primaryColor;
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text("Signup Page", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.indigo,
      ),
      body: Center(
        child: _isLoading
            ? CircularProgressIndicator(color: themeColor,) // Show loading indicator
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25,vertical: 15),
              child: TextField(
                obscureText: false,
                controller: nameController,
                decoration: InputDecoration(
                    hintText: "Name",
                    hintStyle: TextStyle(color: themeColor),
                    prefixIcon: Icon(
                      Icons.person,
                      color: themeColor,
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: themeColor, width: 1)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: themeColor, width: 2)),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8))),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25,vertical: 15),
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
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25,vertical: 15),
              child: CustomPasswordTextField(controller: passwordController, hintText: "password", iconData: Icons.key,),
            ),
            const SizedBox(height: 10),
            UiHelper.CustomeButton(() {
              signUp(
                emailController.text.trim(),
                passwordController.text.trim(),
                nameController.text.trim(),
              );
            }, "Sign Up"),
          ],
        ),
      ),
    );
  }
}
