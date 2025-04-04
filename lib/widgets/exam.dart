import 'package:face_detection/controller/getx/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:face_detection/data/local_data.dart';
import 'package:face_detection/screens/fill_in_the_blank_screen.dart';
import 'package:face_detection/screens/match_the_following_screen.dart';
import 'package:face_detection/screens/choose_the_best_ansewer_screen.dart';
import 'package:face_detection/screens/paragraph_writing_screen.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class Exam extends StatelessWidget {
  const Exam({super.key, required this.isDark, required this.size});

  final bool isDark;
  final Size size;

  @override
  Widget build(BuildContext context) {
    TextStyle style = TextStyle(
      fontWeight: FontWeight.bold,
    );

    return Column(
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
                color: isDark ? Colors.white : Theme.of(context).primaryColor),
          ),
        ),
        SizedBox(height: 20),
        Text(
          'Rosemary Metric Hr Sec School',
          style: GoogleFonts.aboreto(fontSize: 20, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 20),
        Image.network(
          'https://img.freepik.com/premium-vector/online-exam-checklist-pencil-computer-monitor_153097-220.jpg',
          width: double.infinity,
          height: size.height * 0.35,
          fit: BoxFit.fitWidth,
        ),
        SizedBox(height: 15),
        Text(
          'Internal Exam - I',
          style: style.copyWith(fontSize: 18),
        ),
        SizedBox(height: 5),
        Text('Atted all the questions and do well!', style: style),
        SizedBox(height: 15),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              Get.to(() => ChooseTheBestAnsewerScreen(
                    questions: LocalData.mcq,
                  ));
            },
            child: Text('Choose the best answer', style: style),
          ),
        ),
        SizedBox(height: 15),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              Get.to(() => MatchTheFollowingScreen(
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
            onPressed: () {
              Get.to(() => ParagraphWritingScreen(
                    questions: LocalData.qus,
                  ));
            },
            child: Text('Paragraph Writing', style: style),
          ),
        ),
        SizedBox(height: 15),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              Get.to(() =>
                  FillInTheBlankScreen(dataItems: LocalData.fillInTheBlank));
            },
            child: Text('Fill In The Blanks', style: style),
          ),
        ),
        SizedBox(height: 10),
        Row(
          children: [
            Expanded(child: Divider()),
            Text(' All the best! ', style: style),
            Expanded(child: Divider()),
          ],
        ),
        SizedBox(height: 10),
        Text(
            'Please verify all sections are completed! and then continue to submit the exam.'),
        SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text('Submit Exam!'),
          ),
        ),
        SizedBox(height: 10),
      ],
    );
  }
}
