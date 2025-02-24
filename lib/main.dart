import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:project_app/Splash.Screen.dart';
import 'package:project_app/page/BasicInfo.dart';
import 'package:project_app/page/BasicInfo02.dart';
import 'package:project_app/page/Dashboard.dart';
import 'package:project_app/page/DashboardFirst.dart';
import 'package:project_app/page/History.dart';
import 'package:project_app/page/Homepage.dart';
import 'package:project_app/page/Loginpage.dart';
import 'package:project_app/page/Messagenoti.dart';
// import 'package:project_app/page/Notiapp.dart';
import 'package:project_app/page/Profile.dart';
import 'package:project_app/page/Question.dart';
import 'package:project_app/page/DataUser.dart';
import 'package:project_app/page/testDash.dart';
import 'package:aad_oauth/aad_oauth.dart';
import 'package:aad_oauth/model/config.dart';

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

void main() async {
  await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized(); // สำหรับ async code ใน main
  await Firebase.initializeApp(); // เริ่มต้น Firebase
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
      ),
      initialRoute: "/", // หน้าเริ่มต้น
      routes: {
        "/": (context) => SplashScreen(), // เช็ค login
        "login": (context) => Loginpage(oauth: oauth,), // หน้าแรก Loginpage
        "home": (context) => Homepage(oauth: oauth,),
        // "/": (context) => Homepage(),
        "messagenoti": (context) => Messagenoti(message: {},),
        "question": (context) => Question(
              status: 0,
              formType_id: 0,
              worry_id: [],
            ),
        "dataUser": (context) => Datauser(
              email: '', oauth: oauth,
            ),
        "basicinfo01": (context) => Basicinfo(
              formType_id: 0,
            ),
        "basicinfo02": (context) => Basicinfo02(
              status: 0,
              formType_id: 0,
            ),
        "dash": (context) => Dashboard(),
        "dashfirst": (context) => Dashboardfirst(),
        "history": (context) => History(),
        "profile": (context) => Profile(oauth: oauth,),
        "chart": (context) => TestDash(
              formType_id: 0,
            ), // หน้าแรก Loginpage
        // "/": (context) => TestDash(), // หน้าแรก Loginpage

        // "modify": (context) => Modifyprofile(email: ''),
        // "/": (context) => Modifyprofile(email: ''),

        // "test": (context) => Test(), // ปิดไว้หากไม่ได้ใช้งาน
      },
      // home: ,
    );
  }
}
