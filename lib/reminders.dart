import 'package:flutter/material.dart';
import 'package:pet_care_app/main.dart';

class Reminders extends StatefulWidget {
  const Reminders({super.key});

  @override
  State<Reminders> createState() => _RemindersState();
}

class Plan{
  String name;
  String date;
  String priority;
  String description;
  bool isCompleted;

  Plan({
    required this.name,
    required this.date,
    required this.priority,
    required this.description,
    required this.isCompleted
  });
}

class _RemindersState extends State<Reminders> {
  List<Plan> plans = [];

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
  
  createPlan(String name, String date, String priority, String description) {
    if (name.isEmpty) return;

    setState(() {
      plans.add(Plan(name: name, date: date, priority: priority, description: description, isCompleted: false));
      _sortPlansByPriority();
    });
  }

  void updatePlan(Plan plan) {
    setState(() {
      _sortPlansByPriority();
    });
  }

  void deletePlan(Plan plan) {
    setState(() {
      plans.remove(plan);
    });
  }

  void toggleCompletion(int index) {
    setState(() {
      plans[index].isCompleted = !plans[index].isCompleted;
    });
  }

  void _sortPlansByPriority() {
    setState(() {
      plans.sort((a, b) {
        final priorityComparison = getPriorityValue(b.priority).compareTo(getPriorityValue(a.priority));
        if (priorityComparison != 0) return priorityComparison;
        
        return a.name.compareTo(b.name);
      });
    });
  }

  void showAddReminderDialog(BuildContext context) {
    final nameController = TextEditingController();
    final dateController = TextEditingController();
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
                  TextField(
                    controller: dateController,
                    decoration: InputDecoration(labelText: "Date (MM-DD-YYYY)"),
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
                    createPlan(nameController.text, dateController.text, selectedPriority, descriptionController.text);
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
      body: Padding( 
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
              ),
              child: Text('Home')
            ),

            SizedBox(height: 20),
            Expanded(
              child: plans.isEmpty
                ? Center(child: Text("No reminders yet!", style: TextStyle(fontSize: 20)))
                : ListView.builder(
                    itemCount: plans.length,
                    itemBuilder: (context, index) {
                      final plan = plans[index];
                      return Container(
                        margin: EdgeInsets.symmetric(vertical: 6),
                        decoration: BoxDecoration(
                          color: plan.isCompleted ? Colors.green[200] : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade300),     
                        ),
                        child: ListTile(
                          leading: IconButton(
                            icon: Icon(
                              plan.isCompleted ? Icons.check_circle : Icons.circle_outlined,
                              color: plan.isCompleted ? Colors.green : Colors.grey,
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
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'Date: ${plan.date}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    'Priority: ${plan.priority}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: getPriorityColor(plan.priority),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 4),
                              Text(plan.description),
                            ],
                          ),
                          trailing: IconButton(
                            icon: Icon(
                              Icons.delete,
                              color: Colors.red.shade300,
                            ),
                            onPressed: () => deletePlan(plan),
                          ),
                        )
                      );
                    }
                  )
            ),
          ]
        )
      ),
      floatingActionButton: Align(
        alignment: Alignment.bottomRight,
        child: FloatingActionButton(
          onPressed: () => showAddReminderDialog(context),
          child: Icon(Icons.add),
        ),
      ),      
    );
  }
}