import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/learner.dart';

class LearnerState {
  final List<Learner> learners;
  final bool isLoading;
  final String? errorMsg;

  LearnerState({
    required this.learners,
    required this.isLoading,
    this.errorMsg,
  });

  LearnerState copyWith({
    List<Learner>? learners,
    bool? isLoading,
    String? errorMsg,
  }) {
    return LearnerState(
      learners: learners ?? this.learners,
      isLoading: isLoading ?? this.isLoading,
      errorMsg: errorMsg ?? this.errorMsg,
    );
  }
}

class LearnerManager extends StateNotifier<LearnerState> {
  LearnerManager() : super(LearnerState(learners: [], isLoading: false));

  Learner? _learner;
  int? _index;

  Future<void> loadStudents() async {
    state = state.copyWith(isLoading: true, errorMsg: null);
    try {
      final learners = await Learner.remoteGetList();
      state = state.copyWith(learners: learners, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMsg: e.toString(),
      );
    }
  }

  Future<void> addLearner(
    String givenName,
    String familyName,
    specialization,
    identity,
    int grade,
  ) async {
    try {
      state = state.copyWith(isLoading: true, errorMsg: null);
      final student = await Learner.remoteCreate(
          givenName, familyName, specialization, identity, grade);
      state = state.copyWith(
        learners: [...state.learners, student],
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMsg: e.toString(),
      );
    }
  }

  Future<void> updateLearner(
    int index,
    String givenName,
    String familyName,
    specialization,
    identity,
    int grade,
  ) async {
    state = state.copyWith(isLoading: true, errorMsg: null);
    try {
      final updatedStudent = await Learner.remoteUpdate(
        state.learners[index].id,
        givenName,
        familyName,
        specialization,
        identity,
        grade,
      );
      final updatedList = [...state.learners];
      updatedList[index] = updatedStudent;
      state = state.copyWith(learners: updatedList, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMsg: e.toString(),
      );
    }
  }

  void removeLearner(int index) {
    _learner = state.learners[index];
    _index = index;
    final updatedList = [...state.learners];
    updatedList.removeAt(index);
    state = state.copyWith(learners: updatedList);
  }

  void undoLastRemoval() {
    if (_learner != null && _index != null) {
      final updatedList = [...state.learners];
      updatedList.insert(_index!, _learner!);
      state = state.copyWith(learners: updatedList);
    }
  }

  Future<void> eraseFromFirebase() async {
    state = state.copyWith(isLoading: true, errorMsg: null);
    try {
      if (_learner != null) {
        await Learner.remoteDelete(_learner!.id);
        _learner = null;
        _index = null;
      }
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMsg: e.toString(),
      );
    }
  }
}

final learnersProvider =
    StateNotifierProvider<LearnerManager, LearnerState>((ref) {

  final notifier = LearnerManager();
  notifier.loadStudents();
  return notifier;
});
