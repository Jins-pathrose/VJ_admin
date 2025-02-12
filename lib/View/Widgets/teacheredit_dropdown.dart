import 'package:flutter/material.dart';

class TeacherEditDropdown extends StatefulWidget {
  final String hint;
  final List<String> items;
  final String? selectedValue;
  Function(String?) onChanged;

   TeacherEditDropdown({super.key, required this.hint, required this.items,required this.selectedValue, required this.onChanged});

  @override
  State<TeacherEditDropdown> createState() => _TeacherEditDropdownState();
}

class _TeacherEditDropdownState extends State<TeacherEditDropdown> {
  @override
  Widget build(BuildContext context) {
    return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: DropdownButtonFormField<String>(
      value: widget.selectedValue,
      decoration: InputDecoration(
        labelText: widget.hint,
        prefixIcon: const Icon(Icons.class_, color: Colors.black),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.amber, width: 2),
        ),
        filled: true,
        fillColor: Colors.grey[50],
      ),
      isExpanded: true, // Prevents overflow by expanding to full width
      items: widget.items.map((String item) {
        return DropdownMenuItem<String>(
          value: item,
          child: FittedBox(
            fit: BoxFit.scaleDown, // Scales down long text instead of overflowing
            child: Text(
              item,
              overflow: TextOverflow.ellipsis, // Shows "..." for very long text
            ),
          ),
        );
      }).toList(),
      onChanged: widget.onChanged,
    ),
  );
  }
}

class TeacherEditTextBox extends StatefulWidget {
 final TextEditingController controller;
 final String label; 
 final IconData icon;
  const TeacherEditTextBox({super.key, required this.controller, required this.icon, required this.label});

  @override
  State<TeacherEditTextBox> createState() => _TeacherEditTextBoxState();
}

class _TeacherEditTextBoxState extends State<TeacherEditTextBox> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: widget.controller,
        decoration: InputDecoration(
          labelText:widget.label,
          prefixIcon: Icon(widget.icon, color: Colors.black),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.amber, width: 2),
          ),
          filled: true,
          fillColor: Colors.grey[50],
        ),
      ),
    );
  }
  }
