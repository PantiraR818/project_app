import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart'; // เพิ่ม ClipPath
import 'package:iconly/iconly.dart';

class DetailPage extends StatelessWidget {
  final String date;
  final String title1;

  const DetailPage({
    super.key,
    required this.date,
    required this.title1,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          // ClipPath สำหรับแถบสีด้านบน
          ClipPath(
            clipper: OvalBottomBorderClipper(),
            child: Container(
              height: screenHeight * 0.50, // ปรับความสูงให้เหมาะสม
              color: const Color(0xffFF6893),
            ),
          ),
          // เนื้อหาหลัก
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.05,
              vertical: 60,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // ปุ่มย้อนกลับด้านบน
                Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios_rounded,
                      size: 28,
                      color: Colors.white, // เปลี่ยนสีไอคอนให้เหมาะกับแถบสี
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                const SizedBox(height: 24), // ระยะห่างหลังปุ่ม
                // Card แสดงเนื้อหา
                SizedBox(
                  width: double.infinity, // กำหนดให้ Card มีความกว้างเต็มจอ
                  child: Card(
                    elevation: 5,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // หัวข้อแบบประเมิน
                          Text(
                            title1,
                            style: GoogleFonts.prompt(
                              fontSize: screenWidth * 0.040,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xff756EB9),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "เครียดปานกลาง",
                            style: GoogleFonts.prompt(
                              fontSize: screenWidth * 0.045,
                              fontWeight: FontWeight.w700,
                              color: Colors.orange,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "กองพัฒนานักศึกษา (กพน.)\n0-2549-3028\nคณะวิศวกรรมศาสตร์ (วศ.)\n0-2549-3400",
                            style: GoogleFonts.prompt(
                              fontSize: screenWidth * 0.035,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10,),
                SizedBox(
                  width: double.infinity, // กำหนดให้ Card มีความกว้างเต็มจอ
                  child: Card(
                    elevation: 5,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // หัวข้อแบบประเมิน
                          Text(
                            title1,
                            style: GoogleFonts.prompt(
                              fontSize: screenWidth * 0.040,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xff756EB9),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "เครียดปานกลาง",
                            style: GoogleFonts.prompt(
                              fontSize: screenWidth * 0.045,
                              fontWeight: FontWeight.w700,
                              color: Colors.orange,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "กองพัฒนานักศึกษา (กพน.)\n0-2549-3028\nคณะวิศวกรรมศาสตร์ (วศ.)\n0-2549-3400",
                            style: GoogleFonts.prompt(
                              fontSize: screenWidth * 0.035,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
