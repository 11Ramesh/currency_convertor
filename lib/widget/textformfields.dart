import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final String hintText;
  final TextEditingController? controller;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onSaved;
  final TextInputType keyboardType;
  final bool obscureText;
  final void Function(String)? onChanged;
  final bool filled;

  final bool prefixIcon;

  final double width;

  const CustomTextFormField({
    Key? key,
    required this.prefixIcon,
    required this.filled,
    required this.width,
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
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Container(
        width: width,
        child: TextFormField(
          style: TextStyle(color: Colors.white),
          onChanged: onChanged,
          controller: controller,
          validator: validator,
          onSaved: onSaved != null ? (value) => onSaved!(value!) : null,
          keyboardType: keyboardType,
          obscureText: obscureText,
          decoration: InputDecoration(
              contentPadding:
                  EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              filled: filled,
              fillColor: const Color.fromARGB(255, 82, 80, 80),
              hintText: hintText,
              border: InputBorder.none,
              hintStyle: TextStyle(color: Colors.white),
              prefixIcon: prefixIcon
                  ? Icon(
                      Icons.search,
                      color: Colors.white,
                    )
                  : null),
        ),
      ),
    );
  }
}
