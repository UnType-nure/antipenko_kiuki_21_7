import 'package:flutter/material.dart';

enum Specialization { economics, legalStudies, computerScience, healthcare }

const Map<Specialization, IconData> specializationIcons = {
  Specialization.economics: Icons.money_off,
  Specialization.legalStudies: Icons.scale,
  Specialization.computerScience: Icons.laptop,
  Specialization.healthcare: Icons.healing,
};
