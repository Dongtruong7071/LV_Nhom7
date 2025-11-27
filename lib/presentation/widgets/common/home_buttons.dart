import 'package:flutter/material.dart';
import 'package:ungdungbanmypham/core/consts/consts.dart';

Widget homeButtons() {
  return Expanded(child: 
  Column(
    children: [
      Image.asset(
        icTodaysDeal,
        width: 26,
      ),
      5.heightBox,
      todayDeal.text.fontFamily(semibold).color(darkFontGrey).make(),
    ],
  ),
  ).box.rounded.white.make();
  
}