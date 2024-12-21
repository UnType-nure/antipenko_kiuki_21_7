import 'package:flutter/material.dart';
import '../models/learner.dart';
import '../models/specialization.dart';

class LearnerForm extends StatefulWidget {
  final Learner? learner;
  final Function(Learner) onSave;

  const LearnerForm({super.key, this.learner, required this.onSave});

  @override
  State<LearnerForm> createState() => _LearnerFormState();
}

class _LearnerFormState extends State<LearnerForm> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  late Specialization _selectedSpecialization;
  late Identity _selectedGender;
  late int _score;

  @override
  void initState() {
    super.initState();
    if (widget.learner != null) {
      _firstNameController.text = widget.learner!.givenName;
      _lastNameController.text = widget.learner!.familyName;
      _selectedSpecialization = widget.learner!.specialization;
      _selectedGender = widget.learner!.identity;
      _score = widget.learner!.score;
    } else {
      _selectedSpecialization = Specialization.computerScience;
      _selectedGender = Identity.male;
      _score = 0;
    }
  }

  void _saveLearner() {
    if (_firstNameController.text.trim().isEmpty ||
        _lastNameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    final newLearner = Learner(
      givenName: _firstNameController.text.trim(),
      familyName: _lastNameController.text.trim(),
      specialization: _selectedSpecialization,
      score: _score,
      identity: _selectedGender,
    );

    widget.onSave(newLearner);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.learner == null ? 'New Learner' : 'Edit Learner',
        ),
      ),
      body: Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _firstNameController,
                  decoration: const InputDecoration(
                    labelText: 'Given Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _lastNameController,
                  decoration: const InputDecoration(
                    labelText: 'Family Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<Specialization>(
                  value: _selectedSpecialization,
                  decoration: const InputDecoration(
                    labelText: 'Specialization',
                    border: OutlineInputBorder(),
                  ),
                  items: Specialization.values.map((specialization) {
                    return DropdownMenuItem(
                      value: specialization,
                      child: Row(
                        children: [
                          Icon(specializationIcons[specialization], size: 20),
                          const SizedBox(width: 10),
                          Text(specialization.name.toUpperCase()),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (value) =>
                      setState(() => _selectedSpecialization = value!),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<Identity>(
                  value: _selectedGender,
                  decoration: const InputDecoration(
                    labelText: 'Gender',
                    border: OutlineInputBorder(),
                  ),
                  items: Identity.values.map((gender) {
                    return DropdownMenuItem(
                      value: gender,
                      child: Text(gender.toString().split('.').last),
                    );
                  }).toList(),
                  onChanged: (value) => setState(() => _selectedGender = value!),
                ),
                const SizedBox(height: 16),
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Score',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    final parsedScore = int.tryParse(value);
                    if (parsedScore != null) _score = parsedScore;
                  },
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _saveLearner,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                  child: Text(widget.learner == null ? 'Save' : 'Update'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
