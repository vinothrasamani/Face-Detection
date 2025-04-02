import 'package:face_detection/controller/getx/theme_controller.dart';
import 'package:face_detection/controller/getx/user_controller.dart';
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
    setState(() {
      isSubmitted = true;
    });
  }

  void enterAnswer(int index, String qus) async {
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
                  hintStyle: TextStyle(fontSize: 11)),
              onChanged: (value) {
                answers[index] = value;
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
    isCorrect[index] = answers[index] == widget.dataItems['answers']![index];
    print(isCorrect);
    setState(() {});
  }

  @override
  void initState() {
    answers = List.filled(widget.dataItems['questions']!.length, '');
    isCorrect = List.filled(widget.dataItems['questions']!.length, false);
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
            Text(
              'Questions',
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
                                  : () {
                                      enterAnswer(index, question);
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
                                          fontWeight: !isSubmitted
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                          decoration: answers[index] != '' &&
                                                  !isSubmitted
                                              ? TextDecoration.underline
                                              : null,
                                          color: !isSubmitted
                                              ? isDark
                                                  ? Colors.white
                                                  : Colors.black
                                              : Colors.green),
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
