import 'package:get/get.dart';

class UserController extends GetxController {
  var username = "".obs;

  void getUsername(String username) {
    this.username.value = username;
  }
}
