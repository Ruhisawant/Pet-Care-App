import 'package:flutter/material.dart';
import 'package:pet_care_app/main.dart';
import 'package:table_calendar/table_calendar.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class PetTask {
  String title, category;
  DateTime scheduledDate;
  bool isCompleted;

  PetTask({
    required this.title,
    required this.category,
    required this.scheduledDate,
    this.isCompleted = false,
  });

  void toggleCompletion() => isCompleted = !isCompleted;
}

class _SchedulePageState extends State<SchedulePage> {
  List<PetTask> petTasks = [];
  late DateTime _focusedDate;
  late DateTime _selectedDate;
  final Map<DateTime, List<String>> _eventList = {
    DateTime(2025, 3, 11): ['Vet Appointment'],
    DateTime(2025, 3, 12): ['Grooming Session'],
    DateTime(2025, 3, 14): ['Pet Training'],
  };

  @override
  void initState() {
    super.initState();
    _focusedDate = DateTime.now();
    _selectedDate = _focusedDate;
  }

  void openTaskDialog({PetTask? task}) {
    final titleController = TextEditingController(text: task?.title ?? '');
    String selectedCategory = task?.category ?? 'Food';
    final dateController = TextEditingController(
        text: task != null ? "${task.scheduledDate.toLocal()}".split(' ')[0] : '');
    DateTime selectedDate = task?.scheduledDate ?? DateTime.now();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(task == null ? 'Add Task' : 'Edit Task'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: titleController, decoration: InputDecoration(labelText: "Task Title")),
              SizedBox(height: 10),
              DropdownButton<String>(
                value: selectedCategory,
                onChanged: (newValue) {
                  if (newValue != null) {
                    setDialogState(() => selectedCategory = newValue);
                  }
                },
                items: ['Food', 'Water'].map((type) => DropdownMenuItem(value: type, child: Text(type))).toList(),
              ),
              SizedBox(height: 10),
              TextField(
                controller: dateController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Date',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context, initialDate: selectedDate, firstDate: DateTime(2000), lastDate: DateTime(2100),
                      );
                      if (pickedDate != null) {
                        setDialogState(() {
                          selectedDate = pickedDate;
                          dateController.text = '${pickedDate.toLocal()}'.split(' ')[0];
                        });
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancel')),
            TextButton(
              onPressed: () {
                if (titleController.text.isEmpty) return;
                setState(() {
                  if (task == null) {
                    petTasks.add(PetTask(title: titleController.text, category: selectedCategory, scheduledDate: selectedDate));
                  } else {
                    task.title = titleController.text;
                    task.scheduledDate = selectedDate;
                    task.category = selectedCategory;
                  }
                });
                Navigator.pop(context);
              },
              child: Text(task == null ? 'Add' : 'Save'),
            ),
          ],
        ),
      ),
    );
  }

  void removeTask(PetTask task) => setState(() => petTasks.remove(task));

  void toggleTaskCompletion(PetTask task) => setState(() => task.toggleCompletion());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage())),
                  child: Text('Home'),
                ),
                FloatingActionButton.small(
                  onPressed: () => openTaskDialog(),
                  tooltip: 'Add Task',
                  child: Icon(Icons.add),
                ),
              ],
            ),
          ),
          Expanded(
            child: petTasks.isEmpty
                ? Center(child: Text("No tasks yet!", style: TextStyle(fontSize: 20)))
                : ListView.builder(
                    itemCount: petTasks.length,
                    itemBuilder: (context, index) => PetTaskTile(
                      task: petTasks[index],
                      onToggleCompletion: () => toggleTaskCompletion(petTasks[index]),
                      onDelete: () => removeTask(petTasks[index]),
                      onEdit: () => openTaskDialog(task: petTasks[index]),
                    ),
                  ),
          ),
          TableCalendar(
            focusedDay: _focusedDate,
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            calendarFormat: CalendarFormat.week,
            availableCalendarFormats: const {CalendarFormat.week: 'Week'},
            selectedDayPredicate: (day) => isSameDay(_selectedDate, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDate = selectedDay;
                _focusedDate = focusedDay;
              });
            },
            eventLoader: (day) => _eventList[day] ?? [],
          ),
        ],
      ),
    );
  }
}

class PetTaskTile extends StatelessWidget {
  final PetTask task;
  final VoidCallback onToggleCompletion, onDelete, onEdit;

  const PetTaskTile({required this.task, required this.onToggleCompletion, required this.onDelete, required this.onEdit, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: task.isCompleted ? Colors.green[200] : (task.category == 'Food' ? Colors.brown[200] : Colors.blue[200]),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: ListTile(
        leading: IconButton(
          icon: Icon(task.isCompleted ? Icons.check_circle : Icons.circle_outlined, color: task.isCompleted ? Colors.green : Colors.grey),
          onPressed: onToggleCompletion,
        ),
        title: Text(task.title, style: TextStyle(fontWeight: FontWeight.bold, decoration: task.isCompleted ? TextDecoration.lineThrough : null)),
        subtitle: Text('Date: ${task.scheduledDate.toLocal().toString().split(' ')[0]}', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [IconButton(icon: Icon(Icons.edit), onPressed: onEdit), IconButton(icon: Icon(Icons.delete), onPressed: onDelete)],
        ),
      ),
    );
  }
}
