import 'specialization.dart';

enum Identity { male, female }

class Learner {
  final String givenName;
  final String familyName;
  final Specialization specialization;
  final Identity identity;
  final int score;

  Learner({
    required this.givenName,
    required this.familyName,
    required this.specialization,
    required this.identity,
    required this.score,
  });
}
