import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sipenca_mobile/firebase/pengungsian.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;
final FirebaseAuth auth = FirebaseAuth.instance;

class RegisterPengungsian extends StatefulWidget {
  const RegisterPengungsian({
    Key? key,
    required this.email,
    required this.password,
  }) : super(key: key);
  final String email;
  final String password;

  @override
  State<RegisterPengungsian> createState() => _RegisterPengungsianState();
}

class _RegisterPengungsianState extends State<RegisterPengungsian> {
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _alamatController = TextEditingController();
  final TextEditingController _kapasitasController = TextEditingController();
  final TextEditingController _deskripsiController = TextEditingController();

  Future<void> showAlertDialog() {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(
            child: Column(
              children: const [
                Icon(
                  Icons.check_circle_rounded,
                  color: Colors.green,
                  size: 50,
                ),
                SizedBox(height: 10),
                Text(
                  "Terimakasih Sudah Daftar!",
                  style: TextStyle(color: Colors.green, fontSize: 20),
                ),
                Text(
                  "Akun Anda sedang diverifikasi oleh Admin. Kami akan segera mengkonfirmasi status verifikasi.",
                  style: TextStyle(color: Color(0xFF5C5C5C), fontSize: 18),
                )
              ],
            ),
          ),
          actionsPadding: EdgeInsets.only(bottom: 20),
          actions: [
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, "/login");
                },
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  backgroundColor: Colors.indigoAccent,
                ),
                child: const Text(
                  "Ok",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.normal),
                ),
              ),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.only(
                    top: 10, right: 20, left: 20, bottom: 10),
                margin: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: const [
                        Text(
                          'Daftarkan',
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                    Row(
                      children: const [
                        Text(
                          'Pengungsian',
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                    const Padding(padding: EdgeInsets.only(top: 30)),
                    Column(
                      children: [
                        SvgPicture.asset(
                          'assets/registerlogo.svg',
                          height: 180,
                          width: 160,
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Padding(padding: EdgeInsets.only(top: 50)),
                        TextFormField(
                          controller: _namaController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)),
                            labelText: 'Nama Pengungsian',
                            labelStyle: const TextStyle(fontSize: 15),
                          ),
                        ),
                        const Padding(padding: EdgeInsets.only(top: 20)),
                        TextFormField(
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          controller: _alamatController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)),
                            labelText: 'Alamat Pengungsian',
                            labelStyle: const TextStyle(fontSize: 15),
                          ),
                        ),
                        const Padding(padding: EdgeInsets.only(top: 20)),
                        TextFormField(
                          controller: _kapasitasController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)),
                            labelText: 'Kapasitas Pengungsian',
                            labelStyle: const TextStyle(fontSize: 15),
                          ),
                        ),
                        const Padding(padding: EdgeInsets.only(top: 20)),
                        TextFormField(
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          controller: _deskripsiController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)),
                            labelText: 'Deskripsi Pengungsian',
                            labelStyle: const TextStyle(fontSize: 15),
                          ),
                        ),
                      ],
                    ),
                    const Padding(padding: EdgeInsets.only(top: 30)),
                    const SizedBox(height: 10.0),
                    Column(
                      children: [
                        const Padding(padding: EdgeInsets.only(top: 10)),
                        SizedBox(
                          width: 700, // ukuran lebar button
                          height: 50, // ukuran tinggi button
                          child: ElevatedButton(
                            onPressed: () {
                              String nama = _namaController.text;
                              String alamat = _alamatController.text;
                              String kapasitas = _kapasitasController.text;
                              String deskripsi = _deskripsiController.text;

                              firestore.collection('pengungsians').add({
                                'nama': nama,
                                'alamat': alamat,
                                'kapasitas_max': int.parse(kapasitas),
                                'kapasitas_terisi': 0,
                                'deskripsi': deskripsi,
                                'verified': false,
                                // tambahkan field dan nilai yang sesuai
                              }).then((value) async {
                                String docId = await DatabaseService
                                    .getDocumentIdFromQuery(
                                        'users', 'email', widget.email);
                                print(docId);
                                await DatabaseService.updateData(
                                    docId, {"pengungsian": value.id});
                                showAlertDialog();
                              }).catchError((error) {
                                print('Terjadi kesalahan: $error');
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.indigoAccent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text(
                              'Daftar',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
