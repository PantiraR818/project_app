import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:math'; // สำหรับสุ่มข้อมูล
import 'package:google_fonts/google_fonts.dart';
import 'package:iconly/iconly.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Result extends StatefulWidget {
  final int totalScore;
  final int? status;
  final int? formType_id;
  final int? worry_id;
  final List<Map<String, dynamic>> answers; // Added list of answers

  const Result(
      {super.key,
      required this.totalScore,
      this.status,
      this.formType_id,
      this.worry_id,
      required this.answers});

  @override
  State<Result> createState() => _ResultState();
}

class _ResultState extends State<Result> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late Color progressColor = Colors.orangeAccent;
  double progressValue = 0.0; // กำหนดค่าเริ่มต้นของ progressValue
  String id_student = '';

  String resultMessage = "กำลังโหลด...";
  int maxScoreOverall = 0;
  int minScoreOverall = 0;
  List<String> tel = [];
  List<String> fucName = [];
  List<dynamic> guidanceData = []; // รายการข้อมูลคำแนะนำที่สุ่มมา

  Future<void> _getResultMessage() async {
    String message = await fetchResult(widget.totalScore);
    setState(() {
      resultMessage = message;
    });
  }

  Future<String> fetchResult(int totalScore) async {
    try {
      final response = await http.get(Uri.parse(
          '${dotenv.env['URL_SERVER']}/interpre/getinterpre/${widget.formType_id}'));

      if (response.statusCode == 200) {
        List<dynamic> scoreRanges = json.decode(response.body)['res'];

        for (var range in scoreRanges) {
          int maxScore = range['max_Interpre'];
          if (maxScore > maxScoreOverall) {
            maxScoreOverall = maxScore; // อัปเดต maxScoreOverall
          }
        }
        print(
            "--/**/-/--------------Max Score Overall: $maxScoreOverall -------------**-*--------");
        print(
            "--/**/-/--------------Max Score totalScore: $totalScore -------------**-*--------");
// รอบที่สอง: ประมวลผลตามเงื่อนไข
        for (var range in scoreRanges) {
          int minScore = range['min_Interpre'];
          int maxScore = range['max_Interpre'];

          if (totalScore >= minScore && totalScore <= maxScore) {
            String message = range['nameInterpre'];
            double value = totalScore / maxScoreOverall; // คำนวณ progressValue
            String color = range['color_Progress'];

            // ตั้งค่าผลลัพธ์
            setState(() {
              resultMessage = message;
              progressColor = Color(int.parse(color));
              progressValue = value; // ตั้งค่า progressValue ใหม่
            });

            return message;
          }
        }
        return "ไม่พบช่วงคะแนนที่ตรงกัน";
      } else {
        throw Exception("Failed to load data");
      }
    } catch (e) {
      print("Error: $e");
      return "เกิดข้อผิดพลาด";
    }
  }

  // ฟังก์ชันดึงข้อมูลจาก API
  Future<void> fetchGuidance() async {
    try {
      final response = await http.get(Uri.parse(
          '${dotenv.env['URL_SERVER']}/guidance/getguidance/${widget.formType_id}'));
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body)["res"];
        // ถ้ามีข้อมูลที่ตรงกัน ให้สุ่มข้อมูล 1 รายการ
        if (data.isNotEmpty) {
          Random random = Random();
          int randomIndex = random.nextInt(data.length);
          setState(() {
            guidanceData = [data[randomIndex]]; // ส่งคืนข้อมูลที่สุ่ม
          });
        } else {
          setState(() {
            guidanceData = []; // ไม่มีข้อมูลที่ตรงกับ formType_id
          });
        }
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Error fetching data: $e');
    }
  }

  Future<void> fetchMatch() async {
    final response = await http.get(Uri.parse(
        '${dotenv.env['URL_SERVER']}/matchWorry_Fac/getMatchWorryandFac/${widget.worry_id}'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['res'];
      setState(() {
        for (var v in data) {
          fucName.add(v["faculties"]["faculties"]);
          tel.add(v["faculties"]["phone"].replaceAll(' , ', '\n'));
        }
      });
    } else {
      throw Exception('Failed to load form types');
    }
  }

  Future<void> fetchDataFromSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();

    // ดึงค่าจาก SharedPreferences
    setState(() {
      id_student = prefs.getString("id_student") ?? "";
    });
  }

  Future<void> saveAll() async {
    try {
      final response = await http.post(
        Uri.parse('${dotenv.env['URL_SERVER']}/save_data/save_data'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "formtype_id": widget.formType_id,
          "acc_id": id_student,
          "interpre_level": resultMessage,
          "score": widget.totalScore,
          "status_id": widget.status,
          "concern_id": widget.worry_id,
          "question_select": widget.answers.map((answer) {
            return {
              "queston_id": answer['questionId'],
              "option_id": answer['optionId'],
            };
          }).toList(), // เปลี่ยน map เป็น List ที่สามารถ encode ได้
        }),
      );
      if (response.statusCode == 200) {
        print(response.body);
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> fetchDataAndSave() async {
    await fetchDataFromSharedPreferences();
    await _getResultMessage();
    if (id_student != '') {
      saveAll();
    }
  }

  @override
  void initState() {
    super.initState();
    fetchMatch();
    fetchGuidance();
    fetchDataAndSave(); // เรียกฟังก์ชันเพื่อดึงข้อมูลตาม formType_id

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
    print('op qu --=-=-=-=-=-= ${widget.answers} -=-=-=-=-=-=-=-=');
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final double iconSize = constraints.maxWidth * 0.05;
          final double paddingSize = constraints.maxWidth * 0.05;
          final double fontSize = constraints.maxWidth > 600 ? 18 : 14;

          return Stack(
            children: [
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: ClipPath(
                  clipper: OvalBottomBorderClipper(),
                  child: Container(
                    height: constraints.maxHeight * 0.25,
                    color: const Color(0xffFF6893),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: ClipPath(
                  clipper: WaveClipperTwo(reverse: true),
                  child: Container(
                    height: constraints.maxHeight * 0.15,
                    color: const Color(0xffFF6893),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: constraints.maxHeight * 0.075,
                  horizontal: paddingSize,
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {},
                          child: Container(
                            padding: EdgeInsets.all(paddingSize * 0.4),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.white60),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Icon(
                              IconlyBold.heart,
                              color: Colors.white,
                              size: iconSize,
                            ),
                          ),
                        ),
                        Text(
                          "WELLBEING",
                          style: GoogleFonts.prompt(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: fontSize + 2,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, "home");
                          },
                          child: Container(
                            padding: EdgeInsets.all(paddingSize * 0.4),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.white60),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Icon(
                              IconlyLight.home,
                              color: Colors.white,
                              size: iconSize,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Container(
                          padding: EdgeInsets.all(paddingSize),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Align(
                                alignment: Alignment.center,
                                child: Text(
                                  "ผลการประเมิน",
                                  style: GoogleFonts.prompt(
                                    fontWeight: FontWeight.w600,
                                    fontSize: fontSize + 6,
                                    color: Colors.orangeAccent,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(
                                      color: Colors.grey.shade300, width: 1.5),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.1),
                                      spreadRadius: 2,
                                      blurRadius: 5,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AnimatedBuilder(
                                      animation: _animation,
                                      builder: (context, child) {
                                        // ตรวจสอบว่าค่าของ progressValue และ progressColor ได้ถูกตั้งค่าจากผลลัพธ์แล้ว
                                        return LinearProgressIndicator(
                                          value:
                                              progressValue, // ใช้ progressValue ที่คำนวณมา
                                          backgroundColor: Colors.grey[300],
                                          color:
                                              progressColor, // ใช้สีที่เปลี่ยนตามผลลัพธ์
                                          minHeight: 14.0,
                                          semanticsLabel: 'Progress',
                                          semanticsValue:
                                              '$progressValue', // เพิ่มข้อมูลสำหรับการเข้าถึง
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        );
                                      },
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      children: [
                                        Text(
                                          "ระดับความเสี่ยง",
                                          style: GoogleFonts.prompt(
                                            textStyle: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.black54,
                                            ),
                                          ),
                                        ),
                                        const Spacer(),
                                        Text(
                                          resultMessage,
                                          style: GoogleFonts.prompt(
                                            fontSize: 16,
                                            color: progressColor,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20),
                              Text(
                                "วิธีดูแลใจเบื้องต้น",
                                style: GoogleFonts.prompt(
                                  fontSize: fontSize + 3,
                                  color: const Color(0xffFF6893),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 5),
                              if (guidanceData.isNotEmpty)
                                Text(
                                  guidanceData[0]['guidance'] ?? 'ไม่มีคำแนะนำ',
                                  style: GoogleFonts.prompt(
                                    fontSize: fontSize,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              const SizedBox(height: 20),
                              Text(
                                "คำแนะนำหลังการประเมิน (หน่วยงานภายใน)",
                                style: GoogleFonts.prompt(
                                  fontSize: fontSize + 2,
                                  color: Colors.indigo,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 5),
                              ListView.builder(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 0.0, vertical: 2.0),
                                shrinkWrap:
                                    true, // ให้ ListView ทำงานใน Column ได้
                                physics:
                                    const NeverScrollableScrollPhysics(), // ปิดการ Scroll ของ ListView
                                itemCount: fucName.length,
                                itemBuilder: (context, index) {
                                  return Container(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize
                                          .min, // ลดระยะห่างใน Column ให้เหมาะสมกับเนื้อหา
                                      children: [
                                        Text(
                                          fucName[index] + "\n" + tel[index],
                                          style: GoogleFonts.prompt(
                                            fontSize: fontSize,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        )
                                      ],
                                    ),
                                  );
                                },
                              ),
                              // const SizedBox(height: 15),
                              Row(
                                children: [
                                  Image.asset(
                                    "assets/images/result01.png",
                                    height: constraints.maxHeight * 0.1,
                                    width: constraints.maxHeight * 0.1,
                                  ),
                                  const SizedBox(width: 20),
                                  Expanded(
                                    child: Text(
                                      "คุณสามารถขอคำแนะนำจากผู้เชี่ยวชาญที่ฝ่ายแนะแนว มทร.ธัญบุรี",
                                      style: GoogleFonts.prompt(
                                        fontSize: fontSize,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w400,
                                      ),
                                      softWrap: true,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
