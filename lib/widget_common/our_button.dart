import 'package:ungdungbanmypham/consts/consts.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';


Widget ourButton(OnPress, color, textColor,String? title) {
  return ElevatedButton(
    style: ElevatedButton.styleFrom(
      padding: const EdgeInsets.all(12),
      backgroundColor: color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
    ),
    onPressed: (){ 
      OnPress();
    },
    child: title!.text.color(textColor).fontFamily(bold).size(18).make(),
  );
}