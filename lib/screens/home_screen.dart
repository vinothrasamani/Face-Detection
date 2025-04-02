import 'package:face_detection/controller/getx/theme_controller.dart';
import 'package:face_detection/controller/getx/user_controller.dart';
import 'package:face_detection/data/local_data.dart';
import 'package:face_detection/screens/login_screen.dart';
import 'package:face_detection/screens/match_screen.dart';
import 'package:face_detection/screens/mcq_screen.dart';
import 'package:face_detection/widgets/logo.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:face_detection/controller/app_controller.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../services/camera_service.dart';
import '../../services/face_detection_service.dart';
import '../../services/database_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final CameraService _cameraService = CameraService();
  final FaceDetectionService _faceDetectionService = FaceDetectionService();
  final DatabaseService _databaseService = DatabaseService();
  List<Map<String, dynamic>> storedFaces = [];

  TextStyle style = TextStyle(
    fontWeight: FontWeight.bold,
  );

  Future<void> registerFace(context) async {
    final image = await _cameraService.captureImage();
    if (image == null) return;

    final faceEmbedding =
        await _faceDetectionService.detectFace(File(image.path));
    if (faceEmbedding.isEmpty) {
      AppController.snackBar(context, '🙅‍♂️ No face detected!',
          purpose: Purpose.failure);
      return;
    }

    await _databaseService.insertData("faces", {
      "name": '${Get.put(UserController()).username}',
      "embedding": faceEmbedding.join(",")
    });
    AppController.snackBar(context, '✌️ Face added Successfully!');
  }

  Future<void> getStoredFaces() async {
    storedFaces = await _databaseService.getStoredFaces("faces");
    setState(() {});
  }

  @override
  void initState() {
    getStoredFaces();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final ThemeController themeController = Get.put(ThemeController());
    return Scaffold(
      appBar: AppBar(
        title: Text('Smart Examiner!'),
        leading: Padding(
          padding: EdgeInsets.all(8.0),
          child: Logo(radius: 20),
        ),
        actions: [
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
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 15),
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Welcome ${Get.put(UserController()).username}!',
                  style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: themeController.isDark.value
                          ? Colors.white
                          : Theme.of(context).primaryColor),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Test your Knowledge',
                style: GoogleFonts.aboreto(
                    fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Image.network(
                'https://img.freepik.com/premium-vector/online-exam-checklist-pencil-computer-monitor_153097-220.jpg',
                width: double.infinity,
                height: size.height * 0.35,
                fit: BoxFit.fitWidth,
              ),
              SizedBox(height: 15),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Get.to(() => McqScreen(
                          questions: LocalData.mcq,
                        ));
                  },
                  child: Text('Choose the correct answer', style: style),
                ),
              ),
              SizedBox(height: 15),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Get.to(() => MatchScreen(
                          list: LocalData.mtf,
                        ));
                  },
                  child: Text('Match the followings', style: style),
                ),
              ),
              SizedBox(height: 15),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {},
                  child: Text('Paragraph Typing', style: style),
                ),
              ),
              SizedBox(height: 15),
            ],
          ),
        ),
      ),
      floatingActionButton: storedFaces.isEmpty
          ? FloatingActionButton(
              tooltip: 'Add Face to Autheenticate',
              onPressed: () => registerFace(context),
              child: Icon(Icons.camera_alt),
            )
          : null,
    );
  }
}
