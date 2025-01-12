import 'package:badges/badges.dart' as badges;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:iconly/iconly.dart';
import 'package:project_app/service/Auth_service.dart';

class HomeAppBar extends StatelessWidget {

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
                "สวัสดี, R.",
                style: GoogleFonts.prompt(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.pink[400],
                ),
              ),
            ),
            Spacer(), // ดัน widgets ไปทางขวา

            // Badge สำหรับ Notification
            badges.Badge(
              badgeContent: Text(
                "3", // ตัวอย่างจำนวน notification
                style: TextStyle(color: Colors.white, fontSize: 10),
              ),
              child: InkWell(
                onTap: () {
                  Navigator.pushNamed(context, "notification");
                },
                child: Icon(
                  IconlyLight.notification,
                  color: Colors.indigo[400],
                  size: 30,
                ),
              ),
            ),

            SizedBox(width: 15), // ระยะห่างระหว่าง Icons

            // ปุ่ม Logout
            InkWell(
              onTap: () {
                // โค้ดเมื่อกด Logout (เช่น Navigator หรือ Alert Dialog)
                print("Logout tapped");
                // ตัวอย่างการไปยังหน้า Login
                signOutFromGoogle();
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
