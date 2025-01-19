import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:project_app/page/BasicInfo.dart';
import 'package:project_app/page/BasicInfo02.dart';
import 'package:project_app/page/Dashboard.dart';
import 'package:project_app/page/DashboardFirst.dart';
import 'package:project_app/page/History.dart';
import 'package:project_app/page/Homepage.dart';
import 'package:project_app/page/Loginpage.dart';
import 'package:project_app/page/ModifyProfile.dart';
import 'package:project_app/page/Noti.dart';
import 'package:project_app/page/Profile.dart';
import 'package:project_app/page/Question.dart';
import 'package:project_app/page/DataUser.dart';


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
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
      ),
      initialRoute: "/", // หน้าเริ่มต้น
      routes: {
        "/": (context) => Loginpage(), // หน้าแรก Loginpage
        "home": (context) => Homepage(),
        "notification": (context) => Noti(),
        "question": (context) => Question(status: '', formType_id: 0,),
        "dataUser": (context) => Datauser(email: '',),
        "basicinfo01": (context) => Basicinfo(formType_id: 0,),
        "basicinfo02": (context) => Basicinfo02(status: '', formType_id: 0,),
        "dash": (context) => Dashboard(),
        "dashfirst": (context) => Dashboardfirst(),
        "history": (context) => History(), 
        "profile": (context) => Profile(), 
        // "modify": (context) => Modifyprofile(email: ''),
        // "/": (context) => Modifyprofile(email: ''),

        // "test": (context) => Test(), // ปิดไว้หากไม่ได้ใช้งาน
      },
    );
  }
}

