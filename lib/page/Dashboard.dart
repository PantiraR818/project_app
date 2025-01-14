import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconly/iconly.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Dashboard',
          style: GoogleFonts.prompt(
            textStyle: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.indigo, // กำหนดสีข้อความเป็น indigo
            ),
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white, // ตั้งค่า backgroundColor เป็นสีขาว
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded, // ใช้ไอคอนย้อนกลับ
            color: Colors.indigo, // กำหนดสีของไอคอนเป็น indigo
          ),
          onPressed: () {
            // Navigator.pushNamed(context, "dashfirst"); // ทำการย้อนกลับ
            Navigator.pushNamed(context, "dashfirst"); // ทำการย้อนกลับ
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white, // ตั้งค่าพื้นหลังของ SingleChildScrollView เป็นสีขาว
          child: Padding(
            padding: const EdgeInsets.all(26.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // กราฟที่หนึ่ง
                Text(
                  'ภาพรวมระบบ',
                  style: GoogleFonts.prompt(
                    textStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      color: Color(0xffFF6893),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 400,
                  child: BarChartSample7(dataList: [
                    const _BarData(Colors.orange, 10, 15),
                    const _BarData(Colors.green, 5, 8),
                    const _BarData(Colors.blue, 3, 6),
                    const _BarData(Colors.purple, 7, 10),
                  ]), // กราฟที่ 1
                ),
                const SizedBox(height: 20),
                // กราฟที่สอง
                // Text(
                //   'ภาพรวมระบบ (สภาวะซึมเศร้า)',
                //   style: GoogleFonts.prompt(
                //     textStyle: const TextStyle(
                //       fontSize: 18,
                //       fontWeight: FontWeight.bold,
                //       color: Color(0xffFF6893),
                //     ),
                //   ),
                // ),
                // SizedBox(
                //   height: 400,
                //   child: BarChartSample7(dataList: [
                //     const _BarData(Colors.red, 12, 14),
                //     const _BarData(Colors.yellow, 6, 9),
                //     const _BarData(Colors.cyan, 4, 5),
                //     const _BarData(Colors.teal, 8, 11),
                //   ]), // กราฟที่ 2
                // ),
                // const SizedBox(height: 20),
                // // กราฟที่สาม
                // Text(
                //   'ภาพรวมระบบ (พลังสุขภาพจิต)',
                //   style: GoogleFonts.prompt(
                //     textStyle: const TextStyle(
                //       fontSize: 18,
                //       fontWeight: FontWeight.bold,
                //       color: Color(0xffFF6893),
                //     ),
                //   ),
                // ),
                // SizedBox(
                //   height: 400,
                //   child: BarChartSample7(dataList: [
                //     const _BarData(Colors.pink, 9, 13),
                //     const _BarData(Colors.indigo, 3, 7),
                //     const _BarData(Colors.brown, 1, 3),
                //     const _BarData(Colors.amber, 6, 9),
                //   ]), // กราฟที่ 3
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// กราฟที่หนึ่ง (และใช้ร่วมกับกราฟที่ 2 และ 3)
class BarChartSample7 extends StatefulWidget {
  final List<_BarData> dataList;
  const BarChartSample7({super.key, required this.dataList});

  final shadowColor = const Color(0xFFCCCCCC);

  @override
  State<BarChartSample7> createState() => _BarChartSample7State();
}

class _BarChartSample7State extends State<BarChartSample7> {
  int touchedGroupIndex = -1;

  BarChartGroupData generateBarGroup(
    int x,
    Color color,
    double value,
    double shadowValue,
  ) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: value,
          color: color,
          width: 16,
        ),
        // BarChartRodData(
        //   toY: shadowValue,
        //   color: widget.shadowColor,
        //   width: 12,
        // ),
      ],
      showingTooltipIndicators: touchedGroupIndex == x ? [0] : [],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceBetween,
        borderData: FlBorderData(
          show: true,
          border: Border.symmetric(
            horizontal: BorderSide(
              color: Colors.grey.withOpacity(0.2),
            ),
          ),
        ),
        titlesData: FlTitlesData(
          show: true,
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              getTitlesWidget: (value, meta) {
                return Text(
                  value.toInt().toString(),
                  style: GoogleFonts.poppins(fontSize: 12),
                );
              },
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 36,
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                return SideTitleWidget(
                  axisSide: meta.axisSide,
                  child: _IconWidget(
                    color: widget.dataList[index].color,
                    isSelected: touchedGroupIndex == index,
                  ),
                );
              },
            ),
          ),
        ),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          getDrawingHorizontalLine: (value) => FlLine(
            color: Colors.grey.withOpacity(0.2),
            strokeWidth: 1,
          ),
        ),
        barGroups: widget.dataList.asMap().entries.map((e) {
          final index = e.key;
          final data = e.value;
          return generateBarGroup(
            index,
            data.color,
            data.value,
            data.shadowValue,
          );
        }).toList(),
        maxY: 20,
        barTouchData: BarTouchData(
          enabled: true,
          touchTooltipData: BarTouchTooltipData(
            getTooltipColor: (group) => Colors.transparent,
            tooltipMargin: 0,
            getTooltipItem: (
              BarChartGroupData group,
              int groupIndex,
              BarChartRodData rod,
              int rodIndex,
            ) {
              return BarTooltipItem(
                rod.toY.toString(),
                TextStyle(
                  fontWeight: FontWeight.bold,
                  color: rod.color,
                  fontSize: 18,
                ),
              );
            },
          ),
          touchCallback: (event, response) {
            if (event.isInterestedForInteractions &&
                response != null &&
                response.spot != null) {
              setState(() {
                touchedGroupIndex = response.spot!.touchedBarGroupIndex;
              });
            } else {
              setState(() {
                touchedGroupIndex = -1;
              });
            }
          },
        ),
      ),
    );
  }
}

class _BarData {
  const _BarData(this.color, this.value, this.shadowValue);
  final Color color;
  final double value;
  final double shadowValue;
}

class _IconWidget extends ImplicitlyAnimatedWidget {
  const _IconWidget({
    required this.color,
    required this.isSelected,
  }) : super(duration: const Duration(milliseconds: 300));

  final Color color;
  final bool isSelected;

  @override
  ImplicitlyAnimatedWidgetState<ImplicitlyAnimatedWidget> createState() =>
      _IconWidgetState();
}

class _IconWidgetState extends AnimatedWidgetBaseState<_IconWidget> {
  Tween<double>? _rotationTween;

  @override
  Widget build(BuildContext context) {
    final rotation = math.pi * 4 * _rotationTween!.evaluate(animation);
    final scale = 1 + _rotationTween!.evaluate(animation) * 0.5;
    return Transform(
      transform: Matrix4.rotationZ(rotation).scaled(scale, scale),
      origin: const Offset(14, 14),
      child: Icon(
        widget.isSelected ? Icons.face_retouching_natural : Icons.face,
        color: widget.color,
        size: 28,
      ),
    );
  }

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _rotationTween = visitor(
      _rotationTween,
      widget.isSelected ? 1.0 : 0.0,
      (dynamic value) => Tween<double>(begin: value as double, end: widget.isSelected ? 1.0 : 0.0),
    ) as Tween<double>?;
  }
}
