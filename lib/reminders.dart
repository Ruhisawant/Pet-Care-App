import 'package:flutter/material.dart';
import 'package:pet_care_app/main.dart';

class Reminders extends StatefulWidget {
  const Reminders({super.key});

  @override
  State<Reminders> createState() => _RemindersState();
}

class Plan{
  String name;
  String description;
  // DateTime date;
  String priority;
  bool isCompleted;

  Plan({
    required this.name,
    required this.description,
    // required this.date,
    required this.priority,
    required this.isCompleted
  });
}

class _RemindersState extends State<Reminders> {
  List<Plan> plans = [];
  // final dateFormat = DateFormat('MM dd, yyyy');

  void createPlan(String name, String description, DateTime date, String priority) {
    if (name.isEmpty) return;
    
    final newPlan = Plan(
      name: name,
      description: description,
      // date: date,
      priority: priority,
      isCompleted: false,
    );

    setState(() {
      plans.add(newPlan);
      // _sortPlansByPriority();
    });
  }

  void updatePlan(Plan plan) {
    setState(() {
      // _sortPlansByPriority();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center( 
       child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomePage(),
                  ),
                );
              },
              child: Text('Go to Home')
            ),
            
          ],
        ),
      )
    );
  }
}