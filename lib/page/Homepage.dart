import 'package:aad_oauth/aad_oauth.dart';
import 'package:iconly/iconly.dart';
import 'package:project_app/page/DashboardFirst.dart';
import 'package:project_app/page/History.dart';
import 'package:project_app/page/HomepageContent.dart';
import 'package:project_app/page/Profile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Homepage extends StatefulWidget {
  final AadOAuth oauth;

  const Homepage({super.key, required this.oauth});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  int _selectedIndex = 0; // เก็บ index ของหน้า
  String? pref;
  late List<Widget> _pages;

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
  void didChangeDependencies() {
    super.didChangeDependencies();
    _pages = [
      Homepagecontent(
        oauth: widget.oauth,
      ),
      Dashboardfirst(),
      History(),
      Profile(oauth: widget.oauth),
    ];
  }

  @override
  Widget build(BuildContext context) {
    // ตรวจสอบว่าข้อมูลใน pref มีหรือยัง
    if (pref == null) {
      // ถ้ายังไม่มีข้อมูล ให้แสดงหน้าว่างหรือ loading indicator
      return Homepagecontent(
        oauth: widget.oauth,
      );
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
