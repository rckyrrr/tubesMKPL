//import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sipenca_mobile/components/appBar.dart';
import 'package:sipenca_mobile/firebase/auth.dart';
import 'package:sipenca_mobile/firebase/pengungsian.dart';

class KeluargaPage extends StatefulWidget {
  const KeluargaPage({super.key, required this.profileWarga});
  final Map<String, dynamic>? profileWarga;

  @override
  State<KeluargaPage> createState() => _KeluargaPageState();
}

class _KeluargaPageState extends State<KeluargaPage> {
  List<Map<String, dynamic>> dataKeluarga = [];

  void getDataKeluarga() async {
    QuerySnapshot<Map<String, dynamic>> snap = await FirebaseFirestore.instance
        .collection('keluarga')
        .where('akun', isEqualTo: AuthService.getCurrentUserID())
        .get();
    setState(() {
      List<Map<String, dynamic>> list = [];
      snap.docs.forEach((element) {
        list.add(element.data());
      });
      dataKeluarga = list;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDataKeluarga();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.grey.shade50,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                AppBarSipenca(
                  role: widget.profileWarga!['full_name'],
                ),
                const SizedBox(
                  height: 20,
                ),
                ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: dataKeluarga.length,
                  itemBuilder: (BuildContext context, int index) {
                    final member = dataKeluarga[index];
                    return Dismissible(
                      key: UniqueKey(),
                      onDismissed: (direction) async {
                        final userid = AuthService.getCurrentUserID();
                        Map<String, dynamic>? userData =
                            await DatabaseService.getDetailUsers(userid);
                        QuerySnapshot snap = await FirebaseFirestore.instance
                            .collection('keluarga')
                            .where('akun', isEqualTo: userid)
                            .get();

                        var keluargaId = snap.docs.first.id;

                        FirebaseFirestore.instance
                            .collection('keluarga')
                            .doc(keluargaId)
                            .delete();

                        userData!['keluarga'] -= 1;

                        FirebaseFirestore.instance
                            .collection('users')
                            .doc(userid)
                            .update(userData);

                        getDataKeluarga();
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("Data keluarga telah dihapus"),
                        ));
                        Navigator.pop(context);
                      },
                      child: ListTile(
                        title: Text(member["nama"] ?? 'unknown'),
                        subtitle: Text(
                            'NIK: ${member['nik']}, TTL: ${member['tanggal']}'),
                        trailing: IconButton(
                          color: Color.fromARGB(255, 244, 96, 85),
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text("Hapus Data Keluarga"),
                                  content: Text(
                                      "Anda yakin ingin menghapus data keluarga ini?"),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text("Tidak"),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        final userid =
                                            AuthService.getCurrentUserID();
                                        Map<String, dynamic>? userData =
                                            await DatabaseService
                                                .getDetailUsers(userid);
                                        QuerySnapshot snap =
                                            await FirebaseFirestore.instance
                                                .collection('keluarga')
                                                .where('akun',
                                                    isEqualTo: userid)
                                                .get();

                                        var keluargaId = snap.docs.first.id;

                                        FirebaseFirestore.instance
                                            .collection('keluarga')
                                            .doc(keluargaId)
                                            .delete();

                                        userData!['keluarga'] -= 1;

                                        FirebaseFirestore.instance
                                            .collection('users')
                                            .doc(userid)
                                            .update(userData);

                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                          content: Text(
                                              "Data keluarga telah dihapus"),
                                        ));
                                        getDataKeluarga();

                                        Navigator.pop(context);
                                      },
                                      child: Text("Ya"),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
                //Text('Ini Data keluarga yang belom dibuat'),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.indigoAccent,
        onPressed: () {
          _addMember(
              context); // Add your logic here to handle the click event of the FloatingActionButton
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _addMember(BuildContext context) {
    final nameController = TextEditingController();
    final nikController = TextEditingController();
    final tanggalController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Tambah Data Keluarga'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    hintText: 'Nama'),
              ),
              SizedBox(height: 15),
              TextField(
                controller: nikController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                  hintText: 'NIK',
                ),
              ),
              SizedBox(height: 15),
              TextField(
                controller: tanggalController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    hintText: 'TTL'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                final nama = nameController.text;
                final nik = nikController.text;
                final tanggal = tanggalController.text;
                final userid = AuthService.getCurrentUserID();
                Map<String, dynamic>? userData =
                    await DatabaseService.getDetailUsers(userid);
                FirebaseFirestore.instance.collection('keluarga').add({
                  'nama': nama,
                  'nik': nik,
                  'tanggal': tanggal,
                  'akun': userid
                });

                userData!['keluarga'] += 1;

                FirebaseFirestore.instance
                    .collection('users')
                    .doc(userid)
                    .update(userData);

                getDataKeluarga();
                Navigator.of(context).pop();
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
