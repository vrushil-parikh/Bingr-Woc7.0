import 'package:bingr/themes/app_theme.dart';
import 'package:flutter/material.dart';

class CustomPasswordTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData iconData;
  final bool isPasswordField;

  const CustomPasswordTextField({
    Key? key,
    required this.controller,
    required this.hintText,
    required this.iconData,
    this.isPasswordField = true,
  }) : super(key: key);

  @override
  _CustomPasswordTextFieldState createState() => _CustomPasswordTextFieldState();
}

class _CustomPasswordTextFieldState extends State<CustomPasswordTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      child: TextField(
        obscureText: widget.isPasswordField ? _obscureText : false,
        controller: widget.controller,
        decoration: InputDecoration(
          prefixIconColor:Theme.of(context).primaryColor,
          focusColor: Theme.of(context).primaryColor,
          hintText: widget.hintText,
          hintStyle: TextStyle(color: Theme.of(context).primaryColor,),
          suffixIconColor: Theme.of(context).primaryColor,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2), // Highlight color when focused
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 1.5), // Default color
          ),
          prefixIcon: Icon(widget.iconData),
          suffixIcon: widget.isPasswordField
              ? IconButton(
            icon: Icon(_obscureText ? Icons.visibility_off : Icons.visibility),
            onPressed: () {
              setState(() {
                _obscureText = !_obscureText; // Toggle visibility
              });
            },
          )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2),
          ),
        ),
      ),
    );
  }
}
