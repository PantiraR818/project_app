import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconly/iconly.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Messagenoti extends StatefulWidget {
  final Map<String, dynamic> message;

  const Messagenoti({super.key, required this.message});

  @override
  State<Messagenoti> createState() => _MessagenotiState();
}

class _MessagenotiState extends State<Messagenoti> {
  List<Map<String, dynamic>> stressNotifications = [];
  List<Map<String, dynamic>> meetingNotifications = [];
  List<Map<String, dynamic>> allNotifications = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => checkForStressNotifications());
    _updateReaded();
  }

  Future<void> _updateReaded() async {
    final pref = await SharedPreferences.getInstance();
    final accId = pref.getInt('id');
    try {
      final response = await http.put(
          Uri.parse('${dotenv.env['URL_SERVER']}/save_data/updateRead/$accId'));

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        if (result['message'] == 'Update Success') {
          print(result['message']);
        } else if (result['message'] == 'Nothing to Update') {
          print(result['message']);
        }
      } else {
        print('error');
      }
    } catch (error) {
      print('เกิดข้อผิดพลาด: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('เกิดข้อผิดพลาด: $error')),
      );
    }
  }
void checkForStressNotifications() {
  stressNotifications.clear();
  meetingNotifications.clear();

  if (widget.message is Map<String, dynamic>) {
    // ดึงข้อมูล saveData และ meeting จาก message
    final saveData = widget.message['saveData'] ?? [];
    final meetings = widget.message['meeting'] ?? [];

    // ตรวจสอบการแจ้งเตือนจาก saveData (แบบประเมินความเครียด)
    for (var item in saveData) {
      String interpreLevel = (item['interpre_level'] ?? '').toString().trim();
      String createdAtString = item['createdAt'] ?? '';

      if (interpreLevel == 'เครียดมาก' ||
          interpreLevel == 'เครียดมากที่สุด' ||
          interpreLevel == 'ซึมเศร้าระดับปานกลาง' ||
          interpreLevel == 'ซึมเศร้าระดับรุนแรง' ||
          interpreLevel == 'พลังสุขภาพจิตระดับต่ำ') {
        DateTime createdAt =
            DateTime.tryParse(createdAtString) ?? DateTime.now();
        DateTime nextReminderDate = createdAt.add(Duration(days: 7));

        String formattedDate =
            DateFormat('dd/MM/yyyy').format(nextReminderDate);

        stressNotifications.add({
          'title': 'แจ้งเตือนการประเมินซ้ำ',
          'message01': interpreLevel,
          'message02': 'กรุณาทำแบบประเมินซ้ำในวันที่ $formattedDate',
          'date': formattedDate,
          'dateTime': createdAt, // ใช้ createdAt สำหรับการเรียง
        });
      }
    }

    // ตรวจสอบการแจ้งเตือนจาก meeting (นัดหมายการปรึกษา)
    for (var meeting in meetings) {
      String description = (meeting['description'] ?? '').toString().trim();
      String meetingDateStr = meeting['meeting_date'] ?? '';
      String startTime = meeting['start_time'] ?? '';
      String endTime = meeting['end_time'] ?? '';
      String createdAtString = meeting['createdAt'] ?? '';

      DateTime meetingDate =
          DateTime.tryParse(meetingDateStr) ?? DateTime.now();
      DateTime createdAt =
          DateTime.tryParse(createdAtString) ?? DateTime.now();

      String formattedDate = DateFormat('dd/MM/yyyy').format(meetingDate);

      meetingNotifications.add({
        'title': 'การนัดหมายปรึกษา',
        'message01': description,
        'message02': 'วันนัดหมาย: $formattedDate เวลา $startTime - $endTime',
        'date': formattedDate,
        'dateTime': createdAt, // ใช้ createdAt สำหรับการเรียง
      });
    }

    // รวมและเรียงลำดับการแจ้งเตือนจาก createdAt มาก -> น้อย
    setState(() {
      allNotifications = [...stressNotifications, ...meetingNotifications];
      allNotifications.sort((a, b) =>
          (b['dateTime'] as DateTime).compareTo(a['dateTime'] as DateTime)); // เรียงจากใหม่ไปเก่า
      isLoading = false;
    });
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header
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

            // List Notifications
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
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                    color: Color(0xffF72C5B),
                                  ),
                                ),
                                Text(
                                  item["message02"]?.toString() ??
                                      "ไม่มีข้อความ",
                                  style: GoogleFonts.prompt(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 15,
                                    color: Colors.grey[800],
                                  ),
                                ),
                              ],
                            ),
                            trailing: Text(
                              item["date"]?.toString() ?? "ไม่ระบุวันที่",
                              style: GoogleFonts.prompt(
                                fontSize: 12,
                                color: Colors.grey[800],
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
    );
  }
}
