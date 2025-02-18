import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ตัวอย่างข้อมูล API ที่ให้มา
final Map<String, dynamic> apiResponse = {
  "msg": "get Data Success",
  "res": [
    {
      "title": [
        {
          "t": {"nameInterpre": "ซึมน้อย", "min_Interpre": 30}
        },
        {
          "t": {"nameInterpre": "ซึมปานกลาง", "min_Interpre": 40}
        },
        {
          "t": {"nameInterpre": "ซึมมาก", "min_Interpre": 50}
        },
        {
          "t": {"nameInterpre": "ซึมมากที่สุด", "min_Interpre": 60}
        }
      ],
      "data": [
        {"x": "2025-01-29T05:52:15.000Z", "y": "ซึมมาก"},
        {"x": "2025-01-30T07:30:45.000Z", "y": "ซึมปานกลาง"},
        {"x": "2025-01-30T07:31:57.000Z", "y": "ซึมปานกลาง"},
        {"x": "2025-01-30T07:37:52.000Z", "y": "ซึมมากที่สุด"},
        {"x": "2025-02-02T07:11:30.000Z", "y": "ซึมน้อย"},
        {"x": "2025-02-02T07:28:44.000Z", "y": "ซึมมาก"},
        {"x": "2025-02-05T06:49:47.000Z", "y": "ซึมมากที่สุด"},
        {"x": "2025-02-05T08:52:07.000Z", "y": "ซึมน้อย"},
        {"x": "2025-02-05T09:40:48.000Z", "y": "ซึมน้อย"},
        {"x": "2025-02-07T16:59:07.000Z", "y": "ซึมปานกลาง"},
        {"x": "2025-02-07T18:05:37.000Z", "y": "ซึมมากที่สุด"},
        {"x": "2025-02-13T07:02:25.000Z", "y": "ซึมมากที่สุด"},
        {"x": "2025-02-13T09:40:49.000Z", "y": "ซึมมากที่สุด"},
        {"x": "2025-02-13T09:53:24.000Z", "y": "ซึมมากที่สุด"},
        {"x": "2025-02-14T07:42:09.000Z", "y": "ซึมมากที่สุด"}
      ]
    }
  ]
};

// late Map<String, int> stressMapping = {
//   'เครียดน้อย': 0,
//   'เครียดปานกลาง': 5,
//   'เครียดมาก': 8,
//   'เครียดมากที่สุด': 10,
// };

late Map<String, int> stressMapping;
String _getStressLevelName(int yValue) {
  // ใช้ stressMapping ที่ดึงจาก API เพื่อหาชื่อระดับความเครียด
  String? stressName = stressMapping.keys.firstWhere(
    (key) => stressMapping[key] == yValue,
    orElse: () => "ไม่ทราบค่า",
  );
  return stressName ?? "ไม่ทราบค่า";
}

/// Widget ที่ใช้แสดง LineChart ตาม style ที่กำหนด
class MyLineChartWidget extends StatefulWidget {
  final int? formType_id; // ใช้สำหรับ _getStressLevelName

  const MyLineChartWidget({Key? key, this.formType_id}) : super(key: key);

  @override
  State<MyLineChartWidget> createState() => _MyLineChartWidgetState();
}

class _MyLineChartWidgetState extends State<MyLineChartWidget> {
  late List<FlSpot> chartLineData;
  late Map<String, int> stressMapping;
  late double maxY;
  double minY = 0.0;
  @override
  void initState() {
    super.initState();
    processApiData();
  }

  /// ประมวลผลข้อมูล API:
  /// - ดึง mapping จาก title เพื่อแปลง nameInterpre เป็น min_Interpre
  /// - สำหรับ data ที่อยู่ในวันเดียวกัน ให้เลือก entry ที่มีเวลาล่าสุด
  /// - แปลงเป็น FlSpot โดยใช้ timestamp ของวันเป็น x และ min_Interpre เป็น y
  void processApiData() {
    // ดึง mapping จาก title
    final titleList = apiResponse['res'][0]['title'] as List<dynamic>;
    stressMapping = {};
    for (var entry in titleList) {
      final t = entry['t'];
      stressMapping[t['nameInterpre']] = t['min_Interpre'];
    }

    // กำหนด maxY จาก mapping (ในที่นี้คือค่าสูงสุด)
    maxY = stressMapping.values.reduce(max).toDouble();

    // คำนวณค่าต่ำสุดและสูงสุดจากข้อมูลที่ดึงมา
    double minDataY = stressMapping.values.reduce(min).toDouble();
    double maxDataY = stressMapping.values.reduce(max).toDouble();

    // เพิ่มหรือลดช่วงประมาณ 4 หน่วยจากค่าต่ำสุดและสูงสุดของข้อมูล
    double padding = 4.0;
    minY = (minDataY - padding).clamp(0.0, double.infinity); // ไม่ให้ต่ำกว่า 0
    maxY = (maxDataY + padding)
        .clamp(minY, double.infinity); // ไม่ให้สูงกว่า maxY ที่กำหนด

    // ดึงข้อมูล data
    final dataList = apiResponse['res'][0]['data'] as List<dynamic>;

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
  }

  @override
  Widget build(BuildContext context) {
    // กำหนดขอบเขตของแกน x จากข้อมูล chartLineData
    if (chartLineData.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    double minX = chartLineData.first.x;
    double maxX = chartLineData.last.x;

    return LineChart(
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
              interval: 24 * 60 * 60 * 1000, // 1 วันใน milliseconds
              getTitlesWidget: (value, meta) {
                double? previousValue;
                DateTime date =
                    DateTime.fromMillisecondsSinceEpoch(value.toInt());

                // ตรวจสอบว่าเป็นค่าใหม่ที่ยังไม่เคยแสดง
                if (previousValue != null &&
                    (value - previousValue!).abs() < (24 * 60 * 60 * 1000)) {
                  return const SizedBox.shrink();
                }

                previousValue = value; // อัปเดตค่าล่าสุดที่แสดง

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
              return touchedSpots.map((LineBarSpot touchedSpot) {
                int yVal = touchedSpot.y.toInt();

                // ค้นหาค่าจาก mapping เพื่อแสดงชื่อระดับความเครียด
                String label = stressMapping.entries
                    .firstWhere(
                      (entry) => entry.value == yVal,
                      orElse: () => MapEntry('ไม่ทราบค่า', -1),
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
                double threshold2 = maxY - (range / 3) * 2; // ส้ม

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
    );
  }
}
