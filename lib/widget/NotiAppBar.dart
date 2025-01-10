import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';

class Notiappbar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(20),
      child: Row(
        children: [
          InkWell(
            onTap: () {
              Navigator.pushNamed(context, "home");
            },
            child: Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 25,
              color: Colors.indigo,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 20),
            child: Text(
              "แจ้งเตือน",
              style: GoogleFonts.prompt(
                  textStyle: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo)),
            ),
          ),
          Spacer(),
          // Icon(Icons.more_vert,size: 20,color: Colors.pink[400],),
        ],
      ),
    );
  }
}
