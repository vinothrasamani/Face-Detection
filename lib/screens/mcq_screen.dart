import 'package:face_detection/controller/getx/theme_controller.dart';
import 'package:face_detection/controller/getx/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
//---------------method 2------------------
// import 'package:google_fonts/google_fonts.dart';

class McqScreen extends StatefulWidget {
  const McqScreen({super.key, required this.questions});

  final List<Map<String, dynamic>> questions;

  @override
  State<McqScreen> createState() => _McqScreenState();
}

class _McqScreenState extends State<McqScreen> {
  //---------------method 1 & 2------------------
  List<String> selectedAnswers = [];
  bool submited = false;
  List<Map<String, dynamic>> questions = [];

  //---------------method 2------------------
  int currentQuestionIndex = 0;

  @override
  void initState() {
    //---------------method 1 & 2------------------
    selectedAnswers = List.filled(widget.questions.length, "");
    questions = widget.questions.map((question) {
      return {
        "question": question["question"],
        "options": suffle(question["options"]),
        "answer": question["answer"],
      };
    }).toList();
    questions.shuffle();
    setState(() {});
    super.initState();
  }

  //---------------method 1------------------
  void submit() {
    if (selectedAnswers.contains("")) {
      Get.snackbar('Required!', "Please answer all questions",
          backgroundColor: const Color.fromARGB(255, 118, 8, 1),
          colorText: Colors.white);
      return;
    }
    submited = true;
    setState(() {});
  }

  //---------------method 2------------------
  // void submit() async {
  //   if (currentQuestionIndex + 1 == questions.length) {
  //     submited = true;
  //     final answers = questions.map((e) => e['answer']).toList();
  //     final c = selectedAnswers.where((element) => answers.contains(element));
  //     print(c);
  //     Get.defaultDialog(
  //       title: "Result",
  //       content: Column(
  //         children: [
  //           Text(
  //             "Your Score is ${c.length}/${questions.length}",
  //             style: GoogleFonts.poppins(
  //               fontSize: 16,
  //               fontWeight: FontWeight.w500,
  //             ),
  //           ),
  //           SizedBox(height: 10),
  //           ElevatedButton(
  //             onPressed: () {
  //               Get.back();
  //               Get.back();
  //             },
  //             child: Text("Back to Home"),
  //           ),
  //         ],
  //       ),
  //     );
  //     await Future.delayed(Duration(seconds: 8), () {});
  //     Get.back();
  //     Get.back();
  //   } else {
  //     currentQuestionIndex++;
  //   }
  //   if (mounted) {
  //     setState(() {});
  //   }
  // }

  //---------------method 1 & 2------------------
  List<String> suffle(List<String> list) {
    List<String> shuffledList = List.from(list);
    shuffledList.shuffle();
    return shuffledList;
  }

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.put(ThemeController());
    return Scaffold(
      appBar: AppBar(
        title: Text("Exam - MCQ"),
      ),

      //---------------method 1------------------
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          physics: AlwaysScrollableScrollPhysics(),
          children: [
            SizedBox(height: 10),
            ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 0),
              leading: CircleAvatar(
                radius: 28,
                backgroundImage: NetworkImage(
                    'https://i.pinimg.com/736x/ec/a2/68/eca268451638f69caf3256fa1ba678b9.jpg'),
              ),
              title: Text(
                'Taken by ${Get.put(UserController()).username}!',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: themeController.isDark.value
                        ? Colors.white
                        : Theme.of(context).primaryColor),
              ),
            ),
            Divider(),
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
                          tileColor: submited
                              ? i == questions[index]['answer']
                                  ? const Color.fromARGB(255, 164, 255, 167)
                                  : i == selectedAnswers[index]
                                      ? selectedAnswers[index] ==
                                              questions[index]['answer']
                                          ? const Color.fromARGB(
                                              255, 164, 255, 167)
                                          : const Color.fromARGB(
                                              255, 255, 151, 144)
                                      : null
                              : null,
                          title: Text(i),
                          onChanged: (v) {
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
              onPressed: submited ? null : submit,
              child: Text('Submit'),
            ),
            SizedBox(height: 10),
          ],
        ),
      ),

      //---------------method 2------------------
      // body: SafeArea(
      //   child: Container(
      //     width: double.infinity,
      //     padding: const EdgeInsets.all(10),
      //     child: Column(
      //       mainAxisAlignment: MainAxisAlignment.center,
      //       children: [
      //         SizedBox(height: 30),
      //         CircleAvatar(
      //           radius: 50,
      //           backgroundImage: NetworkImage(
      //               'https://i.pinimg.com/736x/ec/a2/68/eca268451638f69caf3256fa1ba678b9.jpg'),
      //         ),
      //         SizedBox(height: 15),
      //         Text('Tacken by ${Get.put(UserController()).username}!',
      //             style: GoogleFonts.roboto(
      //               fontSize: 20,
      //               fontWeight: FontWeight.bold,
      //             )),
      //         SizedBox(height: 15),
      //         Card(
      //           color: themeController.isDark.value
      //               ? Theme.of(context).secondaryHeaderColor
      //               : Theme.of(context).primaryColor.withAlpha(10),
      //           child: Column(
      //             children: [
      //               SizedBox(height: 20),
      //               Text(
      //                 'Qusetion ${currentQuestionIndex + 1}',
      //                 style: TextStyle(
      //                   fontSize: 18,
      //                   fontWeight: FontWeight.bold,
      //                 ),
      //               ),
      //               SizedBox(height: 10),
      //               Padding(
      //                 padding: const EdgeInsets.symmetric(horizontal: 15),
      //                 child: Text(
      //                   '${questions[currentQuestionIndex]['question']}',
      //                   style: TextStyle(fontSize: 16),
      //                   textAlign: TextAlign.center,
      //                 ),
      //               ),
      //               SizedBox(height: 10),
      //               SizedBox(height: 10),
      //               for (var i in questions[currentQuestionIndex]['options'])
      //                 RadioListTile<String>(
      //                   value: i,
      //                   groupValue: selectedAnswers[currentQuestionIndex],
      //                   title: Text(i),
      //                   onChanged: (v) {
      //                     setState(() {
      //                       selectedAnswers[currentQuestionIndex] = v!;
      //                     });
      //                   },
      //                 ),
      //               SizedBox(height: 10),
      //             ],
      //           ),
      //         )
      //       ],
      //     ),
      //   ),
      // ),
      // bottomNavigationBar: Container(
      //     padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      //     color: Colors.transparent,
      //     child: ElevatedButton(
      //       onPressed: submited ? null : submit,
      //       child: Text(currentQuestionIndex + 1 == questions.length
      //           ? 'Submit'
      //           : 'Next'),
      //     ),
      // ),
    );
  }
}
