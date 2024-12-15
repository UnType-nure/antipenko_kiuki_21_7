import 'package:flutter/material.dart';
import '../models/student.dart';

class StudentItem extends StatelessWidget {
  final Student student;

  const StudentItem({Key? key, required this.student}) : super(key: key);

  Color _getBackgroundColor(Gender gender) {
    return gender == Gender.male ? Colors.lightBlue.shade50 : Colors.pink.shade50;
  }

  Color _getTextColor(Gender gender) {
    return gender == Gender.male ? Colors.blue.shade700 : Colors.pink.shade700;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _getBackgroundColor(student.gender),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: _getTextColor(student.gender).withOpacity(0.3),
            blurRadius: 5,
            offset: const Offset(2, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: Colors.grey.shade300,
            child: Icon(
              departmentIcons[student.department],
              size: 30,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${student.firstName} ${student.lastName}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: _getTextColor(student.gender),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Department: ${student.department.name.toUpperCase()}',
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
          Text(
            student.grade.toString(),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
