import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconly/iconly.dart';
import 'package:project_app/page/result.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:project_app/service/option.dart';
import 'package:project_app/service/question.dart';

class Question extends StatefulWidget {
  final int status;
  final List<Map<String, dynamic>> worry_id; 
  final int formType_id;

  const Question(
      {super.key,
      required this.status,
      required this.formType_id, 
      required this.worry_id,
      });

  @override
  State<Question> createState() => _QuestionState();

  static fromJson(json) {}

  toJson() {}
}

class _QuestionState extends State<Question> {
  String? selectedAnswer;
  List<QuestionInterface> question = [];
  List<Option> option = [];
  int currentIndex = 0;
  List<String> answers = [];
  List<Map<String, dynamic>> answersSelect = [];

  Future<void> fetchQuestionAndOption() async {
    try {
      final questionResponse = await http.get(Uri.parse(
          '${dotenv.env['URL_SERVER']}/question/getQuestion/${widget.formType_id}'));
      final optionResponse = await http.get(Uri.parse(
          '${dotenv.env['URL_SERVER']}/option/getOption/${widget.formType_id}'));

      if (questionResponse.statusCode == 200 &&
          optionResponse.statusCode == 200) {
        final questionData =
            json.decode(questionResponse.body)['res'] as List<dynamic>;
        final optionData =
            json.decode(optionResponse.body)['res'] as List<dynamic>;

        if (questionData.isNotEmpty && optionData.isNotEmpty) {
          setState(() {
            question = questionData
                .map((item) => QuestionInterface.fromJson(item))
                .toList();
            option = optionData.map((item) => Option.fromJson(item)).toList();
          });
        } else {
          print('Error: Received null data from API');
        }
      } else {
        print('Failed to load questions or options');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  Future<bool?> _showExitDialog(BuildContext context) async {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('คุณต้องการหยุดทำแบบประเมินใช่หรือไม่?',
              style: GoogleFonts.prompt(fontSize: 16)),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text('ไม่', style: GoogleFonts.prompt(fontSize: 14)),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, "home");
              },
              child: Text('ใช่', style: GoogleFonts.prompt(fontSize: 14)),
            ),
          ],
        );
      },
    );
  }

  Widget _buildAnswerOption(Option option, QuestionInterface qution) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: selectedAnswer == option.score.toString()
            ? Color(0xffFF6893)
            : Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: selectedAnswer == option.score.toString()
              ? Colors.white
              : Colors.transparent,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            option.optionName,
            style: GoogleFonts.prompt(
              textStyle: TextStyle(
                fontSize: 16,
                color: selectedAnswer == option.score.toString()
                    ? Colors.white
                    : Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Radio<String>(
            value: option.score.toString(),
            groupValue: selectedAnswer,
            onChanged: (String? newValue) {
              setState(() {
                selectedAnswer = newValue;

                if (qution.question_type == 1) {
                  if (int.parse(newValue!) == 1) {
                    newValue = (int.parse(newValue!) + 3).toString();
                  }
                  if (int.parse(newValue!) == 2) {
                    newValue = (int.parse(newValue!) + 1).toString();
                  }
                  if (int.parse(newValue!) == 3) {
                    newValue = (int.parse(newValue!) - 1).toString();
                  }
                  if (int.parse(newValue!) == 4) {
                    newValue = (int.parse(newValue!) - 3).toString();
                  }

                  if (answers.length > currentIndex) {
                    answers[currentIndex] = newValue!;
                  } else {
                    answers.add(newValue!);
                  }
                } else {
                  if (answers.length > currentIndex) {
                    answers[currentIndex] = newValue!;
                  } else {
                    answers.add(newValue!);
                  }
                }
                if (answersSelect.length > currentIndex) {
                  answersSelect[currentIndex] = {
                    'optionId': option.id,
                    'questionId': qution.id,
                  };
                } else {
                  answersSelect.add({
                    'optionId': option.id,
                    'questionId': qution.id,
                  });
                }
              });
            },
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    fetchQuestionAndOption();
    print('stauts in qu ${widget.status}');
    print('worry_id in qu ${widget.worry_id}');
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    double fontSize = screenWidth > 600 ? 18 : 16;
    double paddingSize = screenWidth > 600 ? 30 : 20;
    double iconSize = screenWidth > 600 ? 35 : 30;

    return Scaffold(
      body: Stack(
        children: [
          ClipPath(
            clipper: OvalBottomBorderClipper(),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.4,
              color: Color(0xffFF6893),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 70.0, left: 20, right: 20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        padding: EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white60),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Icon(
                          Icons.favorite_border,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        bool? exit = await _showExitDialog(context);
                        if (exit != null && exit) {
                          Navigator.pop(context);
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white60),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30),
                Column(
                  children: [
                    if (question.isNotEmpty)
                      Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              question[currentIndex].question,
                              style: GoogleFonts.prompt(
                                textStyle: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                            if (option.isNotEmpty)
                              ...option
                                  .map((option) => _buildAnswerOption(
                                      option, question[currentIndex]))
                                  .toList(),
                          ],
                        ),
                      ),
                    SizedBox(height: 15),
                    GestureDetector(
                      onTap: () {
                        if (selectedAnswer == null) {
                          // แสดงข้อความเตือนถ้ายังไม่ได้เลือกคำตอบ
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("กรุณาเลือกคำตอบก่อนดำเนินการต่อ"),
                              backgroundColor: Colors.red,
                            ),
                          );
                        } else if (currentIndex < question.length - 1) {
                          setState(() {
                            currentIndex++;
                            selectedAnswer = null; // รีเซ็ตคำตอบที่เลือก
                          });
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Result(
                                worry_id: widget.worry_id,
                                formType_id: widget.formType_id,
                                answers: answersSelect,
                                status: widget.status,
                                totalScore: answers.fold<int>(
                                  0,
                                  (sum, socre) {
                                    return sum + int.parse(socre);
                                  },
                                ),
                              ),
                            ),
                          );
                        }
                      },
                      child: Container(
                        width: double.infinity,
                        padding:
                            EdgeInsets.symmetric(vertical: 12, horizontal: 6),
                        decoration: BoxDecoration(
                          color: Color(0xffFF6893),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              currentIndex == question.length - 1
                                  ? "ดูผลลัพธ์"
                                  : "ข้อถัดไป",
                              style: GoogleFonts.prompt(
                                textStyle: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            SizedBox(width: 8),
                            Icon(
                              Icons.arrow_forward,
                              color: Colors.white,
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
