import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_app/page/BasicInfo.dart';
import 'package:project_app/page/Counseling.dart';
// import 'package:project_app/widget/CategoriesWidget.dart';
import 'package:project_app/widget/HomeAppBar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:project_app/service/form_type.dart';

class Homepagecontent extends StatefulWidget {
  const Homepagecontent({super.key});

  @override
  State<Homepagecontent> createState() => _HomepagecontentState();
}

class _HomepagecontentState extends State<Homepagecontent> {

  Future<Widget> buildCategories(BuildContext context) async {
    final response = await http
        .get(Uri.parse('${dotenv.env['URL_SERVER']}/form_type/getFormType'));

    if (response.statusCode != 200) {
      throw Exception('Failed to load form types');
    }

    final List<dynamic> data = json.decode(response.body)['res'];
    final List<FormType> formTypes =
        data.map((item) => FormType.fromJson(item)).toList();

    return LayoutBuilder(
      builder: (context, constraints) {
        double screenWidth = constraints.maxWidth;
        double screenHeight = constraints.maxHeight;

        bool isIpad = screenWidth > 600;
        double imageSize = isIpad ? screenWidth * 0.35 : screenWidth * 0.3;
        double titleFontSize = isIpad ? 18 : 14;
        double subTitleFontSize = isIpad ? 16 : 12;

        return GridView.count(
          childAspectRatio: 0.68,
          physics: NeverScrollableScrollPhysics(),
          crossAxisCount: screenWidth > 600 ? 3 : 2,
          shrinkWrap: true,
          children: [
            for (int i = 0; i < formTypes.length; i++)
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
                        Container(
                          padding: EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            color: Color(0xFFFF6893),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Icon(
                            Icons.auto_awesome_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                        Icon(
                          Icons.favorite_border_rounded,
                          color: Colors.indigo[600],
                        ),
                      ],
                    ),
                    InkWell(
                      onTap: () {
                        if (formTypes[i].type == 0) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Basicinfo(
                                formType_id: formTypes[i].id,
                              ),
                            ),
                          );
                        } else if (formTypes[i].type == 1) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Counseling(),
                            ),
                          );
                        }
                      },
                      child: Container(
                        margin: EdgeInsets.all(5),
                        child: Image.asset(
                          "assets/images/result0${i + 1}.png",
                          fit: BoxFit.cover,
                        ),
                        height: imageSize,
                        width: imageSize,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(bottom: 8),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        formTypes[i].nameTypeEng,
                        style: GoogleFonts.prompt(
                          textStyle: TextStyle(
                            fontSize: subTitleFontSize,
                            color: Color(0xFF756EB9),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerRight,
                      child: Text(
                        formTypes[i].nameType,
                        textAlign: TextAlign.right,
                        style: GoogleFonts.prompt(
                          textStyle: TextStyle(
                            fontSize: titleFontSize,
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
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          // ขนาดของหน้าจอ
          double screenWidth = constraints.maxWidth;
          double screenHeight = constraints.maxHeight;

          // ใช้ MediaQuery เพื่อคำนวณขนาดพื้นที่ในหน้าจอ
          double marginHorizontal =
              screenWidth * 0.05; // การตั้งค่าระยะห่างแนวนอน
          double marginVertical =
              screenHeight * 0.02; // การตั้งค่าระยะห่างแนวตั้ง

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
                        horizontal:
                            marginHorizontal, // ปรับระยะห่างตามขนาดหน้าจอ
                      ),
                      child: Row(
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: marginHorizontal),
                            height: screenHeight *
                                0.05, // กำหนดความสูงตามขนาดหน้าจอ
                            width: screenWidth *
                                0.5, // กำหนดความกว้างตามขนาดหน้าจอ
                            child: Text(
                              "ไกด์ไลน์สำหรับคุณ",
                              style: GoogleFonts.prompt(
                                fontSize: screenWidth *
                                    0.045, // ปรับขนาดฟอนต์ตามขนาดหน้าจอ
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
              FutureBuilder<Widget>(
                future: buildCategories(context),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData) {
                    return Center(child: Text('No data available'));
                  } else {
                    return snapshot.data!;
                  }
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
