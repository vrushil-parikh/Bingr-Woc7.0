import 'package:bingr/screens/auth/login_page.dart';
import 'package:bingr/screens/auth/signup_page.dart';
import 'package:flutter/material.dart';
class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {

  @override
  Widget build(BuildContext context) {
    final themeColor = Theme.of(context).primaryColor;
    return Scaffold(

      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 250,child: Center(
            child: Hero(
                tag: 'HeroTag',
                child: Image.asset("assets/images/app_logo.png")),
          ),),
          SizedBox(height: 100,),
          Text("Binge Worthy Content",style: TextStyle(fontSize: 30,color: themeColor,fontWeight: FontWeight.bold,fontFamily:'MyCustomFont')),
          Text("Just a Tap AwayContent",style: TextStyle(fontSize: 20,color: themeColor,fontWeight: FontWeight.bold,fontFamily:'MyCustomFont'),),
          SizedBox(height: 30,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 50,
                width: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(width: 2,color: themeColor)
                ),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      overlayColor: themeColor,
                      elevation: 0,
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)
                      )
                    ),
                    onPressed: (){
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoginPage()));
                    }, child: Text("Login",style: TextStyle(color: themeColor,fontSize: 22),)),
              ),
              SizedBox(width: 10,),
              Container(
                height: 50,
                width: 150,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(width: 2,color: themeColor),
                  color: themeColor
                ),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        overlayColor: themeColor,
                        elevation: 0,
                        backgroundColor: themeColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)
                        )
                    ),
                    onPressed: (){
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>SignupPage()));
                    }, child: Text("Signup",style: TextStyle(color: Colors.white,fontSize: 22),)),
              ),

            ],
          )


        ],
      ),
    );
  }
}