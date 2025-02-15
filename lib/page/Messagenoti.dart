import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconly/iconly.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class Messagenoti extends StatefulWidget {
  final List<dynamic> message;

  const Messagenoti({super.key, required this.message});

  @override
  State<Messagenoti> createState() => _MessagenotiState();
}

class _MessagenotiState extends State<Messagenoti> {
  List<Map<String, dynamic>> stressNotifications = [];
  List<Map<String, dynamic>> allNotifications = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => checkForStressNotifications());
  }

void checkForStressNotifications() {
  stressNotifications.clear();

  for (var item in widget.message) {
    String interpreLevel = (item['interpre_level'] ?? '').toString().trim();
    String createdAtString = item['createdAt'] ?? ''; // ดึงค่าที่สร้าง

    if (interpreLevel == 'เครียดมาก' ||
        interpreLevel == 'เครียดมากที่สุด' ||
        interpreLevel == 'ซึมเศร้าระดับปานกลาง' ||
        interpreLevel == 'ซึมเศร้าระดับรุนแรง' ||
        interpreLevel == 'พลังสุขภาพจิตระดับต่ำ') {
      
      // แปลง createdAt เป็น DateTime
      DateTime createdAt = DateTime.tryParse(createdAtString) ?? DateTime.now();
      DateTime nextReminderDate = createdAt.add(Duration(days: 7)); // บวก 7 วันจาก createdAt

      String formattedDate = DateFormat('dd/MM/yyyy').format(nextReminderDate);

      stressNotifications.add({
        'title': 'แจ้งเตือนการประเมินซ้ำ',
        'message01': '$interpreLevel',
        'message02': 'กรุณาทำแบบประเมินซ้ำในวันที่ $formattedDate',
        'date': formattedDate,
      });
    }
  }

  setState(() {
    allNotifications = [...stressNotifications];
    isLoading = false;
  });
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Row(
                children: [
                  InkWell(
                    onTap: () =>
                        Navigator.pushReplacementNamed(context, "home"),
                    child: Icon(
                      IconlyBroken.arrow_left,
                      color: Colors.indigo[400],
                      size: 30,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    "แจ้งเตือน",
                    style: GoogleFonts.prompt(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: Colors.pink[400],
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    IconlyLight.heart,
                    color: Color(0xffFF6893),
                    size: 30,
                  ),
                ],
              ),
            ),
            Expanded(
              child: isLoading
                  ? Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: allNotifications.length,
                      itemBuilder: (context, index) {
                        final item = allNotifications[index];

                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 3,
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            leading: Icon(
                              IconlyBroken.calendar,
                              color: Colors.indigo[400],
                              size: 28,
                            ),
                            title: Text(
                              item["title"]?.toString() ?? "ไม่มีข้อความ",
                              style: GoogleFonts.prompt(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item["message01"]?.toString() ??
                                      "ไม่มีข้อความ",
                                  style: GoogleFonts.prompt(
                                      fontWeight: FontWeight.w500,fontSize: 16, color: Color(0xffF72C5B)),
                                ),
                                Text(
                                  item["message02"]?.toString() ??
                                      "ไม่มีข้อความ",
                                  style: GoogleFonts.prompt(
                                      fontWeight: FontWeight.w400,fontSize: 15, color: Colors.grey[800]),
                                ),
                              ],
                            ),
                            // trailing: Text(
                            //   item["date"]?.toString() ?? "ไม่ระบุวันที่",
                            //   style: GoogleFonts.prompt(
                            //       fontSize: 12, color: Colors.grey[800]),
                            // ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
