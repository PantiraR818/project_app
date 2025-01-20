import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:iconly/iconly.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:project_app/page/Homepage.dart';
import 'package:project_app/service/Auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Modifyprofile extends StatefulWidget {
  final String email;
  const Modifyprofile({super.key, required this.email});


  @override
  State<Modifyprofile> createState() => _ModifyprofileState();
}

class _ModifyprofileState extends State<Modifyprofile> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _studentIdController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  // final TextEditingController _facultyController = TextEditingController();
  String selectedGender = "ชาย";
  String selectedfaculty = "คณะวิศวกรรมศาสตร์ (วศ.)";
  DateTime? selectedDate;

  Future<void> _updateUserData() async {
    final url =
        // 'http://192.168.166.222/wellbeing_php/update_user.php'; // เปลี่ยน URL เป็นของคุณ
        '${dotenv.env['URL_SERVER']}/acc_user/updateUser'; // เปลี่ยน URL เป็นของคุณ

    if (_formKey.currentState!.validate()) {
      if (selectedDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('กรุณาเลือกวันเดือนปีเกิด')),
        );
        return;
      }

      final userData = {
        'name': _nameController.text,
        'id_student': _studentIdController.text,
        'gender': selectedGender,
        'birthday': DateFormat('yyyy-MM-dd').format(selectedDate!),
        'faculty': selectedfaculty,
        'phone': _phoneController.text,
        'email': widget.email,
      };

      print('dataUser-=-=-=-=-=-=-=> $userData');

      try {
        final response = await http.put(
          Uri.parse(url),
          headers: {'Content-Type': 'application/json; charset=UTF-8'},
          body: jsonEncode(userData),
        );

        if (response.statusCode == 200) {
          final result = jsonDecode(response.body);
          final user = jsonDecode(response.body)['res'];
          if (result['msg'] == 'Update Success') {
            print('__________________ $user _____________________');
            final prefs = await SharedPreferences.getInstance();
            await prefs.setString('name', user['name']);
            await prefs.setString('id_student', user['id_student']);
            await prefs.setString('birthday', user['birthday']);
            await prefs.setString('gender', user['gender']);
            await prefs.setString('faculty', user['faculty']);
            await prefs.setString('phone', user['phone']);
            await prefs.setString('createdAt', user['createdAt']);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(result['msg'])),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(result['msg'])),
            );
          }
        } else {
          throw Exception('Failed to update data.');
        }
      } catch (error) {
        print(
            '___________________________________________________________________ $error');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('เกิดข้อผิดพลาด: $error')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            ClipPath(
              clipper: OvalBottomBorderClipper(),
              child: Container(
                height: screenHeight * 0.35,
                color: const Color.fromARGB(255, 255, 138, 171),
              ),
            ),
            SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.05,
                vertical: screenHeight * 0.03,
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                       _buildIconButton(IconlyLight.arrow_left, Colors.white, () {
                        Navigator.pop(context);
                      }),
                      Text(
                        "WELLBEING",
                        style: GoogleFonts.prompt(
                          textStyle: TextStyle(
                            fontSize: screenWidth * 0.05,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      _buildIconButton(IconlyLight.heart, Colors.white, () {
                      
                      }),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  Image.asset(
                    "assets/images/result05.png",
                    width: screenWidth * 0.5,
                    height: screenWidth * 0.4,
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  Container(
                    padding: EdgeInsets.all(screenWidth * 0.05),
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
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "แก้ไขข้อมูลส่วนตัว :",
                            style: GoogleFonts.prompt(
                              textStyle: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF756EB9),
                              ),
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.02),
                          Text(
                            "ชื่ออยากให้เราแก้ไข",
                            style: GoogleFonts.prompt(
                              textStyle: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Color(0xffFF6893),
                              ),
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.02),
                          _buildTextField(
                            "กรอกชื่อของคุณ",
                            _nameController,
                            (value) {
                              if (value == null || value.isEmpty) {
                                return 'กรุณากรอกชื่อ';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: screenHeight * 0.02),
                          Text(
                            "รหัสนักศึกษาที่อยากให้เราแก้ไข",
                            style: GoogleFonts.prompt(
                              textStyle: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Color(0xffFF6893),
                              ),
                            ),
                          ),
                          Text(
                            "---  กรณีไม่มีให้ ขีด -  ---",
                            style: GoogleFonts.prompt(
                              textStyle: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF756EB9),
                              ),
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.02),
                          _buildTextField(
                            "กรอกรหัสนักศึกษาของคุณ",
                            _studentIdController,
                            (value) {
                              if (value == null || value.isEmpty) {
                                return 'กรุณากรอกรหัสนักศึกษา';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: screenHeight * 0.02),
                          Text(
                            "เบอร์ที่อยากให้เราแก้ไข",
                            style: GoogleFonts.prompt(
                              textStyle: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Color(0xffFF6893),
                              ),
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.02),
                          _buildTextField(
                            "กรอกเบอร์ที่สามารถติดต่อได้",
                            _phoneController,
                            (value) {
                              if (value == null || value.isEmpty) {
                                return 'กรุณากรอกเบอร์ติดต่อ';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: screenHeight * 0.02),
                          _buildDatePicker(),
                          SizedBox(height: screenHeight * 0.02),
                          _buildDropdown(
                            label: "เพศที่อยากให้เราแก้ไข",
                            items: ["ชาย", "หญิง", "LGBTQIAN+"],
                            value: selectedGender,
                            onChanged: (value) {
                              setState(() {
                                selectedGender = value!;
                              });
                            },
                          ),
                          SizedBox(height: screenHeight * 0.02),
                          _buildDropdownfaculty(
                            label: "คณะที่สังกัดที่อยากให้เราแก้ไข",
                            items: [
                              "คณะวิศวกรรมศาสตร์ (วศ.)",
                              "คณะบริหารธุรกิจ (บธ.)",
                              "คณะเทคโนโลยีคหกรรมศาสตร์ (ทค.)",
                              "คณะศิลปกรรมศาสตร์ (ศก.)",
                              "คณะเทคโนโลยีการเกษตร (ทก.)",
                              "คณะครุศาสตร์อุตสาหกรรม (คอ.)",
                              "คณะสถาปัตยกรรมศาสตร์ (สถ.)",
                              "คณะเทคโนโลยีสื่อสารมวลชน (ทสม.)",
                              "คณะศิลปศาสตร์ (ศศ.)",
                              "คณะการแพทย์บูรณาการ (กพบ.)",
                              "คณะวิทยาศาสตร์และเทคโนโลยี (วท.)",
                              "คณะพยาบาลศาสตร์",
                              "อื่น ๆ"
                            ],
                            value: selectedfaculty,
                            onChanged: (value) {
                              setState(() {
                                selectedfaculty = value!;
                              });
                            },
                          ),
                          SizedBox(height: screenHeight * 0.04),
                          GestureDetector(
                            onTap: () {
                              _updateUserData();
                              Navigator.pushNamed(context, "profile");
                            },
                            child: Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(
                                vertical: screenHeight * 0.015,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xffFF6893),
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
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "อัปเดตข้อมูล",
                                    style: GoogleFonts.prompt(
                                      textStyle: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: screenWidth * 0.035,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  const Icon(
                                    IconlyLight.arrow_right_2,
                                    color: Colors.white,
                                    size: 22,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),     
      ),
    );
  }

  Widget _buildIconButton(IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white60),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Icon(
          icon,
          color: color,
          size: 26,
        ),
      ),
    );
  }

  Widget _buildTextField(
    String hintText,
    TextEditingController controller,
    String? Function(String?)? validator,
  ) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20), // กรอบมน
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1), // สีเงา
            spreadRadius: 2, // การกระจายของเงา
            blurRadius: 4, // ความฟุ้งของเงา
            offset: const Offset(0, 2), // ตำแหน่งเงา (แนวแกน X และ Y)
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        validator: validator,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: GoogleFonts.prompt(
            textStyle: const TextStyle(color: Colors.grey, fontSize: 14),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none,
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          filled: true,
          fillColor: Colors.white, // พื้นหลังสีขาว
        ),
      ),
    );
  }

  Widget _buildDatePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "วันเดือนปีเกิดที่ต้องการแก้ไข",
          style: GoogleFonts.prompt(
            textStyle: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 15,
              color: Color(0xffFF6893),
            ),
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () async {
            DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(1900),
              lastDate: DateTime.now(),
            );
            if (pickedDate != null) {
              setState(() {
                selectedDate = pickedDate;
              });
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 2,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  selectedDate != null
                      ? DateFormat('dd/MM/yyyy').format(selectedDate!)
                      : "เลือกวันเดือนปีเกิด",
                  style: GoogleFonts.prompt(
                    textStyle: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ),
                const Icon(
                  Icons.calendar_today,
                  color: Colors.grey,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown({
    required String label,
    required List<String> items,
    required String value,
    required void Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.prompt(
            textStyle: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 15,
              color: Color(0xffFF6893),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: DropdownButtonFormField<String>(
            value: value,
            items: items
                .map((item) => DropdownMenuItem(
                      value: item,
                      child: Text(
                        item,
                        style: GoogleFonts.prompt(
                          textStyle: const TextStyle(fontSize: 14),
                        ),
                      ),
                    ))
                .toList(),
            onChanged: onChanged,
            decoration: const InputDecoration(border: InputBorder.none),
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownfaculty({
    required String label,
    required List<String> items,
    required String value,
    required void Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.prompt(
            textStyle: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 15,
              color: Color(0xffFF6893),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: DropdownButtonFormField<String>(
            value: value,
            items: items
                .map((item) => DropdownMenuItem(
                      value: item,
                      child: Text(
                        item,
                        style: GoogleFonts.prompt(
                          textStyle: const TextStyle(fontSize: 14),
                        ),
                      ),
                    ))
                .toList(),
            onChanged: onChanged,
            decoration: const InputDecoration(border: InputBorder.none),
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ],
    );
  }
}

