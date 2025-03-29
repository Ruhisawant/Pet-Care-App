import 'package:flutter/material.dart';

class IllnessPage extends StatefulWidget {
  const IllnessPage({super.key});

  @override
  State<IllnessPage> createState() => _IllnessPageState();
}

class _IllnessPageState extends State<IllnessPage> {
  static const Map<String, Map<String, List<String>>> symptomInfo = {
    'Persistent Coughing': {
      'Potential Illnesses': ['Feline Asthma', 'Bronchitis', 'Heartworm Disease'],
      'Possible Complications': ['Respiratory distress', 'Lung inflammation'],
    },
    'Wheezing': {
      'Potential Illnesses': ['Asthma', 'Allergic Reactions', 'Upper Respiratory Infections'],
      'Possible Complications': ['Breathing difficulties', 'Reduced oxygen intake'],
    },
    'Vomiting': {
      'Potential Illnesses': ['Gastritis', 'Intestinal Parasites', 'Kidney Disease'],
      'Possible Complications': ['Dehydration', 'Electrolyte imbalance'],
    },
    'Diarrhea': {
      'Potential Illnesses': ['Viral Infections', 'Dietary Indiscretion', 'Inflammatory Bowel Disease'],
      'Possible Complications': ['Severe dehydration', 'Nutrient loss'],
    },
    'Lethargy': {
      'Potential Illnesses': ['Feline Leukemia', 'Anemia', 'Depression'],
      'Possible Complications': ['Weakened immune system', 'Progressive health decline'],
    },
    'Excessive Scratching': {
      'Potential Illnesses': ['Allergic Dermatitis', 'Fleas', 'Mange'],
      'Possible Complications': ['Skin infections', 'Hair loss'],
    },
    'Unusual Lumps or Bumps': {
      'Potential Illnesses': ['Cancer', 'Benign Tumors', 'Skin Infections'],
      'Possible Complications': ['Metastasis', 'Spread of infection'],
    },
    'Seizures': {
      'Potential Illnesses': ['Epilepsy', 'Brain Tumors', 'Toxin Exposure'],
      'Possible Complications': ['Brain damage', 'Physical injury during seizures'],
    },
    'Disorientation': {
      'Potential Illnesses': ['Vestibular Disease', 'Stroke', 'Cognitive Dysfunction'],
      'Possible Complications': ['Loss of balance', 'Reduced quality of life'],
    },
    'Difficulty Moving': {
      'Potential Illnesses': ['Arthritis', 'Spinal Injuries', 'Tumors'],
      'Possible Complications': ['Reduced mobility', 'Pain'],
    },
    'Tremors': {
      'Potential Illnesses': ['Neurological Disorders', 'Nutritional Deficiencies'],
      'Possible Complications': ['Muscle weakness', 'Coordination problems'],
    },
    'Overgrown Teeth': {
      'Potential Illnesses': ['Dental Malocclusion', 'Nutritional Imbalances'],
      'Possible Complications': ['Difficulty eating', 'Mouth pain'],
    },
    'Reduced Appetite': {
      'Potential Illnesses': ['Gastrointestinal Stasis', 'Dental Problems'],
      'Possible Complications': ['Rapid weight loss', 'Organ failure'],
    },
    'Unusual Droppings': {
      'Potential Illnesses': ['Parasitic Infections', 'Dietary Issues'],
      'Possible Complications': ['Dehydration', 'Malnutrition'],
    },
    'Nasal Discharge': {
      'Potential Illnesses': ['Pasteurella', 'Respiratory Infections'],
      'Possible Complications': ['Chronic respiratory disease'],
    },
  };

  void _showIllnessDetails(BuildContext context, String symptom) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Illness Guide'),
          content: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: symptomInfo[symptom]!.entries.map((entry) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${entry.key}:',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        ...entry.value.map((illness) => Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text('• $illness'),
                            )),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple[100],
        title: const Text('Illness'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Does your pet have any of these symptoms?:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: symptomInfo.keys.length,
                itemBuilder: (context, index) {
                  String symptom = symptomInfo.keys.elementAt(index);
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 6.0),
                    color: Colors.purple[200],
                    child: ListTile(
                      title: Text(symptom),
                      onTap: () => _showIllnessDetails(context, symptom),
                      trailing: const Icon(Icons.medical_information_outlined),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}