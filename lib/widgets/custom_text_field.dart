import 'package:flutter/material.dart';

Widget customeTextField(
    {required String hintText,
    required IconData icon,
    required TextInputType inputType,
    required int maxLines,
    required TextEditingController controller}) {
  return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextFormField(
        style: TextStyle(color: Colors.white),
        cursorColor: Colors.white,
        controller: controller,
        keyboardType: inputType,
        maxLines: maxLines,
        decoration: InputDecoration(
            hintStyle: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.w100),
            prefixIcon: Container(
              margin: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Color(0xFF8C8AFF),
              ),
              child: Icon(
                icon,
                size: 20,
                color: Colors.white,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: Colors.transparent,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: Colors.transparent,
              ),
            ),
            hintText: hintText,
            alignLabelWithHint: true,
            border: InputBorder.none,
            fillColor: Color(0xFF8C8AFF),
            filled: true),
      ));
}
