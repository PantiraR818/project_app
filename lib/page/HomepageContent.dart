import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_app/widget/CategoriesWidget.dart';
import 'package:project_app/widget/HomeAppBar.dart';

class Homepagecontent extends StatefulWidget {
  const Homepagecontent({super.key});

  @override
  State<Homepagecontent> createState() => _HomepagecontentState();
}

class _HomepagecontentState extends State<Homepagecontent> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          // ขนาดของหน้าจอ
          double screenWidth = constraints.maxWidth;
          double screenHeight = constraints.maxHeight;

          // ใช้ MediaQuery เพื่อคำนวณขนาดพื้นที่ในหน้าจอ
          double marginHorizontal = screenWidth * 0.05; // การตั้งค่าระยะห่างแนวนอน
          double marginVertical = screenHeight * 0.02; // การตั้งค่าระยะห่างแนวตั้ง

          return ListView(
            children: [
              HomeAppBar(),
              Container(
                padding: EdgeInsets.only(top: 5),
                color: Colors.white,
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.symmetric(
                        vertical: marginVertical, // ปรับระยะห่างตามขนาดหน้าจอ
                        horizontal: marginHorizontal, // ปรับระยะห่างตามขนาดหน้าจอ
                      ),
                      child: Row(
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: marginHorizontal),
                            height: screenHeight * 0.05, // กำหนดความสูงตามขนาดหน้าจอ
                            width: screenWidth * 0.5, // กำหนดความกว้างตามขนาดหน้าจอ
                            child: Text(
                              "ไกด์ไลน์สำหรับคุณ",
                              style: GoogleFonts.prompt(
                                fontSize: screenWidth * 0.045, // ปรับขนาดฟอนต์ตามขนาดหน้าจอ
                                fontWeight: FontWeight.w400,
                                color: Colors.indigo[300],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Categorieswidget(),
            ],
          );
        },
      ),
    );
  }
}
