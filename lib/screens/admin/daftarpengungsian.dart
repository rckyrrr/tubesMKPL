import 'package:flutter/material.dart';

class MyListApp extends StatefulWidget {
  @override
  _MyListAppState createState() => _MyListAppState();
}

class _MyListAppState extends State<MyListApp> {
  int _selectedIndex = 0;
  bool isLoading = false;

  List<Map<String, dynamic>> _items = [
    {'title': 'Pengungsian Ibu Marni', 'description': 'Jl. Sukabirus No. 10'},
    {'title': 'Pengungsian Pak Damar', 'description': 'Jl. Sukapura No. 24'},
    {'title': 'Pengungsian Rt 04', 'description': 'PGA No. 15'},
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildItem(Map<String, dynamic> item) {
    String title = item['title'];
    String description = item['description'];
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 48, 42, 212),
            ),
          ),
          SizedBox(height: 10),
          Text(
            description,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.check, color: Colors.blue),
                onPressed: () {
                  setState(() {
                    _items.remove(item);
                  });
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Pengungsian Telah Diterima'),
                    duration: const Duration(seconds: 2),
                  ));
                },
              ),
              IconButton(
                icon: Icon(Icons.close, color: Colors.red),
                onPressed: () {
                  setState(() {
                    _items.remove(item);
                  });
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Pengungsian Telah Ditolak'),
                    duration: const Duration(seconds: 2),
                  ));
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetOptions = [
      Center(
        child: isLoading
            ? CircularProgressIndicator()
            : ListView.builder(
                itemCount: _items.length,
                itemBuilder: (BuildContext context, int index) {
                  return _buildItem(_items[index]);
                },
              ),
      ),
      Center(
        child: Text('Warga'),
      ),
    ];

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          leading: CircleAvatar(
            radius: 20,
            backgroundImage: AssetImage(
                'assets/profile_image.jpg'), // Ganti dengan path foto profil Anda
          ),
          title: Text('Admin'),
        ),
        body: widgetOptions.elementAt(_selectedIndex),
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
      ),
    );
  }
}

void main() {
  runApp(MyListApp());
}
