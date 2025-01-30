import 'package:flutter/material.dart';

class MovieDrawerPage extends StatefulWidget {
  const MovieDrawerPage({super.key});

  @override
  State<MovieDrawerPage> createState() => _MovieDrawerPageState();
}

class _MovieDrawerPageState extends State<MovieDrawerPage> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(title: Text("Movies"),),
      body: Center(child: Text("Movie Page"),),
    );
  }
}
