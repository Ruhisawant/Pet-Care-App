import 'package:flutter/material.dart';
import 'package:pet_care_app/main.dart';

class Care extends StatefulWidget {
  const Care({super.key});

  @override
  State<Care> createState() => _CareState();
}

class Schedule{
  String food;
  String description;
  DateTime date;
  bool isCompleted;

  Schedule({
    required this.food,
    required this.description,
    required this.date,
    required this.isCompleted
  });
}

class _CareState extends State<Care> {
  List<Schedule> schedules = [];

  createSchedule(String food, String description, DateTime date) {
    setState(() {
      schedules.add(Schedule(food: food, description: description, date: date, isCompleted: false));
    });
  }

  // void updatePlan(Schedule schedule) {
  //   setState(() {
  //     _sortPlansByPriority();
  //   });
  // }

  void deleteSchedule(Schedule schedule) {
    setState(() {
      schedules.remove(schedule);
    });
  }

  void toggleCompletion(int index) {
    setState(() {
      schedules[index].isCompleted = !schedules[index].isCompleted;
    });
  }

  void showAddScheduleDialog(BuildContext context) {
    String selectedFood = 'Food';
    final descriptionController = TextEditingController();
    final dateController = TextEditingController();
    DateTime? selectedDate;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text("Add Schedule"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButton<String>(
                    value: selectedFood,
                    onChanged: (newValue) {
                      setDialogState(() {
                        selectedFood = newValue!;
                      });
                    },
                    items: ['Food', 'Water']
                      .map((priority) => DropdownMenuItem(
                        value: priority,
                        child: Text(priority),
                      ))
                      .toList(),
                  ),
                  TextField(
                    controller: descriptionController,
                    decoration: InputDecoration(labelText: "Description"),
                  ),
                  TextField(
                    controller: null,
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: "Date",
                      suffixIcon: IconButton(
                        icon: Icon(Icons.calendar_today),
                        onPressed: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                          );
                          if (pickedDate != null) {
                            setDialogState(() {
                              selectedDate = pickedDate;
                              dateController.text = "${pickedDate.toLocal()}".split(' ')[0];
                            });
                          }
                        },
                      ),
                    ),
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
                    if (selectedDate != null) {
                      createSchedule(selectedFood, descriptionController.text, selectedDate!);
                    }
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
              child: schedules.isEmpty
                ? Center(child: Text("No schedules yet!", style: TextStyle(fontSize: 20)))
                : ListView.builder(
                    itemCount: schedules.length,
                    itemBuilder: (context, index) {
                      final schedule = schedules[index];
                      return Container(
                        margin: EdgeInsets.symmetric(vertical: 6),
                        decoration: BoxDecoration(
                          color: schedule.isCompleted
                            ? Colors.green[200]
                            : schedule.food == 'Food' ? Colors.brown[300] : Colors.blue[300],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade300),     
                        ),
                        child: ListTile(                          
                          leading: IconButton(
                            icon: Icon(
                              schedule.isCompleted ? Icons.check_circle : Icons.circle_outlined,
                              color: schedule.isCompleted ? Colors.green : Colors.grey,
                            ),
                            onPressed: () => toggleCompletion(index),
                          ),
                          title: Text(
                            schedule.description,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              decoration: schedule.isCompleted ? TextDecoration.lineThrough : null,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Date: ${schedule.date.toLocal().toString().split(' ')[0]}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          trailing: IconButton(
                            icon: Icon(
                              Icons.delete,
                              color: Colors.red.shade300,
                            ),
                            onPressed: () => deleteSchedule(schedule),
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
        alignment: Alignment.topRight,
        child: FloatingActionButton(
          onPressed: () => showAddScheduleDialog(context),
          child: Icon(Icons.add),
        ),
      ),      
    );
  }
}