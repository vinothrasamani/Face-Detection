import 'package:face_detection/controller/getx/theme_controller.dart';
import 'package:face_detection/controller/getx/user_controller.dart';
import 'package:face_detection/widgets/editor.dart';
import 'package:face_detection/widgets/exam.dart';
import 'package:face_detection/widgets/logo.dart';
import 'package:face_detection/widgets/menu.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:face_detection/controller/app_controller.dart';
import 'package:get/get.dart';
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
  int _currentIndex = 0;

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
        title: Text(_currentIndex == 0 ? 'Smart Examiner!' : 'Math Editor!'),
        leading: Padding(
          padding: EdgeInsets.all(8.0),
          child: Logo(radius: 20),
        ),
        actions: [Menu()],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(15),
          child: _currentIndex == 0
              ? Exam(size: size, isDark: themeController.isDark.value)
              : Editor(),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        currentIndex: _currentIndex,
        onTap: (value) {
          setState(() {
            _currentIndex = value;
          });
        },
        selectedItemColor: const Color.fromARGB(255, 73, 250, 63),
        unselectedItemColor: const Color.fromARGB(255, 217, 217, 217),
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Exam'),
          BottomNavigationBarItem(icon: Icon(Icons.edit), label: 'Editor'),
        ],
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
