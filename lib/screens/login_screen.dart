import 'dart:convert';
import 'dart:io';
import 'package:face_detection/controller/app_controller.dart';
import 'package:face_detection/controller/getx/user_controller.dart';
import 'package:face_detection/screens/home_screen.dart';
import 'package:face_detection/widgets/logo.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../services/camera_service.dart';
import '../../services/face_detection_service.dart';
import '../../services/database_service.dart';
import '../../services/face_auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _HomeState();
}

class _HomeState extends State<LoginScreen> {
  final CameraService _cameraService = CameraService();
  final FaceDetectionService _faceDetectionService = FaceDetectionService();
  final DatabaseService _databaseService = DatabaseService();
  final FaceAuthService _faceAuthService = FaceAuthService();
  final _formKey = GlobalKey<FormState>();
  List<Map<String, dynamic>> storedFaces = [];
  bool canShow = false, islogin = true;
  String? username, password;

  Future<void> authenticateUser(context) async {
    final image = await _cameraService.captureImage();
    if (image == null) return;

    final currentEmbedding =
        await _faceDetectionService.detectFace(File(image.path));
    if (currentEmbedding.isEmpty) {
      AppController.snackBar(context, '🙅‍♂️ No face detected!',
          purpose: Purpose.failure);
      return;
    }

    for (var face in storedFaces) {
      final storedEmbedding =
          face["embedding"].split(",").map(double.parse).toList();
      double similarity =
          _faceAuthService.compareEmbeddings(currentEmbedding, storedEmbedding);

      if (similarity > 0.8) {
        Get.put(UserController()).getUsername(face['name']);
        Get.off(() => HomeScreen());
        AppController.snackBar(context, '✌️ Login Successfully!');
        return;
      }
    }

    AppController.snackBar(context, '🙅‍♂️ Unauthorized user!',
        purpose: Purpose.failure);
  }

  Future<void> getStoredFaces() async {
    storedFaces = await _databaseService.getStoredFaces("faces");
    setState(() {});
  }

  void process() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final res =
          await AppController.postRequest(islogin ? 'login' : 'register', {
        "name": username,
        "password": password,
      });
      if (res == null) {
        AppController.snackBar(context, '🙅‍♂️ Something went wrong!',
            purpose: Purpose.failure);
        return;
      } else {
        final result = jsonDecode(res);
        if (result['success']) {
          Get.put(UserController()).getUsername(username!);
          Get.off(() => HomeScreen());
          AppController.snackBar(context,
              islogin ? 'Login Successfully!' : 'Registered Successfully!');
        } else {
          AppController.snackBar(context, result['message'],
              purpose: Purpose.failure);
          return;
        }
      }
    }
  }

  @override
  void initState() {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    getStoredFaces();
    super.initState();
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(islogin ? "Sign In" : "Sign Up"),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Logo(radius: 20),
        ),
      ),
      body: SafeArea(
        child: ListView(
          children: [
            Image.network(
              'https://img.freepik.com/free-vector/mobile-login-concept-illustration_114360-135.jpg?t=st=1743242089~exp=1743245689~hmac=6f3ba2442d3aa1d332c3c56690781ee640091fe80ee58dbf3f6511ae81df2852&w=826',
              fit: BoxFit.cover,
              height: screenWidth * 0.8,
            ),
            SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      islogin ? "Welcome Back!" : "Create an account!",
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      decoration: InputDecoration(hintText: 'Username'),
                      onTapOutside: (event) {
                        FocusScope.of(context).unfocus();
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your username';
                        }
                        return null;
                      },
                      onSaved: (newValue) {
                        username = newValue;
                      },
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Password',
                        suffix: GestureDetector(
                          onTap: () {
                            setState(() {
                              canShow = !canShow;
                            });
                          },
                          child: Icon(
                            canShow ? Icons.visibility : Icons.visibility_off,
                          ),
                        ),
                      ),
                      onTapOutside: (event) {
                        FocusScope.of(context).unfocus();
                      },
                      obscureText: !canShow,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your username';
                        }
                        return null;
                      },
                      onSaved: (newValue) {
                        password = newValue;
                      },
                    ),
                    SizedBox(height: 15),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: process,
                        child: Text(
                          islogin ? "Login" : "Sign Up",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text.rich(
                      TextSpan(
                        text: islogin
                            ? 'Don\'t have an account? '
                            : 'Already have an account? ',
                        children: [
                          TextSpan(
                            text: islogin ? 'Sign Up' : 'Login',
                            style: TextStyle(
                              color: Colors.blue,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                setState(() {
                                  islogin = !islogin;
                                });
                              },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    storedFaces.isNotEmpty && islogin
                        ? Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(child: Divider()),
                                  Text(' OR '),
                                  Expanded(child: Divider()),
                                ],
                              ),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () {
                                    authenticateUser(context);
                                  },
                                  child: Text(
                                    "Login with Face",
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        : Text(''),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
