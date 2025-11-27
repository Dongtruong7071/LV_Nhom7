import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ungdungbanmypham/core/consts/lists.dart';
import 'package:ungdungbanmypham/presentation/controllers/auth_controller.dart';
import 'package:ungdungbanmypham/presentation/pages/auth_screen/signup_screen.dart';
import 'package:ungdungbanmypham/presentation/pages/home_screen/home.dart';
import 'package:ungdungbanmypham/presentation/widgets/common/applogo_wdget.dart';
import 'package:ungdungbanmypham/presentation/widgets/common/bg_widget.dart';
import 'package:ungdungbanmypham/presentation/widgets/common/our_button.dart';
import 'package:ungdungbanmypham/core/consts/consts.dart';
import 'package:ungdungbanmypham/presentation/widgets/common/cusom_textfield.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  changeScreen() {
    Future.delayed(const Duration(seconds: 3), () {
      Get.to(() => const LoginScreen());
    });
  }

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final AuthController _authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return bgWidget(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Center(
          child: Column(
            children: [
              (context.screenHeight * 0.1).heightBox,
              applogoWidget(),
              10.heightBox,
              "Đăng nhập vào $appname".text
                  .fontFamily(bold)
                  .white
                  .size(18)
                  .make(),
              15.heightBox,
              Column(
                    children: [
                      customTextField(
                        title: email,
                        hint: emailHint,
                        controller: emailController,
                      ),
                      customTextField(
                        title: password,
                        hint: passwordHint,
                        controller: passwordController,
                        isPassword: true,
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {},
                          child: forgetPassword.text.make(),
                        ),
                      ),
                      5.heightBox,
                      Obx(
                        () => _authController.isLoading.value
                            ? const CircularProgressIndicator()
                            : ourButton(
                                () async {
                                  var user = await _authController.signIn(
                                    emailController.text.trim(),
                                    passwordController.text.trim(),
                                  );

                                  if (user != null) {
                                    Get.snackbar(
                                      "Đăng nhập thành công",
                                      "Chào mừng trở lại ${user.displayName ?? user.email}",
                                      backgroundColor: Colors.green,
                                      colorText: whiteColor,
                                    );
                                    Future.delayed(
                                      const Duration(seconds: 1),
                                      () {
                                        Get.offAll(() => const Home());
                                      },
                                    );
                                  } else {
                                    Get.snackbar(
                                      "Đăng nhập thất bại",
                                      "Vui lòng kiểm tra lại email và mật khẩu",
                                      backgroundColor: Colors.red,
                                      colorText: whiteColor,
                                    );
                                  }
                                },
                                redColor,
                                whiteColor,
                                login,
                              ).box.width(context.screenWidth - 50).make(),
                      ),
                      5.heightBox,
                      createNewAccount.text.color(fontGrey).make(),
                      5.heightBox,
                      ourButton(
                        () {
                          Get.to(() => const SignupScreen());
                        },
                        lightGolden,
                        redColor,
                        signup,
                      ).box.width(context.screenWidth - 50).make(),
                      10.heightBox,
                      loginWith.text.color(fontGrey).make(),
                      5.heightBox,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          3,
                          (index) => Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CircleAvatar(
                              backgroundColor: lightGrey,
                              radius: 25,
                              child: Image.asset(
                                socialIconList[index],
                                width: 30,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ).box.white.rounded
                  .padding(const EdgeInsets.all(16))
                  .width(context.screenWidth - 70)
                  .shadowSm
                  .make(),
            ],
          ),
        ),
      ),
    );
  }
}
