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

    if (learners.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (learners.errorMsg != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              learners.errorMsg!,
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    });

    return Scaffold(
      body: learners.learners.isEmpty
          ? const Center(child: Text('No learners available'))
          : ListView.builder(
              itemCount: learners.learners.length,
              itemBuilder: (context, index) {
                final learner = learners.learners[index];
                return LearnerTile(
                  learner: learner,
                  onEdit: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (_) => LearnerForm(learnerIndex: index,),
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
                    ).closed.then((value) {
                      if (value != SnackBarClosedReason.action) {
                        ref.read(learnersProvider.notifier).eraseFromFirebase();
                      }
                    });
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (_) => const LearnerForm(),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
