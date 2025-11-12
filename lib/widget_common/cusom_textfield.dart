import 'package:flutter/material.dart';
import 'package:ungdungbanmypham/consts/consts.dart';

Widget customTextField({
  required String title,
  required String hint,
  required TextEditingController controller,
  bool isPassword = false,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      title.text.color(redColor).fontFamily(semibold).size(16).make(),
      5.heightBox,
      TextFormField(
        controller: controller,
        obscureText: isPassword,
        decoration: InputDecoration(
          hintStyle: TextStyle(fontFamily: semibold, color: textfieldGrey),
          hintText: hint,
          isDense: true,
          fillColor: lightGrey,
          filled: true,
          border: InputBorder.none,
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: redColor),
          ),
        ),
      ),
      10.heightBox,
    ],
  );
}
