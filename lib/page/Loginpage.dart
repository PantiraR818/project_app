import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:project_app/page/DataUser.dart';
import 'package:project_app/service/Auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:aad_oauth/aad_oauth.dart';

class Loginpage extends StatefulWidget {
  final AadOAuth oauth;
  const Loginpage({super.key, required this.oauth});

  @override
  State<Loginpage> createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
  String? _accessToken;
  Map<String, dynamic>? _userData;
  ValueNotifier userCredential = ValueNotifier('');
  Future<void> _checkLoginStatus() async {
    String? accessToken = await widget.oauth.getAccessToken();
    if (accessToken != null) {
      setState(() {
        _accessToken = accessToken;
      });
      await fetchUserData(); // เรียกใช้ฟังก์ชัน showData หลังจากล็อกอินสำเร็จ
    }
  }

  Future<void> loginMS() async {
    try {
      await widget.oauth.login();
      String? accessToken = await widget.oauth.getAccessToken();
      setState(() {
        _accessToken = accessToken;
      });
      print("Access Token: $_accessToken");

      if (_accessToken != null) {
        await fetchUserData(); // เรียกใช้ฟังก์ชัน showData หลังจากล็อกอินสำเร็จ
      }
    } catch (e) {
      print("Login Error: $e");
    }
  }

  Future<void> fetchUserData() async {
    if (_accessToken == null) {
      print("Please login first.");
      return;
    }

    try {
      // ดึงข้อมูลจาก OIDC
      final userInfoResponse = await http.get(
        Uri.parse('https://graph.microsoft.com/oidc/userinfo'),
        headers: {'Authorization': 'Bearer $_accessToken'},
      );

      // ดึงข้อมูลจาก Microsoft Graph v1.0
      final userGraphResponse = await http.get(
        Uri.parse('https://graph.microsoft.com/v1.0/me'),
        headers: {'Authorization': 'Bearer $_accessToken'},
      );
      print(
          'userInfoResponse ----------------> ${userInfoResponse.statusCode}');
      print(
          'userInfoResponse ----------------> ${userGraphResponse.statusCode}');
      //&& userGraphResponse.statusCode == 200

      if (userInfoResponse.statusCode == 200 &&
          userGraphResponse.statusCode == 200) {
        final userInfo = json.decode(utf8.decode(userInfoResponse.bodyBytes));
        final userData = json.decode(utf8.decode(userGraphResponse.bodyBytes));
        print('userInfo --------------------------------> $userInfo');
        // รวมข้อมูลจากทั้งสอง API
        final email = userInfo['email'] ?? userData['mail'] ?? '';
        final id = email.contains('@') ? email.split('@')[0] : null;
        if (id != null) userData['id'] = id;

        // ดึง department เพิ่มเติม
        final userPrincipalName = email.isNotEmpty ? email : id;
        if (userPrincipalName != null) {
          final userDetailsResponse = await http.get(
            Uri.parse(
                'https://graph.microsoft.com/v1.0/users/$userPrincipalName?\$select=department'),
            headers: {'Authorization': 'Bearer $_accessToken'},
          );

          if (userDetailsResponse.statusCode == 200) {
            final userDetails =
                json.decode(utf8.decode(userDetailsResponse.bodyBytes));
            userData.addAll(userDetails);
          } else {
            print(
                "Error fetching user details: ${userDetailsResponse.statusCode}");
          }
        }

        setState(() async {
          _userData = userData;
          if (_userData != null) {
            await saveInitialData(
              _userData!['mail'] ?? '',
              _userData!['displayName'] ?? '',
              _userData!['id']?.toString() ?? '',
              _userData!['department'] ?? '',
              _userData!['mobilePhone'] ?? '',
            );
          } else {
            print("Error: _userData is null.");
          }
        });

        print("User Data latest: $_userData");
      } else {
        _showLoginErrorAlert();
        print(
            "Error fetching user info: ${userInfoResponse.statusCode}, ${userGraphResponse.statusCode}");
      }
    } catch (e) {
      print("Fetch User Data Error: $e");
    }
  }

  void _showLoginErrorAlert() {
    showDialog(
      context: context,
      barrierDismissible: false, // ป้องกันการปิด Dialog โดยคลิกนอกกรอบ
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20), // ขอบโค้งมน
          ),
          backgroundColor: Colors.white,
          title: Column(
            children: [
              Icon(Icons.error_outline, color: Colors.redAccent, size: 50),
              SizedBox(height: 10),
              Text(
                "เข้าสู่ระบบล้มเหลว",
                style: GoogleFonts.prompt(
                    textStyle: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                )),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          content: Text(
            "กรุณาเข้าสู่ระบบด้วยบัญชี\nมหาวิทยาลัยเทคโนโลยีราชมงคลธัญบุรี",
            style: GoogleFonts.prompt(
                textStyle: TextStyle(fontSize: 16, color: Colors.black54)),
            textAlign: TextAlign.center,
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ElevatedButton(
                onPressed: () {
                  logout(widget.oauth);
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                ),
                child: Text(
                  "ลองอีกครั้ง",
                  style: GoogleFonts.prompt(
                      textStyle: TextStyle(fontSize: 16, color: Colors.white)),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

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
                      Navigator.pushNamed(context, "home");
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
                        loginMS();
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
                        'assets/images/ms.png',
                        height: 24,
                      ),
                      label: Text(
                        "Login with Microsoft",
                        style: GoogleFonts.inter(
                          color: Colors.black,
                          fontSize: subtitleFontSize,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    '(อีเมล Microsoft จาก RMUTT)',
                    style: GoogleFonts.prompt(
                        textStyle: TextStyle(
                            fontSize: subtitleFontSize,
                            // fontWeight: FontWeight.bold,
                            color: (Colors.black38),))
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // Future<dynamic> signInWithGoogle() async {
  //   try {
  //     final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
  //     final GoogleSignInAuthentication? googleAuth =
  //         await googleUser?.authentication;
  //     final credential = GoogleAuthProvider.credential(
  //       accessToken: googleAuth?.accessToken,
  //       idToken: googleAuth?.idToken,
  //     );
  //     final userCredential =
  //         await FirebaseAuth.instance.signInWithCredential(credential);
  //     return userCredential;
  //   } catch (e) {
  //     print('Error during Google sign-in: $e');
  //     return null;
  //   }
  // }

  Future<void> saveInitialData(String mail, String displayName, String id,
      String department, String mobilePhone) async {
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
          'email': mail,
          'name': displayName,
          'id_student': id,
          'faculty': department,
          'phone': mobilePhone,
        }),
      );
      print('response.statusCode ${response.statusCode}');
      if (response.statusCode == 200) {
        final prefs = await SharedPreferences.getInstance();
        final data = json.decode(response.body);
        final user = json.decode(response.body)['res'];
        print('data[] .statusCode ${data['msg']}');

        if (data['msg'] == 'create success') {
          print('Initial data saved successfully.');
          await prefs.setString('email', mail);
          await prefs.setInt('id', user['id']);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Datauser(
                email: mail,
                oauth: widget.oauth,
              ),
            ),
          );
        }
        if (data['msg'] == 'login success') {
          await prefs.setString('email', user['email']);
          await prefs.setInt('id', user['id']);
          await prefs.setString('name', user['name']);
          await prefs.setString('id_student', user['id_student']);
          await prefs.setString('birthday', user['birthday']);
          await prefs.setString('gender', user['gender']);
          await prefs.setString('faculty', user['faculty']);
          await prefs.setString('phone', user['phone']);
          await prefs.setString('createdAt', user['createdAt']);
          Navigator.pushNamed(context, "home");
        }
      } else {
        print('Failed to save initial data. Server error.');
      }
    } catch (e) {
      print('Exception during API call: $e');
    }
  }
}
