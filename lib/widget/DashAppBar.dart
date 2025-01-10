import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconly/iconly.dart';

class Dashappbar extends StatelessWidget {
  const Dashappbar({super.key});

  @override
  Widget build(BuildContext context) {
   return ListView(
      shrinkWrap: true,  // ช่วยให้ ListView ขนาดเท่ากับขนาดของเนื้อหาภายใน
      padding: EdgeInsets.all(20),
      children: [
        Row(
          children: [
            Icon(
              IconlyBroken.heart,
              color: Colors.indigo[400],
              size: 30,
            ),
            Padding(
              padding: EdgeInsets.only(
                left: 10,
              ),
              child: Text(
                "สวัสดี, R.",
                style: GoogleFonts.prompt(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.pink[400]),
              ),
            ),
            Spacer(),
            badges.Badge(
              badgeContent: Text(
                "3",
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
          ],
        ),
        // เพิ่ม Widgets อื่นๆ ที่จะใช้ใน AppBar ได้ที่นี่
        // CategoriesWidget()
      ],
    );
  }
}
