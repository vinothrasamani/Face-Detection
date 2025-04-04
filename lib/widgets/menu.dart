import 'package:face_detection/controller/getx/theme_controller.dart';
import 'package:face_detection/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Menu extends StatelessWidget {
  const Menu({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.put(ThemeController());
    return Row(
      children: [
        PopupMenuButton(
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 1,
              height: 40,
              onTap: () {
                themeController.changeTheme();
              },
              child: Row(
                children: [
                  Icon(
                    Icons.dark_mode,
                    color: Colors.grey,
                  ),
                  SizedBox(width: 4),
                  Text('Dark Mode'),
                ],
              ),
            ),
            PopupMenuItem(
              value: 2,
              onTap: () {
                Get.offAll(() => LoginScreen());
              },
              height: 40,
              child: Row(
                children: [
                  Icon(
                    Icons.logout,
                    color: Colors.grey,
                  ),
                  SizedBox(width: 4),
                  Text('Logout'),
                ],
              ),
            ),
          ],
        ),
        SizedBox(width: 8),
      ],
    );
  }
}
