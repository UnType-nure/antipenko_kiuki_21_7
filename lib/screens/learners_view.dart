import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/learners_provider.dart';
import '../widgets/learner_tile.dart';
import '../widgets/learner_form.dart';

class LearnersView extends ConsumerWidget {
  const LearnersView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final learners = ref.watch(learnersProvider);

    return Scaffold(
      body: learners.isEmpty
          ? const Center(child: Text('No learners available'))
          : ListView.builder(
              itemCount: learners.length,
              itemBuilder: (context, index) {
                final learner = learners[index];
                return LearnerTile(
                  learner: learner,
                  onEdit: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (_) => LearnerForm(
                        learner: learner,
                        onSave: (updatedLearner) {
                          ref
                              .read(learnersProvider.notifier)
                              .updateLearner(index, updatedLearner);
                        },
                      ),
                    );
                  },
                  onDelete: () {
                    final removedLearner = learner;
                    ref.read(learnersProvider.notifier).removeLearner(index);
                    final container = ProviderScope.containerOf(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          '${removedLearner.givenName} was removed.',
                        ),
                        action: SnackBarAction(
                          label: 'Undo',
                          onPressed: () {
                            container
                                .read(learnersProvider.notifier)
                                .undoLastRemoval();
                          },
                        ),
                      ),
                    );
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (_) => LearnerForm(
              onSave: (newLearner) {
                ref.read(learnersProvider.notifier).addLearner(newLearner);
              },
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
