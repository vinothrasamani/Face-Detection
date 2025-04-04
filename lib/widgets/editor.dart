import 'package:face_detection/data/formula_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:get/get.dart';

class Editor extends StatefulWidget {
  const Editor({super.key});

  @override
  State<Editor> createState() => _EditorState();
}

class _EditorState extends State<Editor> {
  List<Map<String, List<String>>> data = [];
  List<String> mostUsed = [];
  TextEditingController formulaController = TextEditingController();

  @override
  void initState() {
    data = FormulaData.formulaSymbols;
    mostUsed = FormulaData.symbols;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Create Formula!',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        TextField(
          controller: formulaController,
          decoration: InputDecoration(
            hintText: 'Formula Content',
          ),
          onSubmitted: (value) {
            formulaController.text = value;
            setState(() {});
          },
        ),
        SizedBox(height: 15),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: isDark ? Colors.black : Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withAlpha(125),
                spreadRadius: 2,
                blurRadius: 8,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Symbols',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 5),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: BouncingScrollPhysics(),
                child: Row(
                  children: [
                    for (int f = 0; f < data.length; f++)
                      Container(
                        constraints: BoxConstraints(minWidth: 140),
                        padding: EdgeInsets.only(right: 10),
                        child: PopupMenuButton(
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              child: Wrap(
                                spacing: 10,
                                runSpacing: 10,
                                children: [
                                  for (var j in data[f].values.first)
                                    TextButton(
                                      onPressed: () {
                                        formulaController.text += j;
                                        Get.back();
                                      },
                                      child: Math.tex(
                                        j,
                                        textStyle: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                          child: Container(
                            padding: EdgeInsets.all(10),
                            margin: EdgeInsets.symmetric(vertical: 2),
                            decoration: BoxDecoration(
                              color:
                                  Theme.of(context).appBarTheme.backgroundColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              data[f].keys.first,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Mostly Used',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 5),
              Container(
                margin: EdgeInsets.only(right: 10),
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      for (var s in mostUsed)
                        TextButton(
                          onPressed: () {
                            formulaController.text += s;
                            setState(() {});
                          },
                          child: Math.tex(s),
                        ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Commonly Used',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 5),
              Container(
                margin: EdgeInsets.only(right: 10),
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      for (var c in FormulaData.common)
                        TextButton(
                          onPressed: () {
                            formulaController.text += c;
                            setState(() {});
                          },
                          child: Text(c),
                        ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 5),
            ],
          ),
        ),
        SizedBox(height: 25),
        if (formulaController.text.isNotEmpty)
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 10),
            physics: BouncingScrollPhysics(),
            child: Math.tex(
              formulaController.text,
              textStyle: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        SizedBox(height: 40),
      ],
    );
  }
}
