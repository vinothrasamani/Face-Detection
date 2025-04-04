import 'package:face_detection/controller/app_controller.dart';
import 'package:face_detection/controller/getx/theme_controller.dart';
import 'package:face_detection/widgets/taken_by.dart';
import 'package:face_detection/widgets/total.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class FillInTheBlankScreen extends StatefulWidget {
  const FillInTheBlankScreen({super.key, required this.dataItems});

  final Map<String, List<String>> dataItems;

  @override
  State<FillInTheBlankScreen> createState() => _FillInTheBlankScreenState();
}

class _FillInTheBlankScreenState extends State<FillInTheBlankScreen> {
  List<String> answers = [];
  bool isSubmitted = false;
  int total = 0;
  List<bool> isCorrect = [];

  void submit() {
    if (!answers.contains('')) {
      for (int i = 0; i < answers.length; i++) {
        if (widget.dataItems['answers']![i].contains('‖')) {
          final answerArray =
              widget.dataItems['answers']![i].trim().toLowerCase().split('‖');
          bool isMatch = false;
          for (var ans in answerArray) {
            if (ans == answers[i].trim().toLowerCase()) {
              isCorrect.add(true);
              total++;
              isMatch = true;
            }
          }
          if (!isMatch) {
            isCorrect.add(false);
          }
        } else {
          if (answers[i].trim().toLowerCase() ==
              widget.dataItems['answers']![i].trim().toLowerCase()) {
            isCorrect.add(true);
            total++;
          } else {
            isCorrect.add(false);
          }
        }
      }
      setState(() {
        isSubmitted = true;
      });
    } else {
      AppController.snackBar(context, 'Fill all the blanks!',
          purpose: Purpose.failure);
    }
  }

  Future<void> enterAnswer(int index, String qus) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Enter your answer',
          style: TextStyle(fontSize: 18),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(qus),
            const SizedBox(height: 10),
            TextField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter your answer',
                hintStyle: TextStyle(fontSize: 13),
              ),
              onChanged: (value) {
                answers[index] = value.trim();
                setState(() {});
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    answers = List.filled(widget.dataItems['questions']!.length, '');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.put(ThemeController());
    final isDark = themeController.isDark.value;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Fill in the blanks"),
      ),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          physics: AlwaysScrollableScrollPhysics(),
          children: [
            TakenBy(),
            Text(
              'Questions :',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            ListView.builder(
              itemCount: widget.dataItems['questions']!.length,
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                final question = widget.dataItems['questions']![index];
                final questionParts = question.split('__________');
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${index + 1}. ',
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Expanded(
                            child: GestureDetector(
                              onTap: isSubmitted
                                  ? null
                                  : () async {
                                      await enterAnswer(index, question);
                                    },
                              child: RichText(
                                text: TextSpan(
                                  style: GoogleFonts.roboto(
                                    fontSize: 16,
                                    color: isDark ? Colors.white : Colors.black,
                                  ),
                                  children: [
                                    TextSpan(text: "${questionParts[0]} "),
                                    TextSpan(
                                      text: answers[index] != ''
                                          ? answers[index]
                                          : '__________',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          decoration: answers[index] != '' &&
                                                  !isSubmitted
                                              ? TextDecoration.underline
                                              : null,
                                          color: !isSubmitted
                                              ? isDark
                                                  ? Colors.white
                                                  : Colors.black
                                              : isCorrect[index]
                                                  ? Colors.green
                                                  : Colors.red),
                                    ),
                                    TextSpan(text: questionParts[1]),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: isSubmitted ? null : submit,
              child: Text('Submit'),
            ),
            SizedBox(height: 20),
            if (isSubmitted) Total(total: total),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
