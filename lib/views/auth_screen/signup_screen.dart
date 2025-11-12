import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ungdungbanmypham/consts/consts.dart';
import 'package:ungdungbanmypham/services/auth_service.dart';
import 'package:ungdungbanmypham/views/auth_screen/login_screen.dart';
import 'package:ungdungbanmypham/widget_common/applogo_wdget.dart';
import 'package:ungdungbanmypham/widget_common/bg_widget.dart';
import 'package:ungdungbanmypham/widget_common/cusom_textfield.dart';
import 'package:ungdungbanmypham/widget_common/our_button.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {

  bool? isCheck = false;
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final retypePasswordController = TextEditingController();

  final AuthService _authService = AuthService();


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
              "Đăng ký tài khoản $appname".text.fontFamily(bold).white.size(18).make(),
              15.heightBox,
              Column(
                    children: [
                      customTextField(
                        title: name,
                        hint: nameHint,
                        controller: nameController,
                      ),
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
                      customTextField(
                        title: retypePassword,
                        hint: passwordHint,
                        controller: retypePasswordController,
                        isPassword: true,
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(onPressed: (){}, child: ForgetPassword.text.make())),
                     
                      5.heightBox,
                      Row(
                        children: [
      
                          Checkbox(
                            activeColor: redColor,
                            checkColor: whiteColor,
                            value: isCheck, onChanged: (newValue) {
                              setState(() {
                                isCheck = newValue;
                              });
                            }),
                          10.widthBox,
                          Expanded(
                            child: RichText(text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "Tôi đồng ý với ",
                                  style: TextStyle(
                                    fontFamily: regular,
                                    color: fontGrey
                                  )
                                ),
                                TextSpan(
                                  text: termsAndConditions,
                                  style: TextStyle(
                                    fontFamily: regular,
                                    color: redColor
                                  )
                                ),
                                TextSpan(
                                  text: " & ",
                                  style: TextStyle(
                                    fontFamily: regular,
                                    color: fontGrey
                                  )
                                ),
                                TextSpan(
                                  text: privacyPolicy,
                                  style: TextStyle(
                                    fontFamily: regular,
                                    color: redColor
                                  )
                                ),
                              ]
                            )
                            
                            ),
                          ),
                        ],
                      ),
                       5.heightBox,
                      ourButton(() async {
                        if (isCheck == true) {
                         if (passwordController.text ==
                          retypePasswordController.text) {
                        var result = await _authService.signUp(
                          emailController.text,
                          passwordController.text,
                          nameController.text
                        );

                        if (result != null) {
                          Get.snackbar("Thành công",
                              "Đăng ký tài khoản thành công!",
                              backgroundColor: Colors.green,
                              colorText: Colors.white
                              );

                          Future.delayed(const Duration(seconds: 1), () {
                                Get.off(() => const LoginScreen());
                                  });
                        } else {
                          Get.snackbar("Lỗi", "Không thể đăng ký.",
                              backgroundColor: Colors.red,
                              colorText: Colors.white);
                        }
                      } else {
                        Get.snackbar("Lỗi", "Mật khẩu nhập lại không khớp!",
                            backgroundColor: Colors.red,
                            colorText: Colors.white);
                      }
                    } else {
                      Get.snackbar("Thông báo",
                          "Bạn cần đồng ý với điều khoản trước khi đăng ký!",
                          backgroundColor: Colors.orange,
                          colorText: Colors.white);
                    }

                      }, isCheck ==true ? redColor : lightGrey,
                       isCheck ==true ? whiteColor : darkGrey, Signup)
                       .box.width(context.screenWidth - 50).make(),
                      10.heightBox,
                      RichText(text: TextSpan(
                        children: [
                          TextSpan(
                            text: alreadyHaveAccount,
                            style: TextStyle( 
                              fontFamily: bold,
                              color: fontGrey
                            )
                          ),
                          TextSpan(
                            text: Login,
                            style: TextStyle(
                              fontFamily: bold,
                              color: redColor
                            ),
                           
                          ),
                        ]
                      )).onTap((){
                        Get.back();
                      }),

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