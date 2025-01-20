import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:iconly/iconly.dart';
import 'package:project_app/page/Dashboard.dart';
import 'package:project_app/page/DashboardFirst.dart';
import 'package:project_app/page/History.dart';
import 'package:project_app/page/HomepageContent.dart';
import 'package:project_app/page/Profile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:water_drop_nav_bar/water_drop_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_app/widget/CategoriesWidget.dart';
import 'package:project_app/widget/HomeAppBar.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  int _selectedIndex = 0; // เก็บ index ของหน้า
  String? pref;

  final List<Widget> _pages = [
    Homepagecontent(),
    Dashboardfirst(),
    History(),
    Profile(),
  ];
  // ฟังก์ชันสำหรับเปลี่ยนหน้า
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // เมื่อแตะที่ item ใน BottomNavigationBar
    });
  }

  void getPre() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      pref = prefs.getString('email');
      print('${pref} ______________________________________ pp');
    });
  }

  @override
  void initState() {
    super.initState();
    getPre();
  }

  @override
  Widget build(BuildContext context) {
    // ตรวจสอบว่าข้อมูลใน pref มีหรือยัง
    if (pref == null) {
      // ถ้ายังไม่มีข้อมูล ให้แสดงหน้าว่างหรือ loading indicator
      return Homepagecontent();
    }

    // ถ้ามีข้อมูลใน pref แล้ว ให้ build UI ตามปกติ
    return Scaffold(
      body: _pages[_selectedIndex], // หน้าเนื้อหา
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: Colors.white,
        elevation: 0, // ลบเส้นและเงา
        selectedItemColor: Colors.indigo[400],
        selectedLabelStyle: GoogleFonts.prompt(fontWeight: FontWeight.w400),
        unselectedItemColor: Colors.grey,
        unselectedLabelStyle: GoogleFonts.prompt(fontWeight: FontWeight.w400),
        items: [
          BottomNavigationBarItem(
            icon: Icon(IconlyLight.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(IconlyLight.chart),
            label: "Dashboard",
          ),
          BottomNavigationBarItem(
            icon: Icon(IconlyLight.bookmark),
            label: "History",
          ),
          BottomNavigationBarItem(
            icon: Icon(IconlyLight.profile),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}
