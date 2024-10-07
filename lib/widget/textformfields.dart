import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final String hintText;
  final TextEditingController? controller;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onSaved;
  final TextInputType keyboardType;
  final bool obscureText;
  final ValueChanged<String>? onChanged;

  const CustomTextFormField({
    Key? key,
    this.onChanged,
    required this.hintText,
    this.controller,
    this.validator,
    this.onSaved,
    this.keyboardType = TextInputType.number,
    this.obscureText = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      child: TextFormField(
        style: TextStyle(color: Colors.white),
        onChanged: onChanged,
        controller: controller,
        validator: validator,
        onSaved: onSaved != null ? (value) => onSaved!(value!) : null,
        keyboardType: keyboardType,
        obscureText: obscureText,
        decoration: InputDecoration(
          hintText: hintText,
          border: InputBorder.none,
          hintStyle: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
