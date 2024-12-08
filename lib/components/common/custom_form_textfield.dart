import 'package:flutter/material.dart';

class CustomFormTextfield extends StatefulWidget {
  final TextEditingController? controller;
  final String hintText;
  final bool obscureText;
  final bool readOnly;
  final String? Function(String?)? validator;
  final String? initValue;

  const CustomFormTextfield(
      {super.key,
      this.controller,
      required this.hintText,
      required this.obscureText,
      required this.validator,
      this.readOnly = false, 
      this.initValue});

  @override
  State<CustomFormTextfield> createState() => _CustomFormTextfieldState();
}

class _CustomFormTextfieldState extends State<CustomFormTextfield> {
  String? _errorMessage;

  void _validateInput(String? value) {
    if (widget.validator != null) {
      setState(() {
        _errorMessage = widget.validator!(value);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: widget.controller,
          readOnly: widget.readOnly,
          initialValue: widget.initValue,
          decoration: InputDecoration(
              enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white)),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade400)),
              fillColor: Colors.grey.shade200,
              filled: true,
              hintText: widget.hintText,
              hintStyle: TextStyle(color: Colors.grey[500]),
              errorText: _errorMessage

          ),
          obscureText: widget.obscureText,
          validator: widget.validator,
          onChanged: _validateInput,
          onFieldSubmitted: _validateInput,
          
        ),
        
      ],
    );
  }
}
