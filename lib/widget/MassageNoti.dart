import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';

class Massagenoti extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (int i = 1; i < 5; i++)
          Container(
            height: 80,
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 2.0),
                ),
                Image.asset("assets/images/menu04.png"),
                // Icon(Icons.arrow_circle_right_outlined,
                // size: 30,
                // color: Colors.pink[300],),
                // Spacer(),
                Container(
                  height: 60,
                  width: 240,
                  margin: EdgeInsets.only(right: 10),
                  alignment: Alignment.center,
                  child: Text(
                    "กรุณาเข้ามาทำแบบทดสอบหลังจากนี้ 7 วัน",
                    style: GoogleFonts.prompt(
                      textStyle:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                    textAlign: TextAlign.start, // จัดข้อความให้อยู่กลาง
                    softWrap: true, // ให้ตัดข้อความและขึ้นบรรทัดใหม่
                    overflow: TextOverflow.visible, // ให้ข้อความที่เกินแสดง
                  ),
                ),
              ],
            ),
          )
      ],
    );
  }
}
