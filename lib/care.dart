import 'package:flutter/material.dart';
import 'package:pet_care_app/main.dart';

class Care extends StatefulWidget {
  const Care({super.key});

  @override
  State<Care> createState() => _CareState();
}

class Schedule {
  String name, type;
  DateTime date;
  bool isCompleted;

  Schedule({
    required this.name,
    required this.type,
    required this.date,
    this.isCompleted = false,
  });

  void toggleCompletion() => isCompleted = !isCompleted;
}

class _CareState extends State<Care> {
  List<Schedule> schedules = [];

  void createUpdateSchedule({Schedule? schedule}) {
    final nameController = TextEditingController(text: schedule?.name ?? '');
    String selectedType = schedule?.type ?? 'Food';
    final dateController = TextEditingController(text: schedule != null ? "${schedule.date.toLocal()}".split(' ')[0] : '');
    DateTime selectedDate = schedule?.date ?? DateTime.now();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(schedule == null ? "Add Schedule" : "Edit Schedule"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(controller: nameController, decoration: InputDecoration(labelText: "Title")),
                  ),
                  SizedBox(width: 10),
                  DropdownButton<String>(
                    value: selectedType,
                    onChanged: (newValue) {
                      if (newValue != null) {
                        setDialogState(() => selectedType = newValue);
                      }
                    },
                    items: ['Food', 'Water'].map((type) => DropdownMenuItem(value: type, child: Text(type))).toList(),
                  ),
                ],
              ),
              TextField(
                controller: dateController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: "Date",
                  suffixIcon: IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context, initialDate: selectedDate, firstDate: DateTime(2000), lastDate: DateTime(2100),
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
            TextButton(onPressed: () => Navigator.pop(context), child: Text("Cancel")),
            TextButton(
              onPressed: () {
                if (nameController.text.isEmpty) return;
                setState(() {
                  if (schedule == null) {
                    schedules.add(Schedule(name: nameController.text, type: selectedType, date: selectedDate));
                  } else {
                    schedule.name = nameController.text;
                    schedule.date = selectedDate;
                    schedule.type = selectedType;
                  }
                });
                nameController.dispose();
                dateController.dispose();
                Navigator.pop(context);
              },
              child: Text(schedule == null ? "Add" : "Save"),
            ),
          ],
        ),
      ),
    );
  }

  void deleteSchedule(Schedule schedule) => setState(() => schedules.remove(schedule));

  void toggleCompletion(Schedule schedule) => setState(() => schedule.toggleCompletion());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ElevatedButton(
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage())),
                  child: Text('Home'),
                ),
                SizedBox(height: 20),
                Expanded(
                  child: schedules.isEmpty
                      ? Center(child: Text("No schedules yet!", style: TextStyle(fontSize: 20)))
                      : ListView.builder(
                          itemCount: schedules.length,
                          itemBuilder: (context, index) => ScheduleTile(
                            schedule: schedules[index],
                            onToggleCompletion: () => toggleCompletion(schedules[index]),
                            onDelete: () => deleteSchedule(schedules[index]),
                            onEdit: () => createUpdateSchedule(schedule: schedules[index]),
                          ),
                        ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 20,
            right: 20,
            child: FloatingActionButton(
              onPressed: () => createUpdateSchedule(),
              tooltip: 'Add Schedule',
              child: Icon(Icons.add),
            ),
          ),
        ],
      ),
    );
  }
}

class ScheduleTile extends StatelessWidget {
  final Schedule schedule;
  final VoidCallback onToggleCompletion, onDelete, onEdit;

  const ScheduleTile({required this.schedule, required this.onToggleCompletion, required this.onDelete, required this.onEdit, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: schedule.isCompleted
          ? Colors.green[200]
          : schedule.type == 'Food' ? Colors.brown[200] : Colors.blue[200],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: ListTile(
        leading: IconButton(
          icon: Icon(schedule.isCompleted ? Icons.check_circle : Icons.circle_outlined, color: schedule.isCompleted ? Colors.green : Colors.grey),
          onPressed: onToggleCompletion,
        ),
        title: Text(
          schedule.name,
          style: TextStyle(fontWeight: FontWeight.bold, decoration: schedule.isCompleted ? TextDecoration.lineThrough : null),
        ),
        subtitle: Text('Date: ${schedule.date.toLocal().toString().split(' ')[0]}',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(icon: Icon(Icons.edit, color: Colors.purple.shade300), onPressed: onEdit),
            IconButton(icon: Icon(Icons.delete, color: Colors.red.shade300), onPressed: onDelete),
          ],
        ),
      ),
    );
  }
}
