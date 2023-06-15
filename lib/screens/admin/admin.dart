import 'package:flutter/material.dart';
import 'package:sipenca_mobile/firebase/auth.dart';
import 'package:sipenca_mobile/firebase/pengungsian.dart';
import 'package:sipenca_mobile/screens/admin/pengungsian.dart';
import 'package:sipenca_mobile/screens/admin/warga.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  Map<String, dynamic>? profileData;
  List<Map<String, dynamic>> listPetugas = [];
  List<Map<String, dynamic>> listPengungsian = [];
  bool isLoading = true;
  int _selectedIndex = 0;

  void getProfile() async {
    Map<String, dynamic>? userData =
        await DatabaseService.getDetailUsers(AuthService.getCurrentUserID());
    setState(() {
      profileData = userData;
      isLoading = false;
    });
  }

  void getListPetugas() async {
    List<Map<String, dynamic>> list = await DatabaseService.getAllPetugas();

    setState(() {
      listPetugas = list;
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getProfile();
    getListPetugas();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetOptions = <Widget>[
      DaftarPengungsian(
        profileData: profileData,
      ),
      DaftarWarga()
    ];
    void _onItemTapped(int index) {
      setState(() {
        _selectedIndex = index;
      });
    }

    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Center(child: widgetOptions.elementAt(_selectedIndex)),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        elevation: 0,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_work_outlined),
            activeIcon: Icon(Icons.home_work),
            label: 'Pengungsian',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group_outlined),
            activeIcon: Icon(Icons.group_rounded),
            label: 'Warga',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.indigoAccent,
        onTap: _onItemTapped,
      ),
    );
  }
}
