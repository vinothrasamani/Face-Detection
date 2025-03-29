import 'dart:io';
import 'package:face_detection/register_screen.dart';
import 'package:flutter/material.dart';
import '../services/camera_service.dart';
import '../services/face_detection_service.dart';
import '../services/database_service.dart';
import '../services/face_auth_service.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final CameraService _cameraService = CameraService();
  final FaceDetectionService _faceDetectionService = FaceDetectionService();
  final DatabaseService _databaseService = DatabaseService();
  final FaceAuthService _faceAuthService = FaceAuthService();

  Future<void> authenticateUser(context) async {
    final image = await _cameraService.captureImage();
    if (image == null) return;

    final currentEmbedding =
        await _faceDetectionService.detectFace(File(image.path));
    if (currentEmbedding.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ No face detected!")),
      );
      print("❌ No face detected!");
      return;
    }

    final storedFaces = await _databaseService.getStoredFaces();
    for (var face in storedFaces) {
      final storedEmbedding =
          face["embedding"].split(",").map(double.parse).toList();
      print('Catured Face Embedding: $currentEmbedding');
      print('Stored Face Embedding: $storedEmbedding');
      double similarity =
          _faceAuthService.compareEmbeddings(currentEmbedding, storedEmbedding);
      print('Similarity: $similarity');

      if (similarity > 0.8) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("✅ Authenticate user!")),
        );
        print("✅ Login Successful");
        return;
      }
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("❌ Unauthorized user!")),
    );
    print("❌ Face Not Recognized!");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Face Login")),
      body: Center(
          child: ElevatedButton(
        onPressed: () {
          authenticateUser(context);
        },
        child: Text("Login with Face"),
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => RegisterScreen()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
