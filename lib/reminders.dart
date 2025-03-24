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

  createPlan(String name, String description, String priority) {
    if (name.isEmpty) return;

    setState(() {
      plans.add(Plan(name: name, description: description, priority: priority, isCompleted: false,));
      _sortPlansByPriority();
    });
  }

  void toggleCompletion(int index) {
    setState(() {
      plans[index].isCompleted = !plans[index].isCompleted;
    });
  }

  void updatePlan(Plan plan) {
    setState(() {
      _sortPlansByPriority();
    });
  }

  void _sortPlansByPriority() {
    setState(() {
      plans.sort((a, b) {
        final priorityComparison =
            getPriorityValue(b.priority).compareTo(getPriorityValue(a.priority));
        if (priorityComparison != 0) return priorityComparison;
        
        return a.name.compareTo(b.name);
      });
    });
  }

  int getPriorityValue(String priority) {
    switch (priority) {
      case 'High':
        return 3;
      case 'Medium':
        return 2;
      case 'Low':
        return 1;
      default:
        return 0;
    }
  }

  Color getPriorityColor(String priority) {
    switch (priority) {
      case 'High':
        return Colors.red.shade300;
      case 'Medium':
        return Colors.orange.shade300;
      case 'Low':
        return Colors.blue.shade300;
      default:
        return Colors.grey;
    }
  }

  void deletePlan(Plan plan) async {
    setState(() {
      plans.remove(plan);
    });
  }

  void showAddReminderDialog(BuildContext context) {
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();
    String selectedPriority = 'Medium';

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text("Add Reminder"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(labelText: "Title"),
                  ),
                  TextField(
                    controller: descriptionController,
                    decoration: InputDecoration(labelText: "Description"),
                  ),
                  DropdownButton<String>(
                    value: selectedPriority,
                    onChanged: (newValue) {
                      setDialogState(() {
                        selectedPriority = newValue!;
                      });
                    },
                    items: ['High', 'Medium', 'Low']
                        .map((priority) => DropdownMenuItem(
                              value: priority,
                              child: Text(priority),
                            ))
                        .toList(),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("Cancel"),
                ),
                TextButton(
                  onPressed: () {
                    createPlan(nameController.text, descriptionController.text, selectedPriority);
                    Navigator.pop(context);
                  },
                  child: Text("Add"),
                ),
              ],
            );
          },
        );
      },
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center( 
       child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
              ),
              child: Text('Go to Home')
            ),
            Expanded(
              child: plans.isEmpty
                ? Center(child: Text("No reminders yet!", style: TextStyle(fontSize: 16)))
                : ListView.builder(
                    itemCount: plans.length,
                    itemBuilder: (context, index) {
                      final plan = plans[index];
                      return ListTile(
                        tileColor: plan.isCompleted ? Colors.green[300] : getPriorityColor(plan.priority),
                        leading: IconButton(
                          icon: Icon(
                            plan.isCompleted ? Icons.check_circle : Icons.circle_outlined,
                            color: plan.isCompleted ? Colors.blue : Colors.grey,
                          ),
                          onPressed: () => toggleCompletion(index),
                        ),
                        title: Text(
                          plan.name,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            decoration: plan.isCompleted ? TextDecoration.lineThrough : null,
                          ),
                        ),
                        subtitle: Text(plan.description),
                      );
                    }
                  )
            ),
            FloatingActionButton(
              onPressed: () => showAddReminderDialog(context),
              child: Icon(Icons.add), 
            )
          ]
        )
      )
    );
  }
}