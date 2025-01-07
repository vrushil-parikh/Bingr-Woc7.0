import 'package:bingr/pages/forgot_password_page/forgot_password_page.dart';
import 'package:bingr/pages/home_page/home_page.dart';
import 'package:bingr/pages/signup_page/signup_page.dart';
import 'package:bingr/uihelper/uihelper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget{
  const LoginPage({super.key});

  @override
  State<StatefulWidget> createState() => _LoginPageState();

}

class _LoginPageState extends State<LoginPage>{

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  login(String email,String password)async{
    if(email=="" || password==""){
      UiHelper.CustomAlertBox(context, "Enter the required fields");
    }else{
      UserCredential? usercredential;
      try{
        usercredential = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password).then((value)async{
          await Future.delayed(Duration(seconds: 1));
          final prefs= await SharedPreferences.getInstance();
          await prefs.setBool('isLoggedIn',true);
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=> HomePage()), (route)=> false);
        });
      }
      on FirebaseAuthException catch(e){
        UiHelper.CustomAlertBox(context, e.code.toString());
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(title: Text('Login Page',style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.indigo,
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            UiHelper.CustomeTextField(emailController, "email", Icons.mail, false),
            UiHelper.CustomeTextField(passwordController, "password", Icons.password, true),
            SizedBox(height: 10,),
            UiHelper.CustomeButton((){
              login(emailController.text.toString(), passwordController.text.toString());
            }, "Login"),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Don't have an account?",style: TextStyle(fontSize: 20),),
                TextButton(onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> SignupPage()));
                }, child: Text("Sign Up",style: TextStyle(fontSize:20,fontWeight: FontWeight.w500),)),
                
              ],
            ),

            TextButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>ForgetPasswordPage()));
            }, child: Text("Forgot Password?",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500),))

          ],
        ),
      ),
    );
  }

}