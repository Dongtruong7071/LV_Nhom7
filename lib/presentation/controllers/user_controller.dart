import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/datasources/remote/user_remote_data_source.dart';
import '../../data/repositories/user_repository_impl.dart';
import '../../domain/entities/user.dart' as domain_user;
import '../../domain/repositories/user_repository.dart';

class UserController extends GetxController {
  late final UserRepository _repository;

  UserController() {
    _repository = UserRepositoryImpl(remoteDataSource: UserRemoteDataSource());
  }

  final phoneController = TextEditingController();
  final addressController = TextEditingController();

  var user = Rx<domain_user.User?>(null);
  var isLoading = false.obs;
  var isSaving = false.obs;
  var error = Rx<String?>(null);

  @override
  void onInit() {
    super.onInit();
    fetchCurrentUser();
  }

  Future<void> fetchCurrentUser() async {
    try {
      isLoading.value = true;
      error.value = null;

      final firebaseUser = FirebaseAuth.instance.currentUser;
      if (firebaseUser == null) {
        error.value = "Bạn chưa đăng nhập";
        return;
      }

      final fetchedUser =
          await _repository.getUserByFirebaseUid(firebaseUser.uid);

      user.value = fetchedUser;
      phoneController.text = fetchedUser.phone ?? '';
      addressController.text = fetchedUser.address ?? '';
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> saveProfile() async {
    final currentUser = user.value;
    if (currentUser == null) return;

    try {
      isSaving.value = true;
      final updated = await _repository.updateUser(currentUser.id, {
        "phone": phoneController.text.trim().isEmpty
            ? null
            : phoneController.text.trim(),
        "address": addressController.text.trim().isEmpty
            ? null
            : addressController.text.trim(),
      });
      user.value = updated;
      Get.snackbar("Thành công", "Đã lưu thông tin cá nhân");
    } catch (e) {
      Get.snackbar("Lỗi", "Không thể cập nhật thông tin");
    } finally {
      isSaving.value = false;
    }
  }

  @override
  void onClose() {
    phoneController.dispose();
    addressController.dispose();
    super.onClose();
  }
}


