import 'package:face_detection/controller/app_controller.dart';
import 'package:face_detection/controller/getx/theme_controller.dart';
import 'package:face_detection/controller/getx/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class MatchScreen extends StatefulWidget {
  const MatchScreen({super.key, required this.list});

  final List<Map<String, dynamic>> list;

  @override
  State<MatchScreen> createState() => _MatchScreenState();
}

class _MatchScreenState extends State<MatchScreen> {
  List<Map<String, dynamic>> suffledList = [];
  List<List<int>> selectedAnswers = [];
  List<int> successAnswers = [];
  bool isSubmitted = false;
  int total = 0;

  @override
  void initState() {
    suffledList = widget.list
        .map((e) => {
              'qus': e['qus'],
              'ans': AppController.suffle(
                e['ans'],
              )
            })
        .toList();
    selectedAnswers = List.generate(suffledList.length, (i) => []);
    super.initState();
  }

  void reset(int questionIndex) {
    selectedAnswers[questionIndex] = [];
    setState(() {});
  }

  void selectMatch(int questionIndex, int answerIndex) {
    if (selectedAnswers[questionIndex].contains(answerIndex)) {
      return;
    }
    if (selectedAnswers[questionIndex].length ==
        suffledList[questionIndex]['qus'].length) {
      return;
    }
    selectedAnswers[questionIndex].add(answerIndex);
    setState(() {});
  }

  void submit() {
    if (selectedAnswers.any((ans) => ans.isEmpty)) {
      Get.snackbar('Required!', "Please answer all questions",
          backgroundColor: const Color.fromARGB(255, 118, 8, 1),
          colorText: Colors.white);
      return;
    }
    if (selectedAnswers
        .any((ans) => ans.length != suffledList[0]['qus'].length)) {
      Get.snackbar('Required!', "Please match all options",
          backgroundColor: const Color.fromARGB(255, 118, 8, 1),
          colorText: Colors.white);
      return;
    }
    setState(() {
      isSubmitted = true;
    });
    for (var i = 0; i < selectedAnswers.length; i++) {
      var ans = selectedAnswers[i];
      var c = 0;
      for (var j = 0; j < ans.length; j++) {
        if (suffledList[i]['ans'][ans[j]] == widget.list[i]['ans'][j]) {
          c++;
        }
      }
      if (c == suffledList[i]['ans'].length) {
        total += 5;
        successAnswers.add(i);
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.put(ThemeController());
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(title: Text('Match the Following')),
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
              itemCount: suffledList.length,
              shrinkWrap: true,
              itemBuilder: (context, index) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Text(
                        'Question ${index + 1}:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Spacer(),
                      if (isSubmitted)
                        Icon(
                          successAnswers.contains(index)
                              ? Icons.check_circle
                              : Icons.cancel,
                          color: successAnswers.contains(index)
                              ? Colors.green
                              : Colors.red,
                        ),
                      if (isSubmitted)
                        Text(
                          successAnswers.contains(index)
                              ? 'Correct!'
                              : 'Incorrect!',
                          style: TextStyle(
                            color: successAnswers.contains(index)
                                ? Colors.green
                                : Colors.red,
                          ),
                        ),
                      if (!isSubmitted)
                        SizedBox(
                          height: 30,
                          child: ElevatedButton(
                            onPressed: () {
                              reset(index);
                            },
                            style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(
                                    vertical: 2, horizontal: 15),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6),
                                )),
                            child: Text('Reset'),
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: 10),
                  for (var i in suffledList[index]['qus'])
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          width: size.width * 0.35,
                          child: Text(
                            '${suffledList[index]['qus'].indexOf(i) + 1}. $i',
                            softWrap: true,
                          ),
                        ),
                        SizedBox(width: 15),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              selectMatch(
                                  index, suffledList[index]['qus'].indexOf(i));
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: Text(
                                suffledList[index]['ans']
                                    [suffledList[index]['qus'].indexOf(i)],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 15),
                        GestureDetector(
                          onTap: () {
                            selectMatch(
                                index, suffledList[index]['qus'].indexOf(i));
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            width: size.width * 0.08,
                            child: Text(
                                '[${selectedAnswers[index].indexOf(suffledList[index]['qus'].indexOf(i)) + 1}]'),
                          ),
                        ),
                      ],
                    ),
                  SizedBox(height: 20),
                  Divider(),
                ],
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: isSubmitted ? null : submit,
              child: Text('Submit'),
            ),
            SizedBox(height: 20),
            if (isSubmitted)
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: LinearGradient(
                    colors: [
                      const Color.fromARGB(255, 159, 0, 122),
                      const Color.fromARGB(255, 10, 0, 116),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  children: [
                    SizedBox(height: 10),
                    Text(
                      'Total Score: $total',
                      style: GoogleFonts.roboto(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Get.back();
                        },
                        child: Text('Back To Home!'),
                      ),
                    ),
                  ],
                ),
              ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
