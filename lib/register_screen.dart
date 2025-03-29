import 'dart:io';
import 'package:flutter/material.dart';
import '../services/camera_service.dart';
import '../services/face_detection_service.dart';
import '../services/database_service.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final CameraService _cameraService = CameraService();
  final FaceDetectionService _faceDetectionService = FaceDetectionService();
  final DatabaseService _databaseService = DatabaseService();

  Future<void> registerFace(context) async {
    final image = await _cameraService.captureImage();
    if (image == null) return;

    final faceEmbedding =
        await _faceDetectionService.detectFace(File(image.path));
    if (faceEmbedding.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ No face detected!")),
      );
      print("No face detected!");
      return;
    }

    print('Detected face data: $faceEmbedding');

    await _databaseService.saveFace("User", faceEmbedding);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("✅ Face Registered Successfully")),
    );
    print("✅ Face Registered Successfully");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Register Face")),
      body: Center(
          child: ElevatedButton(
        onPressed: () {
          registerFace(context);
        },
        child: Text("Capture Face"),
      )),
    );
  }
}
