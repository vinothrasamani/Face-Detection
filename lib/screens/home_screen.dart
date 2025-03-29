import 'package:face_detection/widgets/logo.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:face_detection/controller/app_controller.dart';
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

    await _databaseService.saveFace("User", faceEmbedding);
    AppController.snackBar(context, '✌️ Face added Successfully!');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Face Detector!'),
        leading: Padding(
          padding: EdgeInsets.all(8.0),
          child: Logo(radius: 20),
        ),
      ),
      body: SafeArea(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 50,
                child: Icon(Icons.check, size: 60),
              ),
              SizedBox(height: 10),
              Text('Welcome to Face Detector!'),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => registerFace(context),
        child: Icon(Icons.camera_alt),
      ),
    );
  }
}
