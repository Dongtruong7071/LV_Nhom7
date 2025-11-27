import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ungdungbanmypham/core/consts/images.dart';
import 'package:ungdungbanmypham/core/consts/strings.dart';
import 'package:ungdungbanmypham/core/consts/styles.dart';
import 'package:ungdungbanmypham/core/consts/colors.dart';
import 'package:ungdungbanmypham/presentation/controllers/category_controller.dart';
import 'package:ungdungbanmypham/presentation/controllers/home_controller.dart';
import 'package:ungdungbanmypham/presentation/controllers/product_controller.dart';
import 'package:ungdungbanmypham/presentation/pages/home_screen/home_screen.dart';
import 'package:ungdungbanmypham/presentation/pages/category_screen/category_screen.dart';
import 'package:ungdungbanmypham/presentation/pages/cart_screen/cart_screen.dart';
import 'package:ungdungbanmypham/presentation/pages/profile_screen/profile_screen.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(HomeController());

    Get.put(ProductController());
    Get.put(CategoryController());

    var navbarItem = [
      BottomNavigationBarItem(
        icon: Image.asset(icHome, width: 26),
        label: home,
      ),
      BottomNavigationBarItem(
        icon: Image.asset(icCategories, width: 26),
        label: categories,
      ),
      BottomNavigationBarItem(
        icon: Image.asset(icCart, width: 26),
        label: cart,
      ),
      BottomNavigationBarItem(
        icon: Image.asset(icProfile, width: 26),
        label: account,
      ),
    ];

    var navBody = [
      const HomeScreen(),
      const CategoryScreen(),
      const CartScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      body: Column(
        children: [
          Obx(
            () => Expanded(
              child: navBody.elementAt(controller.currentIndex.value),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          currentIndex: controller.currentIndex.value,
          selectedItemColor: redColor,
          selectedLabelStyle: const TextStyle(fontFamily: semibold),
          type: BottomNavigationBarType.fixed,
          backgroundColor: whiteColor,
          items: navbarItem,
          onTap: (index) {
            controller.currentIndex.value = index;
          },
        ),
      ),
    );
  }
}
