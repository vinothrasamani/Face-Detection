import 'package:face_detection/widgets/logo.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:face_detection/controller/app_controller.dart';
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

    await _databaseService.saveFace("User", faceEmbedding);
    AppController.snackBar(context, '✌️ Face added Successfully!');
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Smart Examiner!'),
        leading: Padding(
          padding: EdgeInsets.all(8.0),
          child: Logo(radius: 20),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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
                  onPressed: () {},
                  child: Text('Choose the besst option', style: style),
                ),
              ),
              SizedBox(height: 15),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {},
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
      floatingActionButton: FloatingActionButton(
        onPressed: () => registerFace(context),
        child: Icon(Icons.camera_alt),
      ),
    );
  }
}
