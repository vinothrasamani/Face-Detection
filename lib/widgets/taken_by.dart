import 'package:face_detection/controller/getx/theme_controller.dart';
import 'package:face_detection/controller/getx/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TakenBy extends StatelessWidget {
  const TakenBy({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.put(ThemeController());
    return Column(
      children: [
        SizedBox(height: 10),
        ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 0),
          leading: CircleAvatar(
            radius: 28,
            backgroundImage: NetworkImage(
                'https://i.pinimg.com/736x/ec/a2/68/eca268451638f69caf3256fa1ba678b9.jpg'),
          ),
          title: Text(
            'Taken by ${Get.put(UserController()).username}!',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: themeController.isDark.value
                    ? Colors.white
                    : Theme.of(context).primaryColor),
          ),
        ),
        Divider(),
      ],
    );
  }
}
