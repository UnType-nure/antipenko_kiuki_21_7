import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/learner.dart';

class LearnerManager extends StateNotifier<List<Learner>> {
  LearnerManager() : super([]);

  Learner? _lastDeletedLearner;
  int? _lastDeletedIndex;

  void addLearner(Learner learner) {
    state = [...state, learner];
  }

  void updateLearner(int index, Learner updatedLearner) {
    final updatedList = [...state];
    updatedList[index] = updatedLearner;
    state = updatedList;
  }

  void removeLearner(int index) {
    _lastDeletedLearner = state[index];
    _lastDeletedIndex = index;
    state = [...state.sublist(0, index), ...state.sublist(index + 1)];
  }

  void undoLastRemoval() {
    if (_lastDeletedLearner != null && _lastDeletedIndex != null) {
      state = [
        ...state.sublist(0, _lastDeletedIndex!),
        _lastDeletedLearner!,
        ...state.sublist(_lastDeletedIndex!),
      ];
      _lastDeletedLearner = null;
      _lastDeletedIndex = null;
    }
  }
}

final learnersProvider =
    StateNotifierProvider<LearnerManager, List<Learner>>((ref) {
  return LearnerManager();
});
