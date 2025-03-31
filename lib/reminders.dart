import 'package:flutter/material.dart';

class RemindersPage extends StatefulWidget {
  const RemindersPage({super.key});

  @override
  State<RemindersPage> createState() => _RemindersPageState();
}

class Plan {
  String name, priority, description;
  DateTime date;
  bool isCompleted;

  Plan({
    required this.name,
    required this.date,
    required this.priority,
    required this.description,
    this.isCompleted = false,
  });

  void toggleCompletion() => isCompleted = !isCompleted;

  static int getPriorityValue(String priority) => 
    {'High': 3, 'Medium': 2, 'Low': 1}[priority] ?? 0;

  static Color getPriorityColor(String priority) => 
    {'High': Colors.red.shade300, 'Medium': Colors.orange.shade300, 'Low': Colors.blue.shade300}[priority] ?? Colors.grey;
}

class _RemindersPageState extends State<RemindersPage> {
  List<Plan> plans = [];

  void createUpdatePlan({Plan? plan}) {
    final nameController = TextEditingController(text: plan?.name ?? '');
    final descriptionController = TextEditingController(text: plan?.description ?? '');
    final dateController = TextEditingController(text: plan != null ? "${plan.date.toLocal()}".split(' ')[0] : '');
    String selectedPriority = plan?.priority ?? 'Medium';
    DateTime selectedDate = plan?.date ?? DateTime.now();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(plan == null ? "Add Reminder" : "Edit Reminder"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameController, decoration: InputDecoration(labelText: "Title")),
              TextField(controller: descriptionController, decoration: InputDecoration(labelText: "Description")),
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
              DropdownButton<String>(
                value: selectedPriority,
                onChanged: (newValue) => setDialogState(() => selectedPriority = newValue!),
                items: ['High', 'Medium', 'Low'].map((priority) => DropdownMenuItem(value: priority, child: Text(priority))).toList(),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: Text("Cancel")),
            TextButton(
              onPressed: () {
                if (nameController.text.isEmpty) return;
                setState(() {
                  if (plan == null) {
                    plans.add(Plan(name: nameController.text, date: selectedDate, priority: selectedPriority, description: descriptionController.text));
                  } else {
                    plan.name = nameController.text;
                    plan.description = descriptionController.text;
                    plan.date = selectedDate;
                    plan.priority = selectedPriority;
                  }
                  plans.sort((a, b) => Plan.getPriorityValue(b.priority).compareTo(Plan.getPriorityValue(a.priority)));
                });
                Navigator.pop(context);
              },
              child: Text(plan == null ? "Add" : "Save"),
            ),
          ],
        ),
      ),
    );
  }

  void deletePlan(Plan plan) => setState(() => plans.remove(plan));

  void toggleCompletion(Plan plan) => setState(() => plan.toggleCompletion());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple[100],
        title: const Text('Reminders'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: plans.isEmpty
                  ? Center(child: Text('No reminders yet!', style: TextStyle(fontSize: 20)))
                  : ListView.builder(
                      itemCount: plans.length,
                      itemBuilder: (context, index) => PlanTile(
                        plan: plans[index],
                        onToggleCompletion: () => toggleCompletion(plans[index]),
                        onDelete: () => deletePlan(plans[index]),
                        onEdit: () => createUpdatePlan(plan: plans[index]),
                      ),
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => createUpdatePlan(),
        tooltip: 'Add Plan',
        backgroundColor: Colors.purple[200],
        child: Icon(Icons.add),
      ),
    );
  }
}

class PlanTile extends StatelessWidget {
  final Plan plan;
  final VoidCallback onToggleCompletion, onDelete, onEdit;

  const PlanTile({required this.plan, required this.onToggleCompletion, required this.onDelete, required this.onEdit, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: plan.isCompleted ? Colors.green[200] : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: ListTile(
        leading: IconButton(
          icon: Icon(plan.isCompleted ? Icons.check_circle : Icons.circle_outlined, color: plan.isCompleted ? Colors.green : Colors.grey),
          onPressed: onToggleCompletion,
        ),
        title: Text(
          plan.name,
          style: TextStyle(fontWeight: FontWeight.bold, decoration: plan.isCompleted ? TextDecoration.lineThrough : null),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text('Date: ${plan.date.toLocal().toString().split(' ')[0]}  |', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                SizedBox(width: 9),
                Text('Priority: ${plan.priority}', style: TextStyle(fontSize: 12, color: Plan.getPriorityColor(plan.priority), fontWeight: FontWeight.bold)),
              ],
            ),
            SizedBox(height: 4),
            Text(plan.description),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(icon: Icon(Icons.edit, color: Colors.blue.shade300), onPressed: onEdit),
            IconButton(icon: Icon(Icons.delete, color: Colors.red.shade300), onPressed: onDelete),
          ],
        ),
      ),
    );
  }
}