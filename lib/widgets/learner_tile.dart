import 'package:flutter/material.dart';
import '../models/learner.dart';
import '../models/specialization.dart';

class LearnerTile extends StatelessWidget {
  final Learner learner;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const LearnerTile({
    super.key,
    required this.learner,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: ListTile(
        leading: Stack(
          alignment: Alignment.center,
          children: [
            Icon(
              Icons.star,
              size: 50,
              color: learner.identity == Identity.male
                  ? Colors.blue.shade100
                  : Colors.pink.shade100,
            ),
            Icon(
              specializationIcons[learner.specialization],
              size: 24,
              color: learner.identity == Identity.male
                  ? Colors.blue
                  : Colors.pink,
            ),
          ],
        ),
        title: Text('${learner.givenName} ${learner.familyName}'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(learner.specialization.name.toUpperCase()),
            const SizedBox(height: 4),
            Text(
              'Score: ${learner.score}',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade700,
              ),
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(icon: const Icon(Icons.edit_square), onPressed: onEdit),
            IconButton(icon: const Icon(Icons.delete_sweep), onPressed: onDelete),
          ],
        ),
      ),
    );
  }
}
