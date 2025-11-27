import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ungdungbanmypham/core/consts/consts.dart';
import 'package:ungdungbanmypham/presentation/controllers/user_controller.dart';
import 'package:ungdungbanmypham/presentation/pages/auth_screen/login_screen.dart';
import 'package:ungdungbanmypham/presentation/widgets/common/our_button.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:ungdungbanmypham/presentation/controllers/auth_controller.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userController = Get.put(UserController());
    final firebaseUser = FirebaseAuth.instance.currentUser;
    final authController = Get.put(AuthController());

    return Container(
      padding: const EdgeInsets.all(12),
      color: lightGrey,
      child: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: redColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: whiteColor,
                    child: Icon(Icons.person, size: 32, color: redColor),
                  ),
                  12.widthBox,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        (firebaseUser?.displayName ?? "Khách hàng").text.white
                            .fontFamily(bold)
                            .size(18)
                            .make(),
                        (firebaseUser?.email ?? "Chưa có email").text.white
                            .size(14)
                            .make(),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => userController.fetchCurrentUser(),
                    icon: const Icon(Icons.refresh, color: whiteColor),
                  ),
                ],
              ),
            ),
            16.heightBox,
            Expanded(
              child: Obx(() {
                if (userController.isLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator(color: redColor),
                  );
                }

                if (userController.error.value != null) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.info_outline, size: 40, color: redColor),
                      12.heightBox,
                      userController.error.value!.text
                          .color(redColor)
                          .makeCentered(),
                      20.heightBox,
                      ourButton(
                        () => userController.fetchCurrentUser(),
                        redColor,
                        whiteColor,
                        "Thử lại",
                      ),
                    ],
                  );
                }

                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      "Thông tin liên hệ".text
                          .fontFamily(bold)
                          .size(18)
                          .color(darkFontGrey)
                          .make(),
                      12.heightBox,
                      _buildInputField(
                        label: "Số điện thoại",
                        controller: userController.phoneController,
                        keyboardType: TextInputType.phone,
                        icon: Icons.phone,
                      ),
                      16.heightBox,
                      _buildInputField(
                        label: "Địa chỉ giao hàng",
                        controller: userController.addressController,
                        icon: Icons.location_on,
                        maxLines: 3,
                      ),
                      24.heightBox,
                      Obx(() {
                        if (userController.isSaving.value) {
                          return const Center(
                            child: CircularProgressIndicator(color: redColor),
                          );
                        }
                        return SizedBox(
                          width: double.infinity,
                          child: ourButton(
                            () => userController.saveProfile(),
                            redColor,
                            whiteColor,
                            "Lưu thay đổi",
                          ),
                        );
                      }),
                      24.heightBox,

                      _buildInfoCard(userController),
                      24.heightBox,
                      24.heightBox,
                      SizedBox(
                        width: double.infinity,
                        child: ourButton(
                          () async {
                            // 1. Hỏi xác nhận
                            final confirm = await Get.dialog<bool>(
                              AlertDialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                title: "Đăng xuất".text.bold.size(18).make(),
                                content:
                                    "Bạn có chắc chắn muốn đăng xuất khỏi tài khoản?"
                                        .text
                                        .make(),
                                actions: [
                                  TextButton(
                                    onPressed: () => Get.back(result: false),
                                    child: "Hủy".text
                                        .color(darkFontGrey)
                                        .make(),
                                  ),
                                  TextButton(
                                    onPressed: () => Get.back(result: true),
                                    child: "Đăng xuất".text
                                        .color(redColor)
                                        .bold
                                        .make(),
                                  ),
                                ],
                              ),
                              barrierDismissible: false,
                            );

                            if (confirm != true) return;

                            // Show loading dialog
                            Get.dialog(
                              const Center(
                                child: CircularProgressIndicator(
                                  color: redColor,
                                ),
                              ),
                              barrierDismissible: false,
                            );

                            try {
                              await authController.signOut();
                              if (Get.isDialogOpen == true) Get.back();
                              Get.offAll(() => const LoginScreen());
                            } catch (e) {
                              if (Get.isDialogOpen == true) Get.back();

                              Get.snackbar(
                                "Lỗi",
                                "Đã xảy ra lỗi khi đăng xuất: $e",
                                backgroundColor: redColor,
                                colorText: whiteColor,
                                snackPosition: SnackPosition.BOTTOM,
                              );

                              Get.offAll(() => const LoginScreen());
                            }
                          },
                          redColor,
                          whiteColor,
                          "Đăng xuất",
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    IconData? icon,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        filled: true,
        fillColor: whiteColor,
        labelText: label,
        prefixIcon: icon != null ? Icon(icon, color: redColor) : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildInfoCard(UserController controller) {
    final user = controller.user.value;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          "Thông tin tài khoản".text
              .fontFamily(bold)
              .size(16)
              .color(darkFontGrey)
              .make(),
          12.heightBox,
          _infoRow("ID người dùng", user?.id.toString() ?? "-"),
          _infoRow("Số điện thoại", user?.phone ?? "Chưa cập nhật"),
          _infoRow("Địa chỉ", user?.address ?? "Chưa cập nhật"),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(flex: 3, child: label.text.gray600.make()),
          Expanded(flex: 4, child: value.text.color(darkFontGrey).make()),
        ],
      ),
    );
  }
}
