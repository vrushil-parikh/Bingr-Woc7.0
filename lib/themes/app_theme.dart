import 'package:flutter/material.dart';

class AppTheme{
  static ThemeData lightTheme = ThemeData(
    primaryColor: Colors.indigo,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: AppBarTheme(
      color: Colors.indigo,
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      )
    ),
    textTheme: TextTheme(
      headlineLarge: TextStyle(fontSize: 32,color: Colors.black,fontWeight: FontWeight.bold),
      headlineSmall: TextStyle(fontSize: 18,color: Colors.black,fontWeight: FontWeight.w600),
      bodyLarge:TextStyle(fontSize: 16,color: Colors.black87),
      bodySmall: TextStyle(fontSize: 14,color: Colors.black54)
    ),
    buttonTheme: ButtonThemeData(
      buttonColor: Colors.indigo,
      textTheme: ButtonTextTheme.primary
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      selectedItemColor: Colors.indigo,
      unselectedItemColor: Colors.grey,
      backgroundColor: Colors.white
    ),

  );
  static ThemeData darkTheme = ThemeData(
    primaryColor: Colors.black,
    scaffoldBackgroundColor: Colors.black,
    appBarTheme: AppBarTheme(
        color: Colors.black,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        )
    ),
    textTheme: TextTheme(
        headlineLarge: TextStyle(fontSize: 32,color: Colors.white,fontWeight: FontWeight.bold),
        headlineSmall: TextStyle(fontSize: 20,color: Colors.white,fontWeight: FontWeight.w600,),
        bodyLarge:TextStyle(fontSize: 16,color: Colors.white70),
        bodySmall: TextStyle(fontSize: 14,color: Colors.white54)
    ),
    buttonTheme: ButtonThemeData(
      buttonColor: Colors.black,
      textTheme: ButtonTextTheme.primary,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.black
    ),
  );
}


// Text(
// 'Hello, Flutter!',
// style: Theme.of(context).textTheme.headline1,
// );
//
// ElevatedButton(
// onPressed: () {},
// child: Text('Click Me'),
// style: ElevatedButton.styleFrom(
// primary: Theme.of(context).primaryColor, // Use the primary color
// ),
// );
