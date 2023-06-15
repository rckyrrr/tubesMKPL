import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sipenca_mobile/firebase/auth.dart';
import 'package:sipenca_mobile/firebase/pengungsian.dart';
import 'package:sipenca_mobile/screens/petugas/kebutuhan.dart';
import 'package:sipenca_mobile/screens/petugas/pengungsi.dart';
import 'package:sipenca_mobile/screens/warga/profile.dart';

class ListPengungsi extends StatefulWidget {
  const ListPengungsi({super.key});

  @override
  State<ListPengungsi> createState() => _ListPengungsiState();
}

class _ListPengungsiState extends State<ListPengungsi> {
  List<Map<String, dynamic>> dataPengungsi = [];
  Map<String, dynamic>? profilePetugas;
  Map<String, dynamic>? user;
  int _selectedIndex = 0;
  bool isLoading = true;

  Future<void> getProfile() async {
    Map<String, dynamic>? userData =
        await DatabaseService.getDetailUsers(AuthService.getCurrentUserID());

    setState(() {
      profilePetugas = userData;
      isLoading = false;
    });
  }

  Future<void> checkProfile() async {
    Map<String, dynamic>? userData =
        await DatabaseService.getDetailUsers(AuthService.getCurrentUserID());

    if (userData!['full_name'] == "" ||
        userData['nik'] == "" ||
        userData['no_hp'] == "" ||
        userData['jenis_kelamin'] == "" ||
        userData['tgl_lahir'] == "" ||
        userData['alamat'] == "") {
      setState(() {
        _selectedIndex = 2;
      });
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void getListPengungsi() async {
    List<Map<String, dynamic>> list = [];
    QuerySnapshot<Map<String, dynamic>> snap =
        await FirebaseFirestore.instance.collection('users').get();

    snap.docs.forEach((element) {
      if (element.data()['reserve'] == profilePetugas!['pengungsian']) {
        Map<String, dynamic> data = element.data();
        data['id'] = element.id;
        list.add(data);
      }
    });
    setState(() {
      dataPengungsi = list;
    });
  }

  @override
  void initState() {
    super.initState();
    getProfile().then((value) {
      getListPengungsi();
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetOptions = <Widget>[
      PengungsiWarga(
        profileData: profilePetugas,
      ),
      DetailPengungsian(
        profileData: profilePetugas,
      ),
      ProfilePage(profileWarga: profilePetugas),
    ];

    return Scaffold(
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Center(child: widgetOptions.elementAt(_selectedIndex)),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        elevation: 0,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.group_outlined),
            activeIcon: Icon(Icons.group_rounded),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home_work_outlined),
            activeIcon: Icon(Icons.home_work),
            label: 'Pengungsian',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.indigoAccent,
        onTap: _onItemTapped,
      ),
    );
  }
}
