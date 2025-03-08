import 'dart:convert';
import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_app/lineC.dart';
import 'package:project_app/service/form_type.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:http/http.dart' as http;
import 'package:fluentui_emoji_icon/fluentui_emoji_icon.dart';

class TestDash extends StatefulWidget {
  final int formType_id;
  final String formType_name;
  const TestDash(
      {super.key, required this.formType_id, required this.formType_name});

  @override
  _TestDashState createState() => _TestDashState();
}

class _TestDashState extends State<TestDash> {
  final PageController _pageController = PageController();
  List<Map<String, dynamic>> chartData = [];
  // List<FlSpot> chartLineData = [];
  List<FlSpot> chartLineData = [];
  Map<String, int> stressMapping = {};
  Map<String, dynamic> apiResponse = {};
  double maxY = 0.0;
  double minY = 0.0;

  // List<String> stressLevels = [];
  // Map<int, Map<String, double>> stressLevelMap = {};
  Set<double> shownYValues = {}; // เก็บค่า Y ที่แสดงไปแล้ว

  Future<void> fetchChartData() async {
    final pref = await SharedPreferences.getInstance();
    try {
      final response = await http.get(Uri.parse(
          '${dotenv.env['URL_SERVER']}/save_data/getResult/${widget.formType_id}'));

      final response02 = await http.get(Uri.parse(
          '${dotenv.env['URL_SERVER']}/save_data/getchart/${widget.formType_id}/${pref.getInt('id')}'));

      if (response.statusCode == 200 && response02.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final Map<String, dynamic> responseData2 = jsonDecode(response02.body);
        setState(() {
          chartData = List<Map<String, dynamic>>.from(responseData['res']);
          apiResponse.addAll(responseData2);
          // print('responseData2 -----> ${responseData2['res']}');
        });
      } else {
        throw Exception('Failed to load chart data');
      }
    } catch (error) {
      print("Error fetching data: $error");
    }
  }

  void processApiData() {
    // ดึง mapping จาก title
    final titleList = apiResponse['res'][0]['title'] as List<dynamic>;
    stressMapping = {};
    for (var entry in titleList) {
      final t = entry['t'];
      stressMapping[t['nameInterpre']] = t['min_Interpre'];
    }

    // คำนวณค่าต่ำสุดและสูงสุดจากข้อมูลที่ดึงมา
    double minDataY = stressMapping.values.isNotEmpty
        ? stressMapping.values.reduce(min).toDouble()
        : 0.0;
    double maxDataY = stressMapping.values.isNotEmpty
        ? stressMapping.values.reduce(max).toDouble()
        : 0.0;

    // ถ้าค่าต่ำสุดและค่าสูงสุดเป็น 0 ให้กำหนดค่าเริ่มต้น
    if (minDataY == 0.0 && maxDataY == 0.0) {
      print("Warning: minDataY และ maxDataY เป็น 0 กำหนดค่าดีฟอลต์");
      minDataY = 1.0;
      maxDataY = 10.0; // ปรับค่าเริ่มต้นให้มีขนาดที่มองเห็น
    }

    // ปรับ minY และ maxY
    double padding = 4.0;
    minY = (minDataY - padding).clamp(0.0, double.infinity);
    maxY = (maxDataY + padding).clamp(minY, double.infinity);

    print(
        ' y ----------------------------------------------------------> $minY');
    print(
        ' x ----------------------------------------------------------> $maxY');
    // ดึงข้อมูล data
    // ตรวจสอบ dataList ก่อนใช้งาน
    final dataList = apiResponse['res'][0]['data'] as List<dynamic>? ?? [];
    print('dataList ---------------------------->  $dataList');
    if (dataList.isEmpty) {
      print("Warning: dataList ไม่มีข้อมูล ใช้ค่าเริ่มต้นแทน");
      dataList.add({
        'x': DateTime.now().toIso8601String(), // ใช้เวลาปัจจุบัน
        'y': 'ไม่มีข้อมูล' // ข้อมูลดีฟอลต์
      });
    }

    Map<String, Map<String, dynamic>> groupedData = {};
    for (var entry in dataList) {
      DateTime dt = DateTime.parse(entry['x']);
      String dateStr =
          "${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}";
      if (!groupedData.containsKey(dateStr)) {
        groupedData[dateStr] = entry;
      } else {
        DateTime existingDt = DateTime.parse(groupedData[dateStr]!['x']);
        if (dt.isAfter(existingDt)) {
          groupedData[dateStr] = entry;
        }
      }
    }

    List<Map<String, dynamic>> processedList = groupedData.values.toList();
    processedList.sort(
        (a, b) => DateTime.parse(a['x']).compareTo(DateTime.parse(b['x'])));

    chartLineData = processedList.map((entry) {
      DateTime dt = DateTime.parse(entry['x']);
      double xValue = dt.millisecondsSinceEpoch.toDouble();
      int? mappedY = stressMapping[entry['y']];
      double yValue = (mappedY != null ? mappedY.toDouble() : 0)
          .clamp(minY, maxY)
          .toDouble();
      return FlSpot(xValue, yValue);
    }).toList();

    print(
        'chartLineData -----------------------------------------> $chartLineData');
  }

  final Map<String, FluentUiEmojiIcon> emojiMap = {
    "เครียดน้อย": FluentUiEmojiIcon(
      w: 100,
      h: 100,
      fl: Fluents.flGrinningFace,
    ),
    "เครียดปานกลาง": FluentUiEmojiIcon(
      w: 100,
      h: 100,
      fl: Fluents.flConfusedFace,
    ),
    "เครียดมาก": FluentUiEmojiIcon(
      w: 100,
      h: 100,
      fl: Fluents.flDisappointedFace,
    ),
    "เครียดมากที่สุด": FluentUiEmojiIcon(
      w: 100,
      h: 100,
      fl: Fluents.flAngryFace,
    ),
    "ซึมเศร้าระดับน้อยมาก": FluentUiEmojiIcon(
      w: 100,
      h: 100,
      fl: Fluents.flSmilingFaceWithHearts,
    ),
    "ซึมเศร้าระดับน้อย": FluentUiEmojiIcon(
      w: 100,
      h: 100,
      fl: Fluents.flGrinningFace,
    ),
    "ซึมเศร้าระดับปานกลาง": FluentUiEmojiIcon(
      w: 100,
      h: 100,
      fl: Fluents.flConfusedFace,
    ),
    "ซึมเศร้าระดับรุนแรง": FluentUiEmojiIcon(
      w: 100,
      h: 100,
      fl: Fluents.flAngryFace,
    ),
    "พลังสุขภาพจิตระดับต่ำ": FluentUiEmojiIcon(
      w: 100,
      h: 100,
      fl: Fluents.flConfusedFace,
    ),
    "พลังสุขภาพจิตระดับปกติ": FluentUiEmojiIcon(
      w: 100,
      h: 100,
      fl: Fluents.flSmilingFace,
    ),
    "พลังสุขภาพจิตระดับสูง": FluentUiEmojiIcon(
      w: 100,
      h: 100,
      fl: Fluents.flSmilingFaceWithHearts,
    ),
  };

  Future<void> fetchData() async {
    await fetchChartData(); // ดึงข้อมูลเมื่อ widget ถูกสร้าง
    processApiData();
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffffffff),
      body: Column(
        children: [
          SizedBox(height: 50),
          Row(
            children: [
              IconButton(
                icon: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Color(0xffFF6893),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, "dashfirst");
                },
              ),
              Expanded(
                child: Center(
                  child: Text(
                    'Dashboard',
                    style: GoogleFonts.prompt(
                      color: Color(0xffFF6893),
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Expanded(
            child: PageView(
              controller: _pageController,
              children: [
                _buildChartPage('ภาพรวมสุขภาพใจ', Colors.blue, Colors.cyan),
                _buildChartPage('ส่วนตัว', Colors.purple, Colors.pink),
              ],
            ),
          ),
          const SizedBox(height: 20),
          SmoothPageIndicator(
            controller: _pageController,
            count: 2,
            effect: ExpandingDotsEffect(
              activeDotColor: Colors.white,
              dotHeight: 8,
              dotWidth: 8,
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildChartPage(String title, Color color1, Color color2) {
    if (chartLineData.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    double minX = chartLineData.first.x;
    double maxX = chartLineData.last.x;
    // Map<String, int> label = stressMapping;

    print('chartData ---------------------------------> $chartData');
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color1, color2],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(2, 5),
          )
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: GoogleFonts.prompt(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
                child: title == "ส่วนตัว" && stressMapping.isNotEmpty
                    ? LineChart(
                        LineChartData(
                          gridData: FlGridData(
                            show: true, // แสดงเส้น Grid
                            drawVerticalLine: true,
                            drawHorizontalLine: true,
                            getDrawingHorizontalLine: (value) => FlLine(
                              color: Colors.white.withOpacity(0.2),
                              strokeWidth: 1,
                            ),
                            getDrawingVerticalLine: (value) => FlLine(
                              color: Colors.white.withOpacity(0.2),
                              strokeWidth: 1,
                            ),
                          ),
                          titlesData: FlTitlesData(
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                  showTitles: false,
                                  interval: 1,
                                  getTitlesWidget: (value, meta) {
                                    int intVal = value.toInt();
                                    String levelName = stressMapping.entries
                                        .firstWhere(
                                          (entry) => entry.value == intVal,
                                          orElse: () => MapEntry('ไม่ทราบ', -1),
                                        )
                                        .key;
                                    if (levelName != 'ไม่ทราบ') {
                                      return Text(
                                        levelName,
                                        style: GoogleFonts.prompt(
                                          textStyle: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 10,
                                          ),
                                        ),
                                      );
                                    }
                                    return const SizedBox.shrink();
                                  }),
                            ),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                interval:
                                    24 * 60 * 60 * 1000, // 1 วันใน milliseconds
                                getTitlesWidget: (value, meta) {
                                  double? previousValue;
                                  DateTime date =
                                      DateTime.fromMillisecondsSinceEpoch(
                                          value.toInt());

                                  // ตรวจสอบว่าเป็นค่าใหม่ที่ยังไม่เคยแสดง
                                  if (previousValue != null &&
                                      (value - previousValue!).abs() <
                                          (24 * 60 * 60 * 1000)) {
                                    return const SizedBox.shrink();
                                  }

                                  previousValue =
                                      value; // อัปเดตค่าล่าสุดที่แสดง

                                  return Padding(
                                    padding: const EdgeInsets.only(top: 8),
                                    child: Text(
                                      "${date.day}/${date.month}",
                                      style: GoogleFonts.prompt(
                                        textStyle: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                reservedSize: 30,
                              ),
                            ),
                            topTitles: AxisTitles(
                                sideTitles: SideTitles(
                              showTitles: false,
                            )),
                            rightTitles: AxisTitles(
                                sideTitles: SideTitles(
                              showTitles: false,
                            )),
                          ),
                          borderData: FlBorderData(
                            show: true,
                            border: Border.all(
                              color: Colors.white.withOpacity(0.5),
                              width: 1,
                            ),
                          ),
                          lineTouchData: LineTouchData(
                            handleBuiltInTouches: true,
                            touchTooltipData: LineTouchTooltipData(
                              getTooltipColor: (LineBarSpot spot) {
                                double range = maxY - minY;
                                double threshold1 = maxY - (range / 3);
                                double threshold2 = maxY - (range / 3) * 2;

                                if (spot.y >= threshold1) {
                                  return Colors.redAccent;
                                } else if (spot.y >= threshold2) {
                                  return Colors.orangeAccent;
                                }
                                return Colors.greenAccent;
                              },
                              tooltipMargin: 10,
                              tooltipRoundedRadius: 8,
                              getTooltipItems: (touchedSpots) {
                                return touchedSpots
                                    .map((LineBarSpot touchedSpot) {
                                  int yVal = touchedSpot.y.toInt();

                                  // ค้นหาค่าจาก mapping เพื่อแสดงชื่อระดับความเครียด
                                  String label = stressMapping.entries
                                      .firstWhere(
                                        (entry) => entry.value == yVal,
                                        orElse: () =>
                                            MapEntry('ไม่ทราบค่า', -1),
                                      )
                                      .key;

                                  return LineTooltipItem(
                                    label,
                                    GoogleFonts.prompt(
                                      textStyle: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                      ),
                                    ),
                                  );
                                }).toList();
                              },
                            ),
                          ),
                          lineBarsData: [
                            LineChartBarData(
                              spots: chartLineData,
                              isCurved: false,
                              color: Colors.white,
                              barWidth: 3,
                              belowBarData: BarAreaData(
                                show: true,
                                color: Colors.white.withOpacity(0.1),
                              ),
                              dotData: FlDotData(
                                show: true,
                                getDotPainter: (spot, percent, barData, index) {
                                  double range = maxY - minY;
                                  double threshold1 = maxY - (range / 3); // แดง
                                  double threshold2 =
                                      maxY - (range / 3) * 2; // ส้ม

                                  Color dotColor;
                                  if (spot.y >= threshold1) {
                                    dotColor = Colors.redAccent;
                                  } else if (spot.y >= threshold2) {
                                    dotColor = Colors.orangeAccent;
                                  } else {
                                    dotColor = Colors.greenAccent;
                                  }

                                  return FlDotCirclePainter(
                                    radius: 6,
                                    color: dotColor,
                                    strokeColor: Colors.white,
                                    strokeWidth: 2,
                                  );
                                },
                              ),
                            ),
                          ],
                          // กำหนดแกน x และ y
                          minX: minX,
                          maxX: maxX,
                          minY: minY,
                          maxY: maxY,
                        ),
                      )
                    : title == "ภาพรวมสุขภาพใจ"
                        ? Column(
                            children: [
                              Flexible(
                                fit: FlexFit
                                    .tight, // ทำให้ BarChart ใช้พื้นที่ที่เหลือ
                                child: BarChart(
                                  BarChartData(
                                    minY: 0,
                                    maxY: (chartData.isNotEmpty
                                        ? (chartData
                                                .map((e) => e['y'] as int)
                                                .toSet()
                                                .reduce(
                                                    (a, b) => a > b ? a : b) +
                                            2)
                                        : 10),
                                    barGroups:
                                        chartData.asMap().entries.map((entry) {
                                      int index = entry.key;
                                      var data = entry.value;
                                      return BarChartGroupData(
                                        x: index,
                                        barRods: [
                                          BarChartRodData(
                                            toY: data['y'].toDouble(),
                                            color: Colors.white,
                                            width: 16,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                        ],
                                      );
                                    }).toList(),
                                    borderData: FlBorderData(show: false),
                                    gridData: FlGridData(show: false),
                                    titlesData: FlTitlesData(
                                      leftTitles: AxisTitles(
                                        sideTitles: SideTitles(
                                          showTitles: true,
                                          interval: 1,
                                          getTitlesWidget: (value, meta) =>
                                              Text(
                                            '${value.toInt()}',
                                            style: GoogleFonts.prompt(
                                              textStyle: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      bottomTitles: AxisTitles(
                                        sideTitles: SideTitles(
                                          showTitles: true,
                                          reservedSize:
                                              55, // ขยายพื้นที่ด้านล่าง emoji จะได้ไม่ติด bar
                                          getTitlesWidget: (value, meta) {
                                            int index = value.toInt();
                                            if (index >= 0 &&
                                                index < chartData.length) {
                                              String text =
                                                  chartData[index]['x'];
                                              if (emojiMap.containsKey(text)) {
                                                return Padding(
                                                  padding: const EdgeInsets
                                                      .only(
                                                      top:
                                                          10.0), // เพิ่มระยะให้ emoji
                                                  child: emojiMap[text]!,
                                                );
                                              } else {
                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 10.0),
                                                  child: Icon(
                                                      Icons.help_outline,
                                                      color: Colors.white,
                                                      size: 20),
                                                );
                                              }
                                            }
                                            return SizedBox.shrink();
                                          },
                                        ),
                                      ),
                                      topTitles: AxisTitles(
                                          sideTitles:
                                              SideTitles(showTitles: false)),
                                      rightTitles: AxisTitles(
                                          sideTitles:
                                              SideTitles(showTitles: false)),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 4),
                              Column(
                                // mainAxisSize:
                                //     MainAxisSize.min, // ป้องกัน Column ยืดเกินไป
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "คำอธิบายแสดงระดับสุขภาพใจ",
                                    style: GoogleFonts.prompt(
                                      textStyle: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: chartData.length,
                                    itemBuilder: (context, index) {
                                      String text =
                                          "${chartData[index]['x']}"; // ค่าจาก chartData

                                      // ค้นหา Emoji จาก emojiMap โดยใช้ text ที่ได้
                                      FluentUiEmojiIcon? emoji = emojiMap[text];

                                      return Padding(
                                        padding: const EdgeInsets.only(
                                            top: 5), // ลดช่องไฟระหว่างข้อความ
                                        child: Row(
                                          children: [
                                            if (emoji != null)
                                              SizedBox(
                                                width: 30, // กำหนดขนาดของ Emoji
                                                height:
                                                    30, // กำหนดขนาดของ Emoji
                                                child: emoji,
                                              ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            // แสดงข้อความหลัง Emoji
                                            Text(
                                              text,
                                              style: GoogleFonts.prompt(
                                                textStyle: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  )
                                ],
                              ),
                            ],
                          )
                        : Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'คุณยังไม่เคยประเมินหัวข้อ ',
                                  style: GoogleFonts.prompt(
                                    textStyle: TextStyle(
                                        fontSize: 24, color: Colors.white),
                                  ),
                                ),
                                SizedBox(
                                    height: 10), // เพิ่มระยะห่างระหว่างข้อความ
                                Text(
                                  '${widget.formType_name}',
                                  style: GoogleFonts.prompt(
                                    textStyle: TextStyle(
                                        fontSize: 18, color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          )),
          ],
        ),
      ),
    );
  }
}
