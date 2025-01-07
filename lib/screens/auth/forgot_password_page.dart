import 'package:bingr/widgets/uihelper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgetPasswordPage extends StatefulWidget {
  const ForgetPasswordPage({super.key});

  @override
  State<ForgetPasswordPage> createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {
  TextEditingController idController = TextEditingController();

  forgotPassword(String email)async{
    if(email==""){
      UiHelper.CustomAlertBox(context, "Enter an email to reset password");
    }
    else{
      FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Forgot password',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.indigo,
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          UiHelper.CustomeTextField(idController, "email id", Icons.mail, false),
          UiHelper.CustomeButton((){
            forgotPassword(idController.text.toString());
          }, "Reset password")
        ],
      ),
    );
  }
}
