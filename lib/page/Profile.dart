import 'package:aad_oauth/aad_oauth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_app/page/ModifyProfile.dart';
import 'package:project_app/service/Auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  final AadOAuth oauth;
  const Profile({super.key, required this.oauth});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String name = '';
  String email = '';
  String gender = '';
  String idStudent = '';
  String faculty = '';
  String phone = '';
  String birthday = '';


  // ฟังก์ชันในการดึงข้อมูลจาก API
  Future<void> fetchUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString('name') ?? '';
      email = prefs.getString('email') ?? '';
      gender = prefs.getString('gender') ?? '';
      idStudent = prefs.getString('id_student') ?? '';
      faculty = prefs.getString('faculty') ?? '';
      phone = prefs.getString('phone') ?? '';
      birthday = prefs.getString('birthday') ?? '';
    });
  }

  @override
  void initState() {
    super.initState();
    fetchUserData(); // เรียกใช้ฟังก์ชันดึงข้อมูลเมื่อเริ่มต้น
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: LayoutBuilder(
            builder: (context, constraints) {
              // ขนาดของหน้าจอ
              double screenWidth = constraints.maxWidth;
              double screenHeight = constraints.maxHeight;

              // คำนวณขนาดของรูปภาพ (สามารถปรับอัตราส่วนได้ตามต้องการ)
              double imageSize = screenWidth *
                  0.5; // รูปภาพจะมีขนาดครึ่งหนึ่งของความกว้างหน้าจอ

              return Column(
                children: [
                  // ส่วนบนสุดพร้อม Wave
                  Stack(
                    children: [
                      ClipPath(
                        clipper: WaveClipperTwo(),
                        child: Container(
                          height: 250,
                          color: Colors.pink[100],
                        ),
                      ),
                      Align(
                        alignment: Alignment.topCenter,
                        child: Padding(
                          padding: EdgeInsets.only(top: 60),
                          child: Column(
                            children: [
                              // วงกลมรอบรูปภาพ
                              Container(
                                height:
                                    imageSize, // ใช้ค่าที่คำนวณไว้สำหรับขนาดรูปภาพ
                                width:
                                    imageSize, // ใช้ค่าที่คำนวณไว้สำหรับขนาดรูปภาพ
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: gender == "หญิง"
                                      ? Color(0xffa9d2fe) // สีสำหรับเพศหญิง
                                      : gender == "ชาย"
                                          ? Colors.brown[300] // สีสำหรับเพศชาย
                                          // ? Color(0xffffcca5) // สีสำหรับเพศชาย
                                          : gender == "LGBTQIAN+"
                                              ? Color(0xffffe5a6)
                                              // สีสำหรับ LGBTQIAN+
                                              : Color(
                                                  0xffffe5a6), // สีเริ่มต้นกรณีเพศไม่ระบุ,
                                ),
                                child: ClipOval(
                                  child: Image.asset(
                                    gender == "หญิง"
                                        ? "assets/images/avatar06.png" // รูปภาพสำหรับเพศหญิง
                                        : gender == "ชาย"
                                            ? "assets/images/avatar03.png" // รูปภาพสำหรับเพศชาย
                                            : gender == "LGBTQIAN+"
                                                ? "assets/images/avatar05.png" // รูปภาพสำหรับ LGBTQIAN+
                                                : "assets/images/avatar01.png", // รูปภาพเริ่มต้นกรณีเพศไม่ระบุ
                                    height: imageSize, // ขนาดรูปภาพ
                                    width: imageSize, // ขนาดรูปภาพ
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              Text(
                                "สวัสดี, $name",
                                style: GoogleFonts.prompt(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.pink[400],
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                email,
                                style: GoogleFonts.prompt(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.indigo[400],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                      height: 30), // ระยะห่างระหว่างส่วนบนกับข้อมูลเพิ่มเติม

                  // ข้อมูลเพิ่มเติม
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildInfoBox(context, "เพศ", gender, screenWidth),
                            _buildInfoBox(context, "รหัสนักศึกษา", idStudent,
                                screenWidth),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildInfoBox(
                                context, "คณะที่สังกัด", faculty, screenWidth),
                            _buildInfoBox(
                                context, "เบอร์ติดต่อ", phone, screenWidth),
                          ],
                        ),
                        const SizedBox(
                            height: 30), // ระยะห่างระหว่างข้อมูลและปุ่ม
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildInfoBox(context, "วันเดือนปีเกิด", birthday,
                                screenWidth),
                          ],
                        ),

                        const SizedBox(height: 30),
                        Row(
                          mainAxisAlignment:
                              MainAxisAlignment.center, // จัดให้อยู่ตรงกลาง
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Modifyprofile(
                                      email: email,
                                      name: name,
                                      gender: gender,
                                      faculty: faculty,
                                      idStudent: idStudent,
                                      phone: phone,
                                      birthday: birthday,
                                    ),
                                  ),
                                ).then((updatedData) {
                                  if (updatedData != null) {
                                    // อัปเดตข้อมูลที่หน้า 1
                                    setState(() {
                                      name = updatedData['name'];
                                      idStudent = updatedData['id_student'];
                                      birthday = updatedData['birthday'];
                                      gender = updatedData['gender'];
                                      faculty = updatedData['faculty'];
                                      phone = updatedData['phone'];
                                    });
                                  }
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xffFF6893),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                elevation: 4.0,
                                minimumSize:
                                    Size(screenWidth * 0.4, 45), // ปรับขนาดปุ่ม
                              ),
                              child: Text(
                                'แก้ไขข้อมูลส่วนตัว',
                                style: GoogleFonts.prompt(
                                  textStyle: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            const SizedBox(width: 20), // เว้นระยะระหว่างปุ่ม
                            GestureDetector(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Text(
                                      "ยืนยันการออกจากระบบ",
                                      style: GoogleFonts.prompt(),
                                    ),
                                    content: Text(
                                      "คุณต้องการออกจากระบบหรือไม่?",
                                      style: GoogleFonts.prompt(),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: Text(
                                          "ยกเลิก",
                                          style: GoogleFonts.prompt(),
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          // signOutFromGoogle();
                                          logout(widget.oauth);
                                          Navigator.pop(context);
                                          Navigator.pushReplacementNamed(
                                              context, "/");
                                        },
                                        child: Text(
                                          "ออกจากระบบ",
                                          style: GoogleFonts.prompt(),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 20),
                                decoration: BoxDecoration(
                                  color: Colors.indigo,
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
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      "ออกจากระบบ",
                                      style: GoogleFonts.prompt(
                                        textStyle: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Icon(
                                      Icons.logout,
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
              );
            },
          ),
        ),
      ),
    );
  }

  // ฟังก์ชันสำหรับสร้างกล่องข้อมูล
  Widget _buildInfoBox(
      BuildContext context, String label, String value, double screenWidth) {
    return Container(
      width: screenWidth * 0.4, // ขนาดของกล่องตามขนาดหน้าจอ
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.prompt(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: Colors.pink,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: GoogleFonts.prompt(
              fontWeight: FontWeight.w500,
              fontSize: 16,
              color: Colors.indigo,
            ),
          ),
        ],
      ),
    );
  }
}
