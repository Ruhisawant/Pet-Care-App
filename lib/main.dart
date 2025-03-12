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
          children: <Widget>[
            Center(
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/Dog.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/Dog.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Column(
        verticalDirection: VerticalDirection.up,
        children: <Widget>[
          FloatingActionButton(
            onPressed: () {},
            child: const Icon(Icons.restaurant, color: Colors.white),
          ),
          const SizedBox(height: 16),
          FloatingActionButton(
            onPressed: () {},
            child: const Icon(Icons.event, color: Colors.white),
          ),
          const SizedBox(height: 16),
          FloatingActionButton(
            onPressed: () {},
            shape: CircleBorder(),
            child: const Icon(Icons.question_mark, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
