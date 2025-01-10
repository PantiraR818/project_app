import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconly/iconly.dart';
import 'package:project_app/page/DetailPage.dart';

void main() => runApp(const MaterialApp(home: History()));

class History extends StatefulWidget {
  const History({super.key});

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  // Sample history data
  final List<Map<String, String>> historyData = [
    {
      "date": "Jun 10, 2024",
      "title1": "ประเมินสภาวะความเครียด (ST-5)",
    },
    {
      "date": "Jun 20, 2024",
      "title1": "ประเมินสภาวซึมเศร้า (9Q)",
    },
    {
      "date": "Jun 10, 2024",
      "title1": "ประเมินสภาวะพลังสุขภาพจิต (RQ)",
    },
    {
      "date": "Feb 12, 2023",
      "title1": "ประเมินสภาวะความเครียด (ST-5)",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            double screenHeight = constraints.maxHeight;
            double screenWidth = constraints.maxWidth;

            return Stack(
              children: [
                // Pink Background
                ClipPath(
                  clipper: OvalBottomBorderClipper(),
                  child: Container(
                    height: screenHeight * 0.25,
                    color: const Color(0xffFF6893),
                  ),
                ),
                // Content
                Padding(
                  padding: EdgeInsets.only(
                    left: screenWidth * 0.05,
                    right: screenWidth * 0.05,
                    top: screenHeight * 0.08,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header "WELLBEING"
                      Center(
                        child: Text(
                          "History",
                          style: GoogleFonts.prompt(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: screenWidth * 0.06,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // History Section

                      // List of History Cards
                      Expanded(
                        child: ListView.builder(
                          itemCount: historyData.length,
                          itemBuilder: (context, index) {
                            final item = historyData[index];
                            return GestureDetector(
                              onTap: () {
                                // นำทางไปยังหน้า DetailPage และส่งข้อมูลไป
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DetailPage(
                                      date: item['date']!,
                                      title1: item['title1']!,
                                      // title2: item['title2']!,
                                    ),
                                  ),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 12.0),
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(15),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Date and Time
                                      Row(
                                        children: [
                                          Text(
                                            item["date"]!,
                                            style: GoogleFonts.prompt(
                                              color: Colors.blue,
                                              fontSize: screenWidth * 0.035,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          const Spacer(), // เว้นพื้นที่ระหว่าง Text และ Icon
                                          Icon(IconlyBroken
                                              .heart,color: Colors.pink[300],size: 26,),
                                               // ไอคอนจะอยู่ริมขวา
                                        ],
                                      ),

                                      const SizedBox(height: 8),
                                      // Titles
                                      Text(
                                        item["title1"]!,
                                        style: GoogleFonts.prompt(
                                          fontSize: screenWidth * 0.04,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      // Text(
                                      //   item["title2"]!,
                                      //   style: GoogleFonts.prompt(
                                      //     fontSize: screenWidth * 0.04,
                                      //     fontWeight: FontWeight.w600,
                                      //     color: Colors.black87,
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
