import 'package:flutter/material.dart';

class CustomInput extends StatelessWidget {
  final String? hint;
  final InputBorder? inputBorder;
  final TextEditingController? controller; // Add a controller parameter

  const CustomInput({
    Key? key,
    this.hint,
    this.inputBorder,
    this.controller, // Initialize in constructor
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: controller, // Use the controller with TextField
        decoration: InputDecoration(
          hintText: hint,
          border: inputBorder,
        ),
      ),
    );
  }
}
