import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'dart:io';

class FaceDetectionService {
  final FaceDetector _faceDetector = FaceDetector(
    options: FaceDetectorOptions(
      enableClassification: true,
      performanceMode: FaceDetectorMode.accurate,
    ),
  );

  Future<List<double>> detectFace(File imageFile) async {
    final inputImage = InputImage.fromFile(imageFile);
    final faces = await _faceDetector.processImage(inputImage);

    if (faces.isEmpty) return [];

    final face = faces.first;
    return extractFeatures(face);
  }

  List<double> extractFeatures(Face face) {
    return [
      face.smilingProbability ?? 0.0,
      face.leftEyeOpenProbability ?? 0.0,
      face.rightEyeOpenProbability ?? 0.0,
      face.headEulerAngleX ?? 0.0,
      face.headEulerAngleY ?? 0.0,
      face.headEulerAngleZ ?? 0.0,
    ];
  }
}
