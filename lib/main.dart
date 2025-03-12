import 'package:flutter/material.dart';

void main() {
  runApp(const PetCareApp());
}

class PetCareApp extends StatelessWidget {
  const PetCareApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pet Care App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const HomePage(title: 'Pet Care'),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 241, 255, 232),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[],
        ),
      ),
      floatingActionButton: Column(
        verticalDirection: VerticalDirection.up,
        children: <Widget>[
          FloatingActionButton(onPressed: () {}),
          const SizedBox(height: 16),
          FloatingActionButton(onPressed: () {}),
          const SizedBox(height: 16),
          FloatingActionButton(
            onPressed: () {},
            child: const Icon(Icons.question_mark, color: Colors.white),
            shape: CircleBorder(),
          ),
        ],
      ),
    );
  }
}
