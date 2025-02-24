import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart'; // เพิ่ม ClipPath
import 'package:iconly/iconly.dart';
import 'package:intl/intl.dart';
import 'package:project_app/service/history.dart';

class Detailpage extends StatefulWidget {
  final List<HistorySave> historyDataInApi;
  final DateTime date;

  Detailpage({
    super.key,
    required this.historyDataInApi,
    required this.date,
  });

  @override
  State<Detailpage> createState() => _DetailpageState();
}

class _DetailpageState extends State<Detailpage> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Filter historyData to only show the item where the id matches
    final historyData = widget.historyDataInApi
        .where((data) => DateTime(
                data.createdAt.year, data.createdAt.month, data.createdAt.day)
            .isAtSameMomentAs(
                DateTime(widget.date.year, widget.date.month, widget.date.day)))
        .toList();

    String convertToThaiTime(DateTime inputDateTime) {
      var thaiTimeZone = Duration(hours: 7);
      var thaiTime = inputDateTime.toUtc().add(thaiTimeZone);
      var formattedTime = DateFormat('HH:mm')
          .format(thaiTime); // แปลงเป็นรูปแบบ 00:00 ถึง 23:59
      return formattedTime;
    }

    Color parseColor(String colorString) {
      // Extract the RGBA values from the color string
      final regex = RegExp(
          r'Color\(alpha:\s*(\d*\.\d+|\d+),\s*red:\s*(\d*\.\d+|\d+),\s*green:\s*(\d*\.\d+|\d+),\s*blue:\s*(\d*\.\d+|\d+),');
      final match = regex.firstMatch(colorString);

      if (match != null) {
        final alpha = (double.tryParse(match.group(1) ?? '1.0') ?? 1.0) * 255;
        final red = (double.tryParse(match.group(2) ?? '1.0') ?? 1.0) * 255;
        final green = (double.tryParse(match.group(3) ?? '1.0') ?? 1.0) * 255;
        final blue = (double.tryParse(match.group(4) ?? '1.0') ?? 1.0) * 255;

        // Return the color object
        return Color.fromARGB(
            alpha.toInt(), red.toInt(), green.toInt(), blue.toInt());
      }

      // Default color if parsing fails
      return Colors.black;
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffFF6893),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_rounded,
            size: 28,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context); // Go back to the previous screen
          },
        ),
        elevation: 0, // Optional: To remove the shadow below the AppBar
      ),
      body: Stack(
        children: [
          // ClipPath สำหรับแถบสีด้านบน
          ClipPath(
            clipper: OvalBottomBorderClipper(),
            child: Container(
              height: screenHeight * 0.50, // ปรับความสูงให้เหมาะสม
              color: const Color(0xffFF6893),
            ),
          ),
          // เนื้อหาหลัก
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.05,
              vertical: 10,
            ),
            child: ListView.builder(
              itemCount: historyData.length,
              itemBuilder: (context, index) {
                final data = historyData[index]; // ดึงข้อมูลจาก historyData

                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: SizedBox(
                    width: double.infinity, // กำหนดให้ Card มีความกว้างเต็มจอ
                    child: Card(
                      elevation: 5,
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(30.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment
                                  .spaceBetween, // ใช้เพื่อให้ไอคอนอยู่ซ้ายและข้อความอยู่ขวา
                              children: [
                                Icon(
                                  IconlyBroken
                                      .star, // หรือใช้ไอคอนที่คุณต้องการ
                                  color: Color(0xffFF6893), // เปลี่ยนสีของไอคอน
                                ),
                                Text(
                                  "เวลา ${convertToThaiTime(data.createdAt)}",
                                  style: GoogleFonts.prompt(
                                    fontSize: screenWidth * 0.045,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xffFF6893),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              data.formTypeRelation.nameType,
                              style: GoogleFonts.prompt(
                                fontSize: screenWidth * 0.043,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xff756EB9),
                              ),
                            ),
                            const SizedBox(height: 8),
                            // แสดงระดับความเครียด
                            Text(
                              data.interpreLevel,
                              style: GoogleFonts.prompt(
                                fontSize: screenWidth * 0.052,
                                fontWeight: FontWeight.w700,
                                color: parseColor(
                                    data.interpre_color), // Parse the color
                              ),
                            ),
                            const SizedBox(height: 8),
                            // แสดงข้อมูลของหลาย faculties
                            ListView.builder(
                              shrinkWrap:
                                  true, // ใช้ shrinkWrap เพื่อให้ขนาด ListView ขึ้นอยู่กับเนื้อหาภายใน
                              physics:
                                  NeverScrollableScrollPhysics(), // ปิดการเลื่อนของ ListView นี้
                              itemCount: data.concernMatch.length,
                              itemBuilder: (context, concernIndex) {
                                final concern = data.concernMatch[concernIndex];
                                final faculties =
                                    concern.matchWorryFac?.faculties;

                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${faculties?.faculties}',
                                      style: GoogleFonts.prompt(
                                        fontSize: screenWidth * 0.038,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    const SizedBox(
                                        height:
                                            4), // ระยะห่างระหว่างชื่อคณะและเบอร์โทรศัพท์
                                    if (faculties?.phone != null)
                                      ...faculties!.phone!
                                          .split(',') // Split phone numbers
                                          .map((phone) {
                                        return Text(
                                          phone
                                              .trim(), // ตัดช่องว่างที่อาจมีอยู่ในเบอร์โทรศัพท์
                                          style: GoogleFonts.prompt(
                                            fontSize: screenWidth * 0.035,
                                            color: Colors.black87,
                                          ),
                                        );
                                      }).toList(),
                                  ],
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
