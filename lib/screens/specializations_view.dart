import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/learners_provider.dart';
import '../models/specialization.dart';

class SpecializationsView extends ConsumerWidget {
  const SpecializationsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final specState = ref.watch(learnersProvider);

    if (specState.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
      ),
      itemCount: Specialization.values.length,
      itemBuilder: (context, index) {
        final specialization = Specialization.values[index];
        final count = specState.learners
            .where((learner) => learner.specialization == specialization)
            .length;

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blueGrey.shade200, Colors.blueGrey.shade400],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(specializationIcons[specialization],
                  size: 40, color: Colors.white),
              const SizedBox(height: 8),
              Text(
                specialization.name.toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '$count learners',
                style: const TextStyle(color: Colors.white70, fontSize: 14),
              ),
            ],
          ),
        );
      },
    );
  }
}
