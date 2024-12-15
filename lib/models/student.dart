import 'package:flutter/material.dart';

enum Department { finance, law, it, medical }
enum Gender { male, female }

class Student {
  final String firstName;
  final String lastName;
  final Department department;
  final int grade;
  final Gender gender;

  Student({
    required this.firstName,
    required this.lastName,
    required this.department,
    required this.grade,
    required this.gender,
  });
}

const Map<Department, IconData> departmentIcons = {
  Department.finance: Icons.account_balance_wallet_outlined,
  Department.law: Icons.gavel_outlined,
  Department.it: Icons.computer_outlined,
  Department.medical: Icons.local_hospital_outlined,
};
