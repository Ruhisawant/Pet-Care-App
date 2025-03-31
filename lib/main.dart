import 'package:flutter/material.dart';
import 'reminders.dart';
import 'schedules.dart';
import 'illness.dart';

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
  final TextEditingController _controller = TextEditingController();
  String _nameText = "Input Name";
  String _asset = "assets/images/Dog.png";
  String _tip = "Click the Question Mark";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 241, 255, 232),
      body: Center(
        child: Column(
          children: <Widget>[
            const SizedBox(height: 75),
            Image.asset(_asset, height: 200, width: 300, scale: .8),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(flex: 2, child: Text('')),
                Expanded(
                  flex: 2,
                  child: FloatingActionButton.small(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text('Input Name'),
                            content: TextField(
                              controller: _controller,
                              decoration: InputDecoration(
                                hintText: 'Type here...',
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('Cancel'),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    _nameText = _controller.text;
                                  });
                                  Navigator.of(context).pop();
                                },
                                child: Text('Save'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    shape: CircleBorder(),
                    child: Icon(Icons.edit, color: Colors.white),
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Container(
                    height: 35,
                    width: 50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(50),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10.0,
                          spreadRadius: 2.0,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Center(child: Text(_nameText)),
                  ),
                ),
                Expanded(flex: 4, child: SizedBox(width: 1)),
              ],
            ),
            const SizedBox(height: 100),
            Row(
              children: [
                Expanded(flex: 1, child: SizedBox(width: 1)),
                Expanded(
                  flex: 6,
                  child: Container(
                    height: 200,
                    width: 200,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 60, 70, 80),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black,
                          blurRadius: 10.0,
                          spreadRadius: 2.0,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: <Widget>[
                        Expanded(
                          flex: 2,
                          child: Center(
                            child: const Text(
                              "Tips",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Center(
                            child: Text(
                              _tip,
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        Expanded(flex: 1, child: SizedBox(width: 1)),
                      ],
                    ),
                  ),
                ),
                Expanded(flex: 3, child: SizedBox(width: 1)),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: Column(
        verticalDirection: VerticalDirection.up,
        children: <Widget>[
          FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RemindersPage()),
              );
            },
            child: const Icon(Icons.restaurant, color: Colors.white),
          ),
          const SizedBox(height: 16),
          FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SchedulesPage()),
              );
            },
            child: const Icon(Icons.event, color: Colors.white),
          ),
          const SizedBox(height: 16),
          FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => IllnessPage()),
              );
            },
            child: const Icon(Icons.medication, color: Colors.white),
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
