import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:project_app/page/DataUser.dart';
import 'package:project_app/page/HomepageContent.dart';
import 'dart:convert';

class Loginpage extends StatefulWidget {
  const Loginpage({super.key});

  @override
  State<Loginpage> createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
  ValueNotifier userCredential = ValueNotifier('');

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    double titleFontSize = screenWidth * 0.06;
    double subtitleFontSize = screenWidth * 0.037;
    double buttonFontSize = screenWidth * 0.038;
    double imageSize = screenWidth * 0.65;

    return ValueListenableBuilder(
      valueListenable: userCredential,
      builder: (context, value, child) {
        return Scaffold(
          backgroundColor: const Color(0xffFFFFFF),
          body: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "WELLBEING",
                    style: GoogleFonts.prompt(
                      fontWeight: FontWeight.bold,
                      fontSize: titleFontSize,
                      color: const Color(0xffFF6893),
                    ),
                  ),
                  Image.asset(
                    "assets/images/result04.png",
                    height: imageSize,
                    width: imageSize,
                  ),
                  Text(
                    "พวกเราพร้อมรับฟัง",
                    style: GoogleFonts.prompt(
                      fontWeight: FontWeight.w500,
                      fontSize: subtitleFontSize,
                      color: const Color(0xff008bc6),
                    ),
                  ),
                  const SizedBox(height: 15),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Homepagecontent(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 4.0,
                      minimumSize: Size(screenWidth * 0.7, 45),
                    ),
                    child: Text(
                      'พร้อมตรวจสุขภาพใจแล้ว',
                      style: GoogleFonts.prompt(
                        textStyle: TextStyle(
                          fontSize: buttonFontSize,
                          color: const Color(0xffFF6893),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "เข้าสู่ระบบผ่าน",
                    style: GoogleFonts.prompt(
                      color: Colors.black,
                      fontSize: subtitleFontSize,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        userCredential.value = await signInWithGoogle();
                        if (userCredential.value != null) {
                          final user = userCredential.value.user;
                          await saveInitialData(user.uid, user.email ?? '');
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  Datauser(email: user.email ?? ''),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        elevation: 4.0,
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 20,
                        ),
                      ),
                      icon: Image.asset(
                        'assets/images/google.png',
                        height: 24,
                      ),
                      label: Text(
                        "Login with Google",
                        style: GoogleFonts.inter(
                          color: Colors.black,
                          fontSize: subtitleFontSize,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<dynamic> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      final userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      return userCredential;
    } catch (e) {
      print('Error during Google sign-in: $e');
      return null;
    }
  }

  Future<void> saveInitialData(String uid, String email) async {
    // const apiUrl = "http://192.168.166.222/wellbeing_php/login.php";
    // ห้ามปิด ngrok-->cmd  ก่อนใช้งานต้องรันทุกครั้งและเปลี่ยนที่อยู่ทุกครั้ง
    final apiUrl = "${dotenv.env['URL_SERVER']}/acc_user/login";
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'uid': uid,
          'email': email,
        }),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success') {
          print('Initial data saved successfully.');
        } else {
          print('Error: ${data['message']}');
        }
      } else {
        print('Failed to save initial data. Server error.');
      }
    } catch (e) {
      print('Exception during API call: $e');
    }
  }
}
