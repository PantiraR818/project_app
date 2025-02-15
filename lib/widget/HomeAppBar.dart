import 'package:aad_oauth/aad_oauth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconly/iconly.dart';
import 'package:project_app/service/Auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeAppBar extends StatefulWidget {
  final AadOAuth oauth;
  const HomeAppBar({super.key, required this.oauth});

  @override
  State<StatefulWidget> createState() {
    return _HomeAppBar();
  }
  // void logout() {
  //   // setState(() {
  //   //   _accessToken = null;
  //   //   _userData = null;
  //   // });

  //   print("Logged out successfully.");
  // }
}

class _HomeAppBar extends State<HomeAppBar> {
  String name = '';
  Future<void> fetchUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString('name') ?? '';
    });
  }

  @override
  void initState() {
    super.initState();
    fetchUserData(); // เรียกใช้ฟังก์ชันดึงข้อมูลเมื่อเริ่มต้น
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true, // ช่วยให้ ListView ขนาดเท่ากับขนาดของเนื้อหาภายใน
      padding: EdgeInsets.all(20),
      children: [
        Row(
          children: [
            // ไอคอน Heart
            Icon(
              IconlyBroken.heart,
              color: Colors.indigo[400],
              size: 30,
            ),
            // ข้อความทักทาย
            Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text(
                "สวัสดี , $name",
                style: GoogleFonts.prompt(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.pink[400],
                ),
              ),
            ),
            Spacer(), // ดัน widgets ไปทางขวา
            SizedBox(width: 15), // ระยะห่างระหว่าง Icons
            // ปุ่ม Logout
            InkWell(
              onTap: () {
                // โค้ดเมื่อกด Logout (เช่น Navigator หรือ Alert Dialog)
                print("Logout tapped");
                logout(widget.oauth);
                // ตัวอย่างการไปยังหน้า Login
                // signOutFromGoogle();
                Navigator.pushReplacementNamed(context, "/");
              },
              child: Icon(
                IconlyBroken.logout, // ไอคอน Logout
                color: Colors.pink[400],
                size: 26,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
