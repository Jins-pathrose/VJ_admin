import 'package:flutter/material.dart';

class DropDown extends StatefulWidget {
  final String hint;
  final List<String> items;
  final String? selectedValue;
  final Function(String?) onChanged;

  const DropDown({
    super.key,
    required this.hint,
    required this.items,
    required this.selectedValue,
    required this.onChanged,
  });

  @override
  State<DropDown> createState() => _DropDownState();
}

class _DropDownState extends State<DropDown> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        value: widget.selectedValue,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.class_, color: Colors.black),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          hintText: widget.hint,
        ),
        items: widget.items.map((String item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(item),
          );
        }).toList(),
        onChanged: widget.onChanged,
      ),
    );
  }
}

class BulildTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData icon;
  const BulildTextField({super.key,required this.controller,required this.hintText,required this.icon});

  @override
  State<BulildTextField> createState() => _BulildTextFieldState();
}

class _BulildTextFieldState extends State<BulildTextField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: widget.controller,
        decoration: InputDecoration(
          prefixIcon: Icon(widget.icon, color: Colors.black),
          hintText: widget.hintText,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }
}