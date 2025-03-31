import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class SchedulesPage extends StatefulWidget {
  const SchedulesPage({super.key});

  @override
  State<SchedulesPage> createState() => _SchedulesPageState();
}

class PetSchedule {
  String title, category;
  DateTime scheduledDate;
  String frequency;
  bool isCompleted;

  PetSchedule({
    required this.title,
    required this.category,
    required this.scheduledDate,
    this.frequency = 'None',
    this.isCompleted = false,
  });

  void toggleCompletion() => isCompleted = !isCompleted;
}

class _SchedulesPageState extends State<SchedulesPage> {
  List<PetSchedule> petSchedules = [];
  late DateTime _focusedDate;
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _focusedDate = DateTime.now();
    _selectedDate = _focusedDate;
  }

  void openScheduleDialog({PetSchedule? schedule}) {
    final titleController = TextEditingController(text: schedule?.title ?? '');
    String selectedCategory = schedule?.category ?? 'Food';
    final dateController = TextEditingController(text: schedule != null ? "${schedule.scheduledDate.toLocal()}".split(' ')[0] : '');
    DateTime selectedDate = schedule?.scheduledDate ?? DateTime.now();
    String selectedFrequency = schedule?.frequency ?? 'None';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(schedule == null ? 'Add Schedule' : 'Edit Schedule'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: titleController, decoration: InputDecoration(labelText: 'Title')),
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
              SizedBox(height: 10),
              DropdownButton<String>(
                value: selectedFrequency,
                onChanged: (newValue) {
                  if (newValue != null) {
                    setDialogState(() => selectedFrequency = newValue);
                  }
                },
                items: ['None', 'Daily', 'Weekly', 'Monthly'].map((frequency) {
                  return DropdownMenuItem(value: frequency, child: Text(frequency));
                }).toList(),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancel')),
            TextButton(
              onPressed: () {
                if (titleController.text.isEmpty) return;
                setState(() {
                  if (schedule == null) {
                    if (selectedFrequency == 'None') {
                      petSchedules.add(PetSchedule(title: titleController.text, category: selectedCategory, scheduledDate: selectedDate, frequency: selectedFrequency));
                    } else {
                      addRepetitiveSchedules(titleController.text, selectedCategory, selectedDate, selectedFrequency);
                    }
                  } else {
                    schedule.title = titleController.text;
                    schedule.scheduledDate = selectedDate;
                    schedule.category = selectedCategory;
                    schedule.frequency = selectedFrequency;
                  }
                });
                Navigator.pop(context);
              },
              child: Text(schedule == null ? 'Add' : 'Save'),
            ),
          ],
        ),
      ),
    );
  }

  void addRepetitiveSchedules(String title, String category, DateTime startDate, String frequency) {
    int numberOfSchedules = 0;
    DateTime currentDate = startDate;

    if (frequency == 'Daily') {
      numberOfSchedules = 30;
    } else if (frequency == 'Weekly') {
      numberOfSchedules = 4;
    } else if (frequency == 'Monthly') {
      numberOfSchedules = 6;
    }

    for (int i = 0; i < numberOfSchedules; i++) {
      petSchedules.add(PetSchedule(
        title: title,
        category: category,
        scheduledDate: currentDate,
        frequency: frequency,
      ));

      if (frequency == 'Daily') {
        currentDate = currentDate.add(Duration(days: 1));
      } else if (frequency == 'Weekly') {
        currentDate = currentDate.add(Duration(days: 7));
      } else if (frequency == 'Monthly') {
        currentDate = DateTime(currentDate.year, currentDate.month + 1, currentDate.day);
      }
    }
  }

  void removeTask(PetSchedule schedule) => setState(() => petSchedules.remove(schedule));

  void toggleTaskCompletion(PetSchedule schedule) => setState(() => schedule.toggleCompletion());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo[200],
        title: const Text('Schedules'),
      ),
      body: Stack(
        children: [
          Positioned(
            top: 16.0,
            right: 16.0,
            child: FloatingActionButton.small(
              onPressed: () => openScheduleDialog(),
              tooltip: 'Add Schedule',
              backgroundColor: Colors.indigo[300],
              child: Icon(Icons.add),
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                SizedBox(height: 45),
                Expanded(
                  child: petSchedules.isEmpty
                      ? Center(child: Text('No schedules yet!', style: TextStyle(fontSize: 20)))
                      : ListView.builder(
                          itemCount: petSchedules.length,
                          itemBuilder: (context, index) => PetScheduleTile(
                            schedule: petSchedules[index],
                            onToggleCompletion: () => toggleTaskCompletion(petSchedules[index]),
                            onDelete: () => removeTask(petSchedules[index]),
                            onEdit: () => openScheduleDialog(schedule: petSchedules[index]),
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
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PetScheduleTile extends StatelessWidget {
  final PetSchedule schedule;
  final VoidCallback onToggleCompletion, onDelete, onEdit;

  const PetScheduleTile({required this.schedule, required this.onToggleCompletion, required this.onDelete, required this.onEdit, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: schedule.isCompleted ? Colors.green[200] : (schedule.category == 'Food' ? Colors.brown[200] : Colors.blue[200]),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: ListTile(
        leading: IconButton(
          icon: Icon(schedule.isCompleted ? Icons.check_circle : Icons.circle_outlined, color: schedule.isCompleted ? Colors.green : Colors.grey),
          onPressed: onToggleCompletion,
        ),
        title: Text('Your pet needs to be given ${schedule.category} on ${schedule.scheduledDate.toLocal().toString().split(' ')[0]}',
          style: TextStyle(fontWeight: FontWeight.bold, decoration: schedule.isCompleted ? TextDecoration.lineThrough : null)),
        subtitle: Text('Frequency: ${schedule.frequency}', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [IconButton(icon: Icon(Icons.edit), onPressed: onEdit), IconButton(icon: Icon(Icons.delete), onPressed: onDelete)],
        ),
      ),
    );
  }
}