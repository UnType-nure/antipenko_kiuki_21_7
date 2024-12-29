import 'specialization.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../constants.dart';

enum Identity { male, female }

class Learner {
  final String id;
  final String givenName;
  final String familyName;
  final Specialization specialization;
  final int score;
  final Identity identity;

  Learner({
    required this.id,
    required this.givenName,
    required this.familyName,
    required this.specialization,
    required this.score,
    required this.identity,
  });

  Learner.withId(
      {required this.id,
      required this.givenName,
      required this.familyName,
      required this.specialization,
      required this.identity,
      required this.score});

  Learner copyWith(givenName, familyName, specialization, identity, score) {
    return Learner.withId(
        id: id,
        givenName: givenName,
        familyName: familyName,
        specialization: specialization,
        identity: identity,
        score: score);
  }

  static Specialization parseSpecialization(String departmentString) {
    return Specialization.values.firstWhere(
      (d) => d.toString().split('.').last == departmentString,
      orElse: () => throw ArgumentError('Invalid specialization: $departmentString'),
    );
  }


  static String departmentToString(Specialization specialization) {
    return specialization.toString().split('.').last;
  }


  static Future<List<Learner>> remoteGetList() async {
    final url = Uri.https(baseUrl, "$studentsPath.json");

    final response = await http.get(
      url,
    );

    if (response.statusCode >= 400) {
      throw Exception("Неможливо отримати дані з мережі");
    }

    if (response.body == "null") {
      return [];
    }

    final Map<String, dynamic> data = json.decode(response.body);
    final List<Learner> loadedItems = [];
    for (final item in data.entries) {
      loadedItems.add(
        Learner(
          id: item.key,
          givenName: item.value['given_name']!,
          familyName: item.value['family_name']!,
          specialization: parseSpecialization(item.value['specialization']!),
          identity: Identity.values.firstWhere((v) => v.toString() == item.value['identity']!),
          score: item.value['score']!,
        ),
      );
    }
    return loadedItems;
  }

  static Future<Learner> remoteCreate(
    givenName,
    familyName,
    specialization,
    identity,
    score,
  ) async {

    final url = Uri.https(baseUrl, "$studentsPath.json");

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(
        {
          'given_name': givenName!,
          'family_name': familyName,
          'specialization': departmentToString(specialization),
          'identity': identity.toString(),
          'score': score,
        },
      ),
    );

    if (response.statusCode >= 400) {
      throw Exception("Couldn't create a student");
    }

    final Map<String, dynamic> resData = json.decode(response.body);

    return Learner(
        id: resData['name'],
        givenName: givenName,
        familyName: familyName,
        specialization: specialization,
        identity: identity,
        score: score);
  }

  static Future remoteDelete(studentId) async {
    final url = Uri.https(baseUrl, "$studentsPath/$studentId.json");

    final response = await http.delete(url);

    if (response.statusCode >= 400) {
      throw Exception("Couldn't delete a student");
    }
  }

  static Future<Learner> remoteUpdate(
    studentId,
    givenName,
    familyName,
    specialization,
    identity,
    score,
  ) async {
    final url = Uri.https(baseUrl, "$studentsPath/$studentId.json");

    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(
        {
          'given_name': givenName!,
          'family_name': familyName,
          'specialization': departmentToString(specialization),
          'identity': identity.toString(),
          'score': score,
        },
      ),
    );

    if (response.statusCode >= 400) {
      throw Exception("Couldn't update a student");
    }

    return Learner(
        id: studentId,
        givenName: givenName,
        familyName: familyName,
        specialization: specialization,
        identity: identity,
        score: score);
  }
  
}