import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconly/iconly.dart';
import 'package:project_app/page/Question.dart';
import 'package:project_app/service/basic_worry.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Basicinfo02 extends StatefulWidget {
  final int status;
  final int formType_id;
  const Basicinfo02(
      {super.key, required this.status, required this.formType_id});

  @override
  State<Basicinfo02> createState() => _Basicinfo02State();
}

class _Basicinfo02State extends State<Basicinfo02> {
  // สถานะของ Checkbox
  List<BasicWorry> basicworry = [];

  List<bool> selectedOptions = [];
  List<Map<String, dynamic>> selectedItems = [];

  Future<void> fetchBasicWorry() async {
    final response = await http.get(
        Uri.parse('${dotenv.env['URL_SERVER']}/basic_worry/getBasicworry'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['res'];
      setState(() {
        basicworry = data.map((item) => BasicWorry.fromJson(item)).toList();
        selectedOptions = List.generate(basicworry.length, (index) => false);
      });
      print('--=-=-=-=-=-=> ${basicworry.map((v) => v.nameWorry)}');
    } else {
      throw Exception('Failed to load form types');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchBasicWorry(); // ดึงข้อมูลเมื่อ widget ถูกสร้าง
    print('status ----.> ${widget.status}');
    // print('$basicworry ----->');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            double screenHeight = constraints.maxHeight;
            double screenWidth = constraints.maxWidth;

            return Stack(
              children: [
                for (int i = 0; i < basicworry.length; i++)
                  // Background ClipPath
                  ClipPath(
                    clipper: OvalBottomBorderClipper(),
                    child: Container(
                      height: screenHeight * 0.5,
                      color: const Color(0xffFF6893),
                    ),
                  ),
                // เนื้อหา
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.08,
                    vertical: screenHeight * 0.03,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildCircularButton(
                            onTap: () => Navigator.pop(context),
                            icon: IconlyLight.arrow_left,
                          ),
                          Text(
                            "WELLBEING",
                            style: GoogleFonts.prompt(
                              fontSize: screenWidth * 0.05,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          _buildCircularButton(
                            onTap: () => Navigator.pushNamed(context, "home"),
                            icon: Icons.close,
                          ),
                        ],
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      Center(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            vertical: screenHeight * 0.01,
                            horizontal: screenWidth * 0.08,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Text(
                            "คุณกังวลเรื่องอะไรอยู่",
                            style: GoogleFonts.prompt(
                              color: Colors.orangeAccent,
                              fontSize: screenWidth * 0.05,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      Center(
                        child: Container(
                          child: Text(
                            "*** โปรดเลือก Icon รูปหัวใจ ***",
                            style: GoogleFonts.prompt(
                              color: Colors.white,
                              fontSize: screenWidth * 0.035,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      // ตัวเลือก
                      Expanded(
                        child: ListView.builder(
                          itemCount: basicworry.length,
                          itemBuilder: (context, index) {
                            return _buildAnswerOption(
                              basicworry[index].nameWorry,
                              basicworry[index].nameWorryEng,
                              index,
                              screenWidth,
                              screenHeight,
                            );
                          },
                        ),
                      ),
                      // ปุ่มถัดไป
                      ElevatedButton(
                        onPressed: () {
                          for (int i = 0; i < selectedOptions.length; i++) {
                            if (selectedOptions[i]) {
                              selectedItems.add({
                                'match_id': basicworry[i].id
                              }); // เพิ่ม Map เข้าไปใน List
                            }
                          }
                          print("Selected: $selectedItems");
                          Navigator.pushNamed(context, "question");
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Question(
                                formType_id: widget.formType_id,
                                status: widget.status,
                                worry_id: selectedItems,
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xffFF6893),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          minimumSize:
                              Size(double.infinity, screenHeight * 0.07),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "ถัดไป",
                              style: GoogleFonts.prompt(
                                color: Colors.white,
                                fontSize: screenWidth * 0.045,
                              ),
                            ),
                            const SizedBox(width: 10),
                            const Icon(
                              IconlyLight.arrow_right_2,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildAnswerOption(String title, String subtitle, int index,
      double screenWidth, double screenHeight) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: screenHeight * 0.005),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: const Color(0xffFFBFD2),
            child: const Icon(
              IconlyLight.category,
              color: Color(0xffFF6893),
            ),
          ),
          title: Text(
            title,
            style: GoogleFonts.prompt(
              fontSize: screenWidth * 0.04,
              fontWeight: FontWeight.w500,
            ),
          ),
          subtitle: Text(
            subtitle,
            style: GoogleFonts.prompt(
              fontSize: screenWidth * 0.035,
              color: Colors.black54,
            ),
          ),
          trailing: GestureDetector(
            onTap: () {
              setState(() {
                selectedOptions[index] = !selectedOptions[index];
              });
            },
            child: Icon(
              selectedOptions[index] ? Icons.favorite : Icons.favorite_border,
              color: selectedOptions[index]
                  ? const Color(0xffFF6893)
                  : Colors.grey,
              size: screenWidth * 0.08,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCircularButton({
    required void Function() onTap,
    required IconData icon,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white60),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Icon(
          icon,
          color: Colors.white,
        ),
      ),
    );
  }
}
