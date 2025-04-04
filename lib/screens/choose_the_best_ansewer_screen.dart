import 'package:face_detection/controller/app_controller.dart';
import 'package:face_detection/controller/getx/theme_controller.dart';
import 'package:face_detection/widgets/taken_by.dart';
import 'package:face_detection/widgets/total.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChooseTheBestAnsewerScreen extends StatefulWidget {
  const ChooseTheBestAnsewerScreen({super.key, required this.questions});

  final List<Map<String, dynamic>> questions;

  @override
  State<ChooseTheBestAnsewerScreen> createState() => _McqScreenState();
}

class _McqScreenState extends State<ChooseTheBestAnsewerScreen> {
  List<String> selectedAnswers = [];
  bool isSubmitted = false;
  List<Map<String, dynamic>> questions = [];
  int total = 0;

  @override
  void initState() {
    selectedAnswers = List.filled(widget.questions.length, "");
    questions = widget.questions.map((question) {
      return {
        "question": question["question"],
        "options": AppController.suffle(question["options"]),
        "answer": question["answer"],
      };
    }).toList();
    questions.shuffle();
    setState(() {});
    super.initState();
  }

  void submit() {
    if (selectedAnswers.contains("")) {
      AppController.snackBar(context, 'Please answer all questions',
          purpose: Purpose.failure);
      return;
    }
    setState(() {
      isSubmitted = true;
    });
    final answers = questions.map((e) => e['answer']).toList();
    final c = selectedAnswers.where((element) => answers.contains(element));
    total = c.length;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.put(ThemeController());
    final bool isDark = themeController.isDark.value;
    return Scaffold(
      appBar: AppBar(
        title: Text("Choose the best ansewer"),
      ),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          physics: AlwaysScrollableScrollPhysics(),
          children: [
            TakenBy(),
            ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              itemCount: questions.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10),
                    Text(
                      ' ${index + 1}. ${questions[index]['question']}',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 10),
                    for (var i in questions[index]['options'])
                      RadioListTile<String>(
                          value: i,
                          groupValue: selectedAnswers[index],
                          tileColor: isSubmitted
                              ? i == questions[index]['answer']
                                  ? isDark
                                      ? const Color.fromARGB(255, 0, 110, 4)
                                      : const Color.fromARGB(255, 164, 255, 167)
                                  : i == selectedAnswers[index]
                                      ? selectedAnswers[index] ==
                                              questions[index]['answer']
                                          ? isDark
                                              ? const Color.fromARGB(
                                                  255, 0, 110, 4)
                                              : const Color.fromARGB(
                                                  255, 164, 255, 167)
                                          : isDark
                                              ? const Color.fromARGB(
                                                  255, 128, 9, 0)
                                              : const Color.fromARGB(
                                                  255, 255, 151, 144)
                                      : null
                              : null,
                          title: Text(i),
                          onChanged: isSubmitted
                              ? null
                              : (v) {
                                  setState(() {
                                    selectedAnswers[index] = v!;
                                  });
                                }),
                    SizedBox(height: 20),
                  ],
                );
              },
            ),
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
