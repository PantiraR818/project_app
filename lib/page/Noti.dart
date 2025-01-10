import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:project_app/widget/MassageNoti.dart';
import 'package:project_app/widget/NotiAppBar.dart';

class Noti extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Notiappbar(),
          Container(
              height: 700,
              padding: EdgeInsets.only(top: 15),
              decoration: BoxDecoration(
                  color: Color(0xFFEDECF2),
                  borderRadius: BorderRadius.only(
                    // topLeft: Radius.circular(20),
                    // topRight: Radius.circular(20),
                  )),
              child: Column(
                children: [
                  Massagenoti(),
                ],
              )),
        ],
      ),
    );
  }
}
