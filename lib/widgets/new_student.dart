import 'package:flutter/material.dart';
import '../models/student.dart';

class NewStudent extends StatefulWidget {
  final Student? student;
  final Function(Student) onSave;

  const NewStudent({Key? key, this.student, required this.onSave}) : super(key: key);

  @override
  _NewStudentState createState() => _NewStudentState();
}

class _NewStudentState extends State<NewStudent> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  Department? _selectedDepartment;
  Gender? _selectedGender;
  int _grade = 0;

  @override
  void initState() {
    super.initState();
    if (widget.student != null) {
      _firstNameController.text = widget.student!.firstName;
      _lastNameController.text = widget.student!.lastName;
      _selectedDepartment = widget.student!.department;
      _selectedGender = widget.student!.gender;
      _grade = widget.student!.grade;
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  void _saveStudent() {
    if (_firstNameController.text.isEmpty ||
        _lastNameController.text.isEmpty ||
        _selectedDepartment == null ||
        _selectedGender == null) {
      return;
    }

    final newStudent = Student(
      firstName: _firstNameController.text,
      lastName: _lastNameController.text,
      department: _selectedDepartment!,
      grade: _grade,
      gender: _selectedGender!,
    );

    widget.onSave(newStudent);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(20),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Add/Edit Student',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                  ),
                ),
                const SizedBox(height: 20),
                _buildTextField(
                  controller: _firstNameController,
                  label: 'First Name',
                  icon: Icons.person_outline,
                ),
                const SizedBox(height: 10),
                _buildTextField(
                  controller: _lastNameController,
                  label: 'Last Name',
                  icon: Icons.person_outline,
                ),
                const SizedBox(height: 20),
                _buildDropdown<Department>(
                  value: _selectedDepartment,
                  items: Department.values,
                  hint: 'Select Department',
                  icon: Icons.work_outline,
                  onChanged: (value) => setState(() => _selectedDepartment = value),
                ),
                const SizedBox(height: 20),
                _buildDropdown<Gender>(
                  value: _selectedGender,
                  items: Gender.values,
                  hint: 'Select Gender',
                  icon: Icons.wc_outlined,
                  onChanged: (value) => setState(() => _selectedGender = value),
                ),
                const SizedBox(height: 20),
                Text(
                  'Grade: $_grade',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Slider(
                  value: _grade.toDouble(),
                  min: 0,
                  max: 100,
                  divisions: 100,
                  activeColor: Colors.teal,
                  label: '$_grade',
                  onChanged: (value) {
                    setState(() {
                      _grade = value.toInt();
                    });
                  },
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildActionButton(
                      label: 'Cancel',
                      color: Colors.redAccent,
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    _buildActionButton(
                      label: 'Save',
                      color: Colors.teal,
                      onPressed: _saveStudent,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Widget _buildDropdown<T>({
    required T? value,
    required List<T> items,
    required String hint,
    required IconData icon,
    required ValueChanged<T?> onChanged,
  }) {
    return InputDecorator(
      decoration: InputDecoration(
        labelText: hint,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          isExpanded: true,
          items: items.map((item) {
            return DropdownMenuItem(
              value: item,
              child: Text(item.toString().split('.').last.toUpperCase()),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
      ),
      onPressed: onPressed,
      child: Text(label),
    );
  }
}
