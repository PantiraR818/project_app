import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_app/page/BasicInfo.dart';
import 'package:http/http.dart' as http;
import 'package:project_app/page/Counseling.dart';
import 'dart:convert';

import 'package:project_app/service/form_type.dart';
// รายการชื่อแบบทดสอบ

class Categorieswidget extends StatefulWidget {
  const Categorieswidget({super.key});

  @override
  State<Categorieswidget> createState() => _CategorieswidgetState();
}

class _CategorieswidgetState extends State<Categorieswidget> {
  List<FormType> formTypes = [];

  Future<void> fetchFormTypes() async {
    final response = await http
        .get(Uri.parse('${dotenv.env['URL_SERVER']}/form_type/getFormType'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['res'];
      print("_______________________type______________________ $data");
      setState(() {
        formTypes = data.map((item) => FormType.fromJson(item)).toList();
      });
    } else {
      throw Exception('Failed to load form types');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchFormTypes(); // ดึงข้อมูลเมื่อ widget ถูกสร้าง
  }

  @override
  Widget build(BuildContext context) {
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
            for (int i = 0;
                i < formTypes.length;
                i++) // ใช้ formTypes แทน titles
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
                        // นำข้อมูล formType ไปยังหน้า Basicinfo
                        if (formTypes[i].type == 0) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Basicinfo(
                                formType_id: formTypes[i].id,
                              ),
                            ),
                          );
                        }else if (formTypes[i].type == 1){
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Counseling(  // แก้ตรงนี้เป็นหน้าใหม่ คลินิกกำลังใจ
                              ),
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
                        formTypes[i]
                            .nameTypeEng, // ใช้ nameTypeEng จาก formTypes
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
                        formTypes[i].nameType, // ใช้ nameType จาก formTypes
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
}
