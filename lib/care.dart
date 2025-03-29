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
  Map<String, Map<String, List<String>>> symptomDetails = {
    'Persistent Coughing': {
      'Potential Illnesses': ['Feline Asthma', 'Bronchitis', 'Heartworm Disease'],
      'Possible Complications': ['Respiratory distress', 'Lung inflammation'],
    },
    'Wheezing': {
      'Potential Illnesses': ['Asthma, Allergic Reactions', 'Upper Respiratory Infections'],
      'Possible Complications': ['Breathing difficulties', 'Reduced oxygen intake'],
    },
    'Vomiting': {
      'Potential Illnesses': ['Gastritis', 'Intestinal Parasites', 'Kidney Disease'],
      'Possible Complications': ['Dehydration', 'electrolyte imbalance'],
    },
    'Diarrhea': {
      'Potential Illnesses': ['Viral Infections', 'Dietary Indiscretion', 'Inflammatory Bowel Disease'],
      'Possible Complications': ['Severe dehydration', 'nutrient loss'],
    },
    'Lethargy': {
      'Potential Illnesses': ['Feline Leukemia', 'Anemia', 'Depression'],
      'Possible Complications': ['Weakened immune system', 'progressive health decline'],
    },
    'Excessive Scratching': {
      'Potential Illnesses:': ['Allergic Dermatitis', 'Fleas', 'Mange'],
      'Possible Complications': ['Skin infections', 'hair loss'],
    },
    'Unusual Lumps or Bumps': {
      'Potential Illnesses': ['Cancer', 'Benign Tumors', 'Skin Infections'],
      'Possible Complications': ['Metastasis', 'spread of infection'],
    },
    'Seizures': {
      'Potential Illnesses': ['Epilepsy', 'Brain Tumors', 'Toxin Exposure'],
      'Possible Complications': ['Brain damage', 'physical injury during seizures'],
    },
    'Disorientation': {
      'Potential Illnesses': ['Vestibular Disease', 'Stroke', 'Cognitive Dysfunction'],
      'Possible Complications': ['Loss of balance', 'reduced quality of life'],
    },
    'Dificutly Moving': {
      'Potential Illnesses': ['Arthritis', 'Spinal Injuries', 'Tumors'],
      'Possible Complications': ['Reduced mobility', 'pain'],
    },
    'Tremors': {
      'Potential Illnesses': ['Neurological Disorders', 'Nutritional Deficiencies'],
      'Possible Complications': ['Muscle weakness', 'coordination problems'],
    },
    'Overgrown Teeth': {
      'Potential Illnesses': ['Dental Malocclusion', 'Nutritional Imbalances'],
      'Possible Complications': ['Difficulty eating', 'mouth pain'],
    },
    'Reduced Appetite': {
      'Potential Illnesses': ['Gastrointestinal Stasis', 'Dental Problems'],
      'Possible Complications': ['Rapid weight loss', 'organ failure'],
    },
    'Unusual Droppings': {
      'Potential Illnesses': ['Parasitic Infections', 'Dietary Issues'],
      'Possible Complications': ['Dehydration', 'malnutrition'],
    },
    'Nasal Discharge': {
      'Potential Illnesses': ['Pasteurella', 'Respiratory Infections'],
      'Possible Complications': ['Chronic respiratory disease'],
    },
  };

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

  void _showIllnessAlert(BuildContext context, String symptom) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Illness Guide: '),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...symptomDetails[symptom]!.entries.map((entry) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${entry.key}:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      ...entry.value.map((illness) => 
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text('• $illness'),
                        )
                      ),
                      SizedBox(height: 10),
                    ],
                  );
                }),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Top row with Home button and Add Schedule button
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
                  onPressed: () => createUpdateSchedule(),
                  tooltip: 'Add Schedule',
                  child: Icon(Icons.add),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          
          // Top half: Feeding schedule
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  schedules.isEmpty
                      ? Center(child: Text("No schedules yet!", style: TextStyle(fontSize: 20)))
                      : Expanded(
                          child: ListView.builder(
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
          ),

          Divider(),

          // Bottom half: Symptoms list
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Symptoms:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Expanded(
                    child: ListView.builder(
                      itemCount: symptomDetails.keys.length,
                      itemBuilder: (context, index) {
                        String symptom = symptomDetails.keys.elementAt(index);
                        return ListTile(
                          title: Text(symptom),
                          onTap: () => _showIllnessAlert(context, symptom),
                          trailing: Icon(Icons.medical_information_outlined),
                        );
                      },
                    ),
                  ),
                ],
              ),
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

  @override //if the user chooses food add if statement with text box. the tile should be printed like "Feed [pet name] [text] on [date]"
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
