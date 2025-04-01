import 'package:get/get.dart';

import 'package:users/model/user_model.dart';
import 'package:users/data/repositories/user_repository.dart';

class UserController extends GetxController {
  final UserRepository repository;

  UserController({required this.repository});

  // Estado reactivo
  final RxList<UserModel> users = <UserModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    try {
      isLoading.value = true;
      final fetchedUsers = await repository.getUsers();
      users.assignAll(fetchedUsers);
    } catch (e) {
      error.value = e.toString();
      users.clear();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addUser(UserModel user) async {
    try {
      final newUser = await repository.createUser(user);
      users.add(newUser);
    } catch (e) {
      error.value = e.toString();
    }
  }

  Future<void> deleteUser(String userId) async {
    try {
      await repository.deleteUser(userId);
      users.removeWhere((user) => user.id == userId);
    } catch (e) {
      error.value = e.toString();
    }
  }

  Future<void> updateUser(String userId, Map<String, dynamic> data) async {
    try {
      final updatedUser = await repository.updateUser(userId, data);
      final index = users.indexWhere((user) => user.id == userId);
      if (index != -1) {
        users[index] = updatedUser;
      }
    } catch (e) {
      error.value = e.toString();
    }
  }
}
