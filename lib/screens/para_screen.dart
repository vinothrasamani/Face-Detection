import 'package:face_detection/controller/getx/theme_controller.dart';
import 'package:face_detection/controller/getx/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:string_similarity/string_similarity.dart';

class ParaScreen extends StatefulWidget {
  const ParaScreen({super.key, required this.questions});

  final Map<String, List<String>> questions;

  @override
  State<ParaScreen> createState() => _ParaScreenState();
}

class _ParaScreenState extends State<ParaScreen> {
  final _key = GlobalKey<FormState>();
  bool isSubmitted = false;
  int total = 0;
  List<String> userAnswers = [];
  List<bool> isCorrect = [];

  void submit() {
    if (_key.currentState!.validate()) {
      _key.currentState!.save();
      for (int i = 0; i < widget.questions['qus']!.length; i++) {
        isCorrect[i] = isCorrectAnswer(i);
        if (isCorrect[i]) total += 2;
      }
      setState(() {
        isSubmitted = true;
      });
    }
  }

  bool isCorrectAnswer(int index) {
    double distance = 0;
    distance = StringSimilarity.compareTwoStrings(
      userAnswers[index].toLowerCase(),
      widget.questions['ans']![index].toLowerCase(),
    );
    print(distance);
    bool isCorrect = distance >= 0.5;
    print(isCorrect);
    return isCorrect;
  }

  @override
  void initState() {
    userAnswers = List.filled(widget.questions['qus']!.length, '');
    isCorrect = List.filled(widget.questions['qus']!.length, false);
    print(isCorrect);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.put(ThemeController());
    return Scaffold(
      appBar: AppBar(
        title: Text('Paragraph Writing'),
      ),
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
            Form(
              key: _key,
              child: ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                itemCount: widget.questions['qus']!.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10),
                      Text('${index + 1}. ${widget.questions['qus']![index]}',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(height: 10),
                      TextFormField(
                        enabled: !isSubmitted,
                        key: ValueKey(index),
                        maxLines: 50,
                        minLines: 4,
                        decoration: InputDecoration(
                          disabledBorder: OutlineInputBorder(
                            borderSide: !isSubmitted
                                ? BorderSide.none
                                : BorderSide(
                                    color: isCorrect[index]
                                        ? Colors.green
                                        : Colors.red),
                          ),
                          contentPadding: EdgeInsets.all(10),
                          hintText: 'Enter your answer',
                        ),
                        onTapOutside: (event) {
                          FocusScope.of(context).unfocus();
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your answer';
                          }
                          return null;
                        },
                        onSaved: (newValue) {
                          userAnswers[index] = newValue!;
                        },
                      ),
                      SizedBox(height: 10),
                      if (isSubmitted)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.check_circle,
                                  color: isCorrect[index]
                                      ? Colors.green
                                      : Colors.red,
                                ),
                                SizedBox(width: 10),
                                Text(
                                  isCorrect[index] ? 'Correct' : 'Incorrect',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: isCorrect[index]
                                        ? Colors.green
                                        : Colors.red,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Answer:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(widget.questions['ans']![index]),
                            Divider(),
                          ],
                        ),
                    ],
                  );
                },
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: isSubmitted ? null : submit,
              child: Text('Submit'),
            ),
            SizedBox(height: 10),
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
            if (isSubmitted) SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
