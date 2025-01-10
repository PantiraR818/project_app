import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconly/iconly.dart';
import 'package:project_app/page/BasicInfo02.dart';
import 'package:project_app/service/status_user.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Basicinfo extends StatefulWidget {
  // final String status;
  final int formType_id;
  const Basicinfo({
    super.key,
    required this.formType_id
  });

  @override
  State<Basicinfo> createState() => _BasicinfoState();
}

class _BasicinfoState extends State<Basicinfo> {
  int? _selectedIndex;
  List<StatusUser> statusUser = [];
  String statusName = '';

  Future<void> fetchStatusUser() async {
    final response = await http.get(
        Uri.parse('${dotenv.env['URL_SERVER']}/status_user/getStatusUser'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['res'];
      setState(() {
        statusUser = data.map((item) => StatusUser.fromJson(item)).toList();
      });
    } else {
      throw Exception('Failed to load form types');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchStatusUser(); // ดึงข้อมูลเมื่อ widget ถูกสร้าง
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              children: [
                for (int i = 0; i < statusUser.length; i++)
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: ClipPath(
                      clipper: WaveClipperTwo(),
                      child: Container(
                        height: constraints.maxHeight * 0.5,
                        color: const Color(0xffFF6893),
                      ),
                    ),
                  ),
                Padding(
                  padding:
                      const EdgeInsets.only(top: 40.0, left: 20.0, right: 20.0),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {
                                // Navigator.pushNamed(context, "home");
                              },
                              child: Icon(
                                IconlyLight.heart,
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                            Text(
                              "WELLBEING",
                              style: GoogleFonts.prompt(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 22,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, "home");
                              },
                              child: Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.white60),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Icon(
                                  IconlyLight.home,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),
                        Container(
                          padding: const EdgeInsets.all(14),
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
                                  "สถานะข้อมูลเบื้องต้นก่อนเข้ารับการประเมิน",
                                  // widget.selectTopic,
                                  // "ข้อมูลเบื้องต้นก่อนเข้ารับการประเมิน",
                                  style: GoogleFonts.prompt(
                                    textStyle: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                      color: Colors.orangeAccent,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              ListView.builder(
                                shrinkWrap: true,
                                itemCount: (statusUser.length / 2).ceil(),
                                itemBuilder: (context, rowIndex) {
                                  int firstIndex = rowIndex * 2;
                                  int secondIndex = firstIndex + 1;

                                  return Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 10.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        if (firstIndex < statusUser.length)
                                          _buildColumnItem(firstIndex),
                                        if (secondIndex < statusUser.length)
                                          _buildColumnItem(secondIndex),
                                      ],
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(height: 20),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, "basicinfo02");
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Basicinfo02(
                                        formType_id: widget.formType_id,
                                        status: statusName,
                                      ),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF756EB9),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "ถัดไป",
                                      style: GoogleFonts.prompt(
                                        color: Colors.white,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    const Icon(
                                      IconlyLight.arrow_right_2,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildColumnItem(int index) {
    bool isSelected = _selectedIndex == index;
    double screenWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
          statusName = statusUser[index].status;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeInOut,
        width: screenWidth * 0.4,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? Colors.pink[100] : Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: isSelected ? const Color(0xffFF6893) : Colors.grey.shade300,
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Color(0xffFF6893),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    IconlyBold.heart,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ],
            ),
            InkWell(
              onTap: () {},
              child: Container(
                margin: const EdgeInsets.all(5),
                child: Image.asset(
                  "assets/images/avatar0${index + 1}.png",
                  fit: BoxFit.cover,
                ),
                height: screenWidth * 0.3,
                width: screenWidth * 0.3,
              ),
            ),
            Container(
              padding: const EdgeInsets.only(bottom: 8),
              alignment: Alignment.centerLeft,
              child: Text(
                statusUser[index].statusEng,
                style: GoogleFonts.prompt(
                  textStyle: TextStyle(
                    fontSize: 18,
                    color: isSelected ? Colors.white : const Color(0xFF756EB9),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerRight,
              child: Text(
                statusUser[index].status,
                textAlign: TextAlign.right,
                style: GoogleFonts.prompt(
                  textStyle: TextStyle(
                    fontSize: 16,
                    color: isSelected ? Colors.white : const Color(0xFFF7507B),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
