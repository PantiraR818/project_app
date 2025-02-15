import 'dart:convert';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconly/iconly.dart';
import 'package:project_app/service/form_type.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:http/http.dart' as http;

class TestDash extends StatefulWidget {
  final int formType_id;
  const TestDash({super.key, required this.formType_id});

  @override
  _TestDashState createState() => _TestDashState();
}

class _TestDashState extends State<TestDash> {
  final PageController _pageController = PageController();
  List<Map<String, dynamic>> chartData = [];
  List<FlSpot> chartLineData = [];
  List<String> stressLevels = [];
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
          var titles = responseData2['res'][0]['title'];
          stressLevels = List<String>.from(titles.map((title) => title['t']));

          var data = responseData2['res'][0]['data'];

          chartLineData = data.map<FlSpot>((entry) {
            DateTime dateTime = DateTime.parse(entry['x']);
            double yValue = _getStressLevelValue(entry['y']);
            return FlSpot(dateTime.millisecondsSinceEpoch.toDouble(), yValue);
          }).toList();
        });
      } else {
        throw Exception('Failed to load chart data');
      }
    } catch (error) {
      print("Error fetching data: $error");
    }
  }

  double _getStressLevelValue(String stressLevel) {
    int index = stressLevels.indexOf(stressLevel);
    if (index != -1) {
      return (index + 1).toDouble();
    } else {
      return 0.0;
    }
  }

  @override
  void initState() {
    super.initState();
    fetchChartData(); // ดึงข้อมูลเมื่อ widget ถูกสร้าง
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
                child: title == "ส่วนตัว"
                    ? LineChart(
                        LineChartData(
                          gridData: FlGridData(
                            show: true, // แสดงเส้น Grid
                            drawVerticalLine: true, // เส้นแนวตั้ง
                            drawHorizontalLine: true, // เส้นแนวนอน
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
                                reservedSize: 40,
                                interval: 1,
                                getTitlesWidget: (value, meta) {
                                  // Here we display the stress level based on the y value (stress level titles)
                                  int index = value.toInt();
                                  if (index >= 0 &&
                                      index < stressLevels.length) {
                                    return Text(
                                      stressLevels[
                                          index], // Showing title from the dynamic list
                                      style: GoogleFonts.prompt(
                                        textStyle: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 10,
                                        ),
                                      ),
                                    );
                                  }
                                  return SizedBox
                                      .shrink(); // Return empty widget if index is out of range
                                },
                              ),
                            ),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, meta) {
                                  DateTime date =
                                      DateTime.fromMillisecondsSinceEpoch(
                                          value.toInt());
                                  return Padding(
                                    padding: EdgeInsets.only(top: 8),
                                    child: Text(
                                      "${date.day}/${date.month}",
                                      style: GoogleFonts.prompt(
                                        textStyle: TextStyle(
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
                                sideTitles: SideTitles(showTitles: false)),
                            rightTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: false)),
                          ),
                          borderData: FlBorderData(
                            show: true,
                            border: Border.all(
                                color: Colors.white.withOpacity(0.5), width: 1),
                          ),
                          lineTouchData: LineTouchData(
                            handleBuiltInTouches:
                                true, // ให้ Flutter จัดการการแตะ
                            touchTooltipData: LineTouchTooltipData(
                              // tooltipBgColor: Colors.black54, // สีพื้นหลังของ tooltip
                              getTooltipColor: (LineBarSpot spot) {
                                if (spot.y >= 3) {
                                  return Colors
                                      .redAccent; // ถ้าค่า y >= 3 ให้ใช้สีแดง
                                } else if (spot.y >= 2) {
                                  return Colors
                                      .orangeAccent; // ถ้าค่า y >= 2 ให้ใช้สีส้ม
                                }
                                return Colors
                                    .greenAccent; // ค่าน้อยกว่า 2 ให้ใช้สีเขียว
                              },
                              tooltipMargin: 10, // กำหนดระยะห่างของ Tooltip
                              tooltipRoundedRadius:
                                  8, // กำหนดมุมโค้งของ Tooltip
                              getTooltipItems: (touchedSpots) {
                                return touchedSpots
                                    .map((LineBarSpot touchedSpot) {
                                  double yValue = touchedSpot.y;
                                  int index = yValue.toInt() -
                                      1; // หาตำแหน่งใน stressLevels
                                  String label = (index >= 0 &&
                                          index < stressLevels.length)
                                      ? stressLevels[index]
                                      : "ไม่ทราบค่า"; // ใช้ข้อความที่ตรงกับระดับความเครียด
                                  return LineTooltipItem(
                                    label,
                                    GoogleFonts.prompt(
                                        textStyle: TextStyle(
                                            color: Colors.white, fontSize: 14)),
                                  );
                                }).toList();
                              },
                            ),
                          ),
                          lineBarsData: [
                            LineChartBarData(
                              spots: chartLineData,
                              isCurved: false, // เส้นโค้ง
                              color: Colors.white,
                              barWidth: 3,
                              belowBarData: BarAreaData(
                                show: true,
                                color: Colors.white
                                    .withOpacity(0.1), // เงาด้านล่างเส้น
                              ),
                              dotData: FlDotData(
                                show: true,
                                getDotPainter: (spot, percent, barData, index) {
                                  List<Color> dotColors = [
                                    Color(0xff16C47F),
                                    Color(0xffFFB200),
                                    Color(0xffFA812F),
                                    Color(0xffF72C5B),
                                  ];
                                  return FlDotCirclePainter(
                                    radius: 6,
                                    color: dotColors[index % dotColors.length],
                                    strokeColor: Colors.white,
                                    strokeWidth: 2,
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      )
                    : Column(
                        children: [
                          Flexible(
                            fit: FlexFit
                                .tight, // ทำให้ BarChart ใช้พื้นที่ที่เหลือ
                            child: BarChart(
                              BarChartData(
                                minY: 0, // เริ่มที่ 0
                                maxY: (chartData.isNotEmpty
                                    ? (chartData
                                            .map((e) => e['y'] as int)
                                            .toSet() // กำจัดค่าซ้ำ
                                            .reduce((a, b) => a > b ? a : b) +
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
                                        borderRadius: BorderRadius.circular(8),
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
                                      getTitlesWidget: (value, meta) => Text(
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
                                      getTitlesWidget: (value, meta) {
                                        int index = value.toInt();
                                        if (index >= 0 &&
                                            index < chartData.length) {
                                          return Text(
                                            chartData[index]['x'],
                                            style: GoogleFonts.prompt(
                                              textStyle: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          );
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
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            "คำอธิบายแสดงระดับสุขภาพใจ",
                            style: GoogleFonts.prompt(
                              textStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                          // Use SizedBox to define a fixed height for ListView
                          SizedBox(
                            height:
                                200, // กำหนดความสูงที่ต้องการให้กับ ListView
                            child: ListView.builder(
                              itemCount: chartData.length,
                              itemBuilder: (context, index) {
                                return Text(
                                  "${chartData[index]['x']}",
                                  style: GoogleFonts.prompt(
                                    textStyle: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      )),
          ],
        ),
      ),
    );
  }
}
