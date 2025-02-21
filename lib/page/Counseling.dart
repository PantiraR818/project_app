import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconly/iconly.dart';
import 'package:url_launcher/link.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Counseling extends StatefulWidget {
  const Counseling({super.key});

  @override
  State<Counseling> createState() => _CounselingState();
}

class _CounselingState extends State<Counseling> {
  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final double iconSize = constraints.maxWidth * 0.05;
          final double paddingSize = constraints.maxWidth * 0.05;
          final double fontSize = constraints.maxWidth > 600 ? 18 : 14;

          return Stack(
            children: [
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: ClipPath(
                  clipper: OvalBottomBorderClipper(),
                  child: Container(
                    height: constraints.maxHeight * 0.25,
                    color: const Color(0xffFF6893),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: ClipPath(
                  clipper: WaveClipperTwo(reverse: true),
                  child: Container(
                    height: constraints.maxHeight * 0.15,
                    color: const Color(0xffFF6893),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: constraints.maxHeight * 0.075,
                  horizontal: paddingSize,
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {},
                          child: Container(
                            padding: EdgeInsets.all(paddingSize * 0.4),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.white60),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Icon(
                              IconlyBold.heart,
                              color: Colors.white,
                              size: iconSize,
                            ),
                          ),
                        ),
                        Text(
                          "WELLBEING",
                          style: GoogleFonts.prompt(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: fontSize + 2,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, "home");
                          },
                          child: Container(
                            padding: EdgeInsets.all(paddingSize * 0.4),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.white60),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Icon(
                              IconlyLight.home,
                              color: Colors.white,
                              size: iconSize,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Container(
                          padding: EdgeInsets.all(paddingSize),
                          decoration: BoxDecoration(
                            color: Colors.white,
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
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Align(
                                alignment: Alignment.center,
                                child: Text(
                                  "งานบริการให้คำปรึกษา RMUTT",
                                  style: GoogleFonts.prompt(
                                    fontWeight: FontWeight.w600,
                                    fontSize: fontSize + 4,
                                    color: Colors.indigo,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              Image.asset(
                                "assets/images/Counseling.png",
                                height: constraints.maxHeight * 0.4,
                                width: constraints.maxHeight * 0.4,
                              ),
                              const SizedBox(width: 20),
                             
                              Center(
                                  child: Link(
                                      uri: Uri.parse(
                                          "https://www.facebook.com/profile.php?id=100063935491321"),
                                      target: LinkTarget.blank,
                                      builder: (context, followLink) =>
                                          TextButton(
                                            onPressed: followLink,
                                            style: TextButton.styleFrom(
                                              foregroundColor:
                                                  Colors.white, // สีตัวอักษร
                                              backgroundColor: Colors
                                                  .indigo, // สีพื้นหลังปุ่ม
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 20, vertical: 12),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(18),
                                              ),
                                            ),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment
                                                  .center, // จัดกลางในแนวตั้ง
                                              crossAxisAlignment:
                                                  CrossAxisAlignment
                                                      .center, // จัดกลางในแนวนอน
                                              children: [
                                                Icon(FontAwesomeIcons.link,
                                                    color: Colors.white,
                                                    size: 26),
                                                SizedBox(height: 8),
                                                Text(
                                                  "ติดต่อเรา & พูดคุยผ่าน Facebook",
                                                  textAlign: TextAlign.center,
                                                  style: GoogleFonts.prompt(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors
                                                        .white, // เพิ่มสีให้ตัวอักษรเป็นสีขาว
                                                  ),
                                                )
                                              ],
                                            ),
                                          )))
                            ],
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
      ),
    );
  }
}
