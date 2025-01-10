import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconly/iconly.dart';
import 'package:project_app/widget/DashAppBar.dart';
import 'package:project_app/widget/HomeAppBar.dart'; // นำเข้า DashAppBar

List<String> titles = [
  "สภาวะความเครียด",
  "สภาวะซึมเศร้า",
  "สภาวะพลังสุขภาพจิต"
];

List<String> titlessub = [
  "Stress Test Questionnaire",
  "Nine Patient Health Questionnaire",
  "Resilience Quotient"
];

class Dashboardfirst extends StatefulWidget {
  const Dashboardfirst({super.key});

  @override
  State<Dashboardfirst> createState() => _DashboardfirstState();
}

class _DashboardfirstState extends State<Dashboardfirst> {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'ดูผลรวมของสุขภาพใจกันเถอะ',
          style: GoogleFonts.prompt(
            textStyle: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w400,
              color: Color(0xffFF6893), // กำหนดสีข้อความเป็น indigo
            ),
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white, // ตั้งค่า backgroundColor เป็นสีขาว
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded, // ใช้ไอคอนย้อนกลับ
            color: Colors.indigo, // กำหนดสีของไอคอนเป็น indigo
          ),
          onPressed: () {
            Navigator.pushNamed(context, "home"); // ทำการย้อนกลับ
          },
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          double screenWidth = constraints.maxWidth;
          double screenHeight = constraints.maxHeight;

          // ตรวจสอบขนาดหน้าจอเพื่อปรับขนาด
          bool isIpad = screenWidth > 600; // iPad มีความกว้างมากกว่า 600px
          double imageSize =
              isIpad ? screenWidth * 0.35 : screenWidth * 0.3; // ปรับขนาดรูปภาพ
          double titleFontSize = isIpad ? 18 : 14; // ปรับขนาดฟอนต์ของชื่อเรื่อง
          double subTitleFontSize = isIpad ? 16 : 12; // ปรับขนาดฟอนต์ของคำบรรยาย

          return Column(
            children: [
              // เพิ่ม ClipPath ด้านบนของหน้าจอ
              // ClipPath(
              //     clipper: WaveClipperTwo(),
              //     child: Container(
              //       height: screenHeight * 0.15,
              //       color: const Color(0xffFF6893),
              //     ),
              //   ),
              // ส่วนของ GridView ที่แสดงข้อมูลด้านล่าง
              Expanded(
                
                child: GridView.count(
                  childAspectRatio: 0.75,
                  physics: NeverScrollableScrollPhysics(),
                  crossAxisCount: screenWidth > 600
                      ? 3
                      : 2, // 3 คอลัมน์สำหรับ iPad, 2 คอลัมน์สำหรับมือถือ
                  shrinkWrap: true,
                  children: [
                    for (int i = 0; i < titles.length; i++) // วนลูปแสดงผลข้อมูล
                      Container(
                        padding: EdgeInsets.only(left: 15, right: 15, top: 10),
                        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 4,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Icon(
                                  Icons.favorite_border_rounded,
                                  color: Colors.indigo[600],
                                ),
                              ],
                            ),
                            InkWell(
                              onTap: () {
                                // Navigator.pushNamed(context, "question");
                                Navigator.pushNamed(context, "dash");
                              },
                              child: Container(
                                margin: EdgeInsets.all(5),
                                child: Image.asset(
                                  "assets/images/result0${i + 4}.png", // ใช้ i + 1 เพื่อให้สัมพันธ์กับชื่อไฟล์
                                  fit: BoxFit.cover,
                                ),
                                height: imageSize, // ปรับขนาดรูปภาพตามขนาดหน้าจอ
                                width: imageSize, // ปรับขนาดรูปภาพตามขนาดหน้าจอ
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(bottom: 8),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                titlessub[i], // ใช้ข้อมูลจาก titlessub
                                style: GoogleFonts.prompt(
                                  textStyle: TextStyle(
                                    fontSize: subTitleFontSize, // ปรับขนาดฟอนต์
                                    color: Color(0xFF756EB9),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              alignment: Alignment.centerRight,
                              child: Text(
                                titles[i], // ใช้ข้อมูลจาก titles
                                textAlign: TextAlign.right, // จัดข้อความชิดขวา
                                style: GoogleFonts.prompt(
                                  textStyle: TextStyle(
                                    fontSize: titleFontSize, // ปรับขนาดฟอนต์
                                    color: Color(0xFFF7507B),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
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
    );
  }
}
