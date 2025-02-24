import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconly/iconly.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:project_app/page/DetailPage.dart';
import 'package:project_app/service/history.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../service/save_data.dart';

void main() => runApp(const MaterialApp(home: History()));

class History extends StatefulWidget {
  const History({super.key});

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  List<HistorySave> historyDataInApi = [];
  List<List<HistorySave>> groupedHistoryData = [];

  Future<void> fetchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final idStudent = prefs.getString('id_student');
    final String url =
        '${dotenv.env['URL_SERVER']}/save_data/getHistory/$idStudent';

    try {
      // Send HTTP GET request
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        // Parse JSON response into a list of HistorySave objects
        final List<dynamic> rawData = json.decode(response.body)['res'];
        final List<HistorySave> historyList =
            rawData.map((item) => HistorySave.fromJson(item)).toList();

        // Set to track unique records based on 'createdAt' date (ignores time)
        Set<String> seenRecords = Set<String>();

        // Map to group the items by their 'createdAt' date
        Map<String, List<HistorySave>> groupedMap = {};

        for (var item in historyList) {
          // Create a DateTime object with only year, month, and day (ignores time)
          DateTime dateOnly = DateTime(
              item.createdAt.year, item.createdAt.month, item.createdAt.day);

          // Use the ISO string of the date as the key to group by the date
          String uniqueKey = '${dateOnly.toIso8601String()}';

          // Always add the current item to the map under the corresponding date key
          if (!groupedMap.containsKey(uniqueKey)) {
            groupedMap[uniqueKey] = [];
          }
          // Add the item to the group, ensuring no duplicate nameTypes in the same day
          if (!groupedMap[uniqueKey]!.any((existingItem) =>
              existingItem.formTypeRelation.nameType == item.formTypeRelation.nameType)) {
            groupedMap[uniqueKey]!.add(item);
          }
        }

        // Convert the grouped map values into a list for use in the UI
        groupedHistoryData = groupedMap.values.toList();

        print('groupedHistoryData: $groupedHistoryData');
        setState(() {
          historyDataInApi.addAll(historyList);
        });
      } else {
        print("Failed to fetch history data: ${response.statusCode}");
        throw Exception('Failed to load history data');
      }
    } catch (e) {
      print("An error occurred: $e");
      throw e;
    }
  }

  @override
  void initState() {
    super.initState();
    fetchHistory();
    // getHistory(); // ดึงข้อมูลเมื่อ widget ถูกสร้าง
  }

  String formatDateWithThaiMonth(DateTime date) {
    // รายชื่อเดือนภาษาไทย
    List<String> thaiMonths = [
      "ม.ค.",
      "ก.พ.",
      "มี.ค.",
      "เม.ย.",
      "พ.ค.",
      "มิ.ย.",
      "ก.ค.",
      "ส.ค.",
      "ก.ย.",
      "ต.ค.",
      "พ.ย.",
      "ธ.ค."
    ];

    // ดึงวันที่และปี
    String day = DateFormat('dd').format(date);
    String year = DateFormat('yyyy').format(date);
    String thaiMonth = thaiMonths[date.month - 1]; // หาชื่อเดือนจากลิสต์

    // คืนค่าในรูปแบบ "dd MMM yyyy"
    return "$day $thaiMonth $year";
  }
  // String formatDateWithThaiMonth(DateTime date) {
  //   // กำหนดชื่อเดือนภาษาไทย
  //   List<String> thaiMonths = [
  //     "ม.ค.",
  //     "ก.พ.",
  //     "มี.ค.",
  //     "เม.ย.",
  //     "พ.ค.",
  //     "มิ.ย.",
  //     "ก.ค.",
  //     "ส.ค.",
  //     "ก.ย.",
  //     "ต.ค.",
  //     "พ.ย.",
  //     "ธ.ค."
  //   ];

  //   // แปลงวันที่ให้เป็น "dd-MMM-yyyy"
  //   final DateFormat dateFormat = DateFormat('dd MM yyyy');
  //   String formattedDate = dateFormat.format(date);

  //   // แปลงชื่อเดือนเป็นภาษาไทย
  //   int monthIndex =
  //       date.month - 1; // ลบ 1 เพราะเดือนเริ่มจาก 1 แต่ list เริ่มจาก 0
  //   String thaiMonth = thaiMonths[monthIndex];

  //   // เปลี่ยนเดือนใน formattedDate ให้เป็นเดือนภาษาไทย
  //   formattedDate = formattedDate.replaceFirst(
  //     DateFormat('MM').format(date),
  //     thaiMonth,
  //   );

  //   return formattedDate;
  // }

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
                          itemCount: groupedHistoryData.length,
                          itemBuilder: (context, index) {
                            final group = groupedHistoryData[
                                index]; // A list of records in this group
                            final firstItem = group
                                .first; // Get the first record of the group
                            return GestureDetector(
                              onTap: () {
                                // Navigate to DetailPage and pass the first item of the group
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Detailpage(
                                      historyDataInApi: historyDataInApi,
                                      date: firstItem.createdAt,
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
                                            // formatDateWithThaiMonth(firstItem
                                            //     .createdAt),
                                            // // Use the function to format the date
                                            formatDateWithThaiMonth(firstItem.createdAt),
                                            style: GoogleFonts.prompt(
                                              color: Colors.blue,
                                              fontSize: screenWidth * 0.040,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          const Spacer(),
                                          Icon(
                                            IconlyBroken.heart,
                                            color: Colors.pink[300],
                                            size: 26,
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      // Title
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: group.map((item) {
                                          // print('item ---===> ${item.formType.toJson()}');
                                          return Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 10),
                                            child: Text(
                                              item.formTypeRelation
                                                  .nameType, // Display the nameType for each item in the group
                                              textAlign: TextAlign
                                                  .left, // Align the text to the left
                                              style: GoogleFonts.prompt(
                                                fontSize: screenWidth * 0.045,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.black87,
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                      const SizedBox(height: 6),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      )
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
