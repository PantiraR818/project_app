// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:project_app/page/BasicInfo.dart';
// import 'package:project_app/page/BasicInfo02.dart';
// import 'package:project_app/page/Dashboard.dart';
// import 'package:project_app/page/DashboardFirst.dart';
// import 'package:project_app/page/History.dart';
// import 'package:project_app/page/Homepage.dart';
// import 'package:project_app/page/Loginpage.dart';
// import 'package:project_app/page/Noti.dart';
// import 'package:project_app/page/Question.dart';
// import 'package:project_app/page/DataUser.dart';

// void main() async {
//   await dotenv.load(fileName: ".env");
//   WidgetsFlutterBinding.ensureInitialized(); // สำหรับ async code ใน main
//   await Firebase.initializeApp(); // เริ่มต้น Firebase
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         scaffoldBackgroundColor: Colors.white,
//       ),
//       initialRoute: "/", // หน้าเริ่มต้น
//       routes: {
//         "/": (context) => Loginpage(), // หน้าแรก Loginpage
//         "home": (context) => Homepage(),
//         "notification": (context) => Noti(),
//         "question": (context) => Question(status: '', formType_id: 0,),
//         "dataUser": (context) => Datauser(email: '',),
//         "basicinfo01": (context) => Basicinfo(formType_id: 0,),
//         "basicinfo02": (context) => Basicinfo02(status: '', formType_id: 0,),
//         "dash": (context) => Dashboard(),
//         "dashfirst": (context) => Dashboardfirst(),
//         "history": (context) => History(),
//         // "test": (context) => Test(), // ปิดไว้หากไม่ได้ใช้งาน
//       },
//     );
//   }
// }

// class home extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Text("data"),
//     );
//   }

// }

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:aad_oauth/aad_oauth.dart';
import 'package:aad_oauth/model/config.dart';

void main() {
  runApp(MyApp());
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
final Config config = Config(
  tenant: "common", // ใส่ Tenant ID จาก Azure Portal
  clientId:
      "d7e69746-b16e-4bb4-9c56-77f59c67d846", // ใส่ Client ID จาก Azure Portal
  scope: "openid profile offline_access user.readbasic.all", // กำหนด Scope
  redirectUri: "msald7e69746-b16e-4bb4-9c56-77f59c67d846://auth",
  navigatorKey: navigatorKey,
);

final AadOAuth oauth = AadOAuth(config);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      home: Home(oauth: oauth),
    );
  }
}

class Home extends StatefulWidget {
  final AadOAuth oauth;

  const Home({super.key, required this.oauth});

  @override
  State<StatefulWidget> createState() {
    return _Home();
  }
}

class _Home extends State<Home> {
  String? _accessToken;
  Map<String, dynamic>? _userData;
  Map<String, dynamic>? _userData2;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus(); // เช็คสถานะการล็อกอินเมื่อเริ่มแอป
  }

  /// ฟังก์ชันเช็คสถานะการล็อกอิน
  Future<void> _checkLoginStatus() async {
    String? accessToken = await widget.oauth.getAccessToken();
    if (accessToken != null) {
      setState(() {
        _accessToken = accessToken;
      });
      await showData(); // ถ้ามี accessToken ให้ดึงข้อมูลผู้ใช้
      await showData2(); // ดึงข้อมูลจาก endpoint อื่น ๆ
    }
  }

  /// ฟังก์ชัน Login เพื่อรับ Authorization Code
  Future<void> login() async {
    try {
      await widget.oauth.login();
      String? accessToken = await widget.oauth.getAccessToken();
      setState(() {
        _accessToken = accessToken;
      });
      print("Access Token: $_accessToken");

      if (_accessToken != null) {
        await showData(); // เรียกใช้ฟังก์ชัน showData หลังจากล็อกอินสำเร็จ
        await showData2(); // เรียกใช้ฟังก์ชัน showData2
      }
    } catch (e) {
      print("Login Error: $e");
    }
  }

  Future<void> showData2() async {
    if (_accessToken == null) {
      print("Please login first.");
      return;
    }
    try {
      final userInfoResponse = await http.get(
        Uri.parse('https://graph.microsoft.com/oidc/userinfo'),
        headers: {
          'Authorization': 'Bearer $_accessToken',
        },
      );

      if (userInfoResponse.statusCode == 200) {
        final decodedBody = utf8.decode(userInfoResponse.bodyBytes);
        final userInfo = json.decode(decodedBody);

        final email = userInfo['email'] ?? '';
        final id = email.contains('@') ? email.split('@')[0] : null;

        if (id != null) {
          userInfo['id'] = id;
        }

        final userPrincipalName = userInfo['email'] ?? id;
        if (userPrincipalName != null) {
          final userDetailsResponse = await http.get(
            Uri.parse(
                'https://graph.microsoft.com/v1.0/users/$userPrincipalName?\$select=department'),
            headers: {
              'Authorization': 'Bearer $_accessToken',
            },
          );

          if (userDetailsResponse.statusCode == 200) {
            final userDetailsBody = utf8.decode(userDetailsResponse.bodyBytes);
            final userDetails = json.decode(userDetailsBody);

            userInfo.addAll(userDetails);
          } else {
            print(
                "Error fetching user details: ${userDetailsResponse.statusCode}");
          }
        }

        setState(() {
          _userData = userInfo;
        });

        print("User Data2: $_userData");
      } else {
        print("Error fetching user info: ${userInfoResponse.statusCode}");
      }
    } catch (e) {
      print("Show Data Error: $e");
    }
  }

  Future<void> showData() async {
    if (_accessToken == null) {
      print("Please login first.");
      return;
    }
    try {
      final userInfoResponse = await http.get(
        Uri.parse('https://graph.microsoft.com/v1.0/me'),
        headers: {
          'Authorization': 'Bearer $_accessToken',
        },
      );

      if (userInfoResponse.statusCode == 200) {
        final decodedBody = utf8.decode(userInfoResponse.bodyBytes);
        final userData = json.decode(decodedBody);

        final email = userData['email'] ?? '';
        final id = email.contains('@') ? email.split('@')[0] : null;

        if (id != null) {
          userData['id'] = id;
        }
        setState(() {
          _userData2 = userData;
        });
        print("User Datasss: $_userData2");
      } else {
        print("Error fetching user data: ${userInfoResponse.statusCode}");
      }
    } catch (e) {
      print("Show Data Error: $e");
    }
  }

  /// ฟังก์ชัน Logout เพื่อออกจากระบบ
  void logout() {
    setState(() {
      _accessToken = null;
      _userData = null;
      _userData2 = null;
    });
    widget.oauth.logout();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("AAD OAuth Example"),
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: logout,
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: login,
              child: Text("Login with Azure"),
            ),
            SizedBox(height: 20),
            if (_userData != null) Text('User Data: ${_userData.toString()}'),
            if (_userData2 != null)
              Text('User Data 2: ${_userData2.toString()}'),
          ],
        ),
      ),
    );
  }
}
