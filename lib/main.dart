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
      home: const MainPage(title: 'Pet Care'),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key, required this.title});

  final String title;

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  String _nameText = "Input Name";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 241, 255, 232),
      body: Center(
        child: Column(
          children: <Widget>[
            const SizedBox(height: 100),
            Center(
              child: Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/Dog.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                FloatingActionButton.small(
                  onPressed: () {},
                  shape: CircleBorder(),
                  child: Icon(Icons.edit, color: Colors.white),
                ),
                const SizedBox(width: 10),
                Text(_nameText),
              ],
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
