import 'package:flutter/material.dart';
import '../models/learner.dart';
import '../models/specialization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/learners_provider.dart';

class LearnerForm extends ConsumerStatefulWidget {
  const LearnerForm({
    super.key,
    this.learnerIndex
  });

  final int? learnerIndex;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LearnerFormState();
}

class _LearnerFormState extends ConsumerState<LearnerForm> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  late Specialization _selectedSpecialization = Specialization.computerScience;
  late Identity _selectedIdentity = Identity.male;
  late int _score = 0;

  @override
  void initState() {
    super.initState();
    if (widget.learnerIndex != null) {
      final student = ref.read(learnersProvider).learners[widget.learnerIndex!];
      _firstNameController.text = student.givenName;
      _lastNameController.text = student.familyName;
      _selectedIdentity = student.identity;
      _selectedSpecialization = student.specialization;
      _score = student.score;
    }
  }

  void _saveLearner() async {
    if (widget.learnerIndex == null)  {
      await ref.read(learnersProvider.notifier).addLearner(
            _firstNameController.text.trim(),
            _lastNameController.text.trim(),
            _selectedSpecialization,
            _selectedIdentity,
            _score,
          );
    } else {
      await ref.read(learnersProvider.notifier).updateLearner(
            widget.learnerIndex!,
            _firstNameController.text.trim(),
            _lastNameController.text.trim(),
            _selectedSpecialization,
            _selectedIdentity,
            _score,
          );
    }

    if (!context.mounted) return;
    Navigator.of(context).pop(); 
  }

  @override
  Widget build(BuildContext context) {
    final students = ref.watch(learnersProvider);
    if (students.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.learnerIndex == null ? 'New Learner' : 'Edit Learner',
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
                  value: _selectedIdentity,
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
                  onChanged: (value) => setState(() => _selectedIdentity = value!),
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
                  child: Text(widget.learnerIndex == null ? 'Save' : 'Update'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
