import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sipenca_mobile/firebase/auth.dart';
import 'package:sipenca_mobile/firebase/pengungsian.dart';
import 'package:sipenca_mobile/components/appBar.dart';
import 'package:intl/intl.dart';

class ProfilePage extends StatefulWidget {
  final Map<String, dynamic>? profileWarga;
  const ProfilePage({super.key, required this.profileWarga});

  @override
  ProfilePageState createState() => ProfilePageState();
}

TextEditingController nikController = TextEditingController();
TextEditingController nikUpdateController = TextEditingController();

TextEditingController namaController = TextEditingController();
TextEditingController namaUpdateController = TextEditingController();

TextEditingController jenisKelaminController = TextEditingController();
TextEditingController jenisKelaminUpdateController = TextEditingController();

TextEditingController tanggalLahirController = TextEditingController();
TextEditingController tanggalLahirUpdateController = TextEditingController();

TextEditingController alamatController = TextEditingController();
TextEditingController alamatUpdateController = TextEditingController();

TextEditingController nomorTeleponController = TextEditingController();
TextEditingController nomorTeleponUpdateController = TextEditingController();

class ProfilePageState extends State<ProfilePage> {
  String jenisKelamin = "Laki-laki";
  Map<String, dynamic>? profileWargaBaru = {};
  String userId = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  AppBarSipenca(
                    role: widget.profileWarga!["full_name"],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                      child: SafeArea(
                          child: Text(
                        "NIK",
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold),
                      ))),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                    child: TextFormField(
                      enabled: false,
                      controller: nikController
                        ..text = widget.profileWarga!["nik"].toString(),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                      child: SafeArea(
                          child: Text(
                        "Nama",
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold),
                      ))),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                    child: TextFormField(
                      enabled: false,
                      controller: namaController
                        ..text = widget.profileWarga!["full_name"],
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                      child: SafeArea(
                          child: Text(
                        "Jenis Kelamin",
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold),
                      ))),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                    child: TextFormField(
                      enabled: false,
                      controller: jenisKelaminController
                        ..text = widget.profileWarga!["jenis_kelamin"],
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                      child: Text(
                        "Alamat",
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold),
                      )),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                    child: TextFormField(
                      enabled: false,
                      controller: alamatController
                        ..text = widget.profileWarga!["alamat"],
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                      child: Text(
                        "Nomor Telepon",
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold),
                      )),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                    child: TextFormField(
                      enabled: false,
                      controller: nomorTeleponController
                        ..text = widget.profileWarga!["no_hp"].toString(),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                      child: Text(
                        "Tanggal Lahir",
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold),
                      )),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                    child: TextFormField(
                      enabled: false,
                      controller: tanggalLahirController
                        ..text = widget.profileWarga!["tgl_lahir"],
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                  Center(
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 40,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.indigoAccent,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10))
                              //set warna background button
                              ),
                          onPressed: () {
                            showDialog<String>(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                title: const Text('Update Data'),
                                content: Builder(builder: (context) {
                                  var height =
                                      MediaQuery.of(context).size.height;
                                  var width = MediaQuery.of(context).size.width;
                                  return Container(
                                    // height: height - 300,
                                    // width: width - 200,
                                    child: SingleChildScrollView(
                                      child: ListBody(
                                        children: [
                                          Container(
                                            margin: const EdgeInsets.symmetric(
                                                vertical: 10),
                                            child: TextField(
                                              controller: nikUpdateController
                                                ..text = widget
                                                    .profileWarga!["nik"]
                                                    .toString(),
                                              keyboardType:
                                                  TextInputType.number,
                                              inputFormatters: [
                                                FilteringTextInputFormatter
                                                    .digitsOnly,
                                              ],
                                              decoration: InputDecoration(
                                                border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                labelText: 'NIK',
                                              ),
                                            ),
                                          ),
                                          Container(
                                            margin: const EdgeInsets.symmetric(
                                                vertical: 10),
                                            child: TextField(
                                              controller: namaUpdateController
                                                ..text = widget
                                                    .profileWarga!["full_name"],
                                              inputFormatters: [
                                                LengthLimitingTextInputFormatter(
                                                    15),
                                              ],
                                              decoration: InputDecoration(
                                                border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                labelText: 'Nama',
                                              ),
                                            ),
                                          ),
                                          Container(
                                            margin: const EdgeInsets.symmetric(
                                                vertical: 10),
                                            child:
                                                DropdownButtonFormField<String>(
                                              decoration: InputDecoration(
                                                border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                labelText: 'Jenis Kelamin',
                                              ),
                                              items: const [
                                                DropdownMenuItem<String>(
                                                    value: "Laki-laki",
                                                    child: Text("Laki - laki")),
                                                DropdownMenuItem<String>(
                                                    value: "Perempuan",
                                                    child: Text("Perempuan")),
                                              ],
                                              value: jenisKelamin,
                                              onChanged: (value) {
                                                jenisKelamin = value!;
                                              },
                                            ),
                                          ),
                                          Container(
                                            margin: const EdgeInsets.symmetric(
                                                vertical: 10),
                                            child: TextField(
                                              keyboardType:
                                                  TextInputType.multiline,
                                              maxLines: null,
                                              controller: alamatUpdateController
                                                ..text = widget
                                                    .profileWarga!["alamat"],
                                              decoration: InputDecoration(
                                                border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                labelText: 'Alamat',
                                              ),
                                            ),
                                          ),
                                          Container(
                                            margin: const EdgeInsets.symmetric(
                                                vertical: 10),
                                            child: TextField(
                                              controller:
                                                  nomorTeleponUpdateController
                                                    ..text = widget
                                                        .profileWarga!["no_hp"]
                                                        .toString(),
                                              keyboardType:
                                                  TextInputType.number,
                                              inputFormatters: [
                                                FilteringTextInputFormatter
                                                    .digitsOnly,
                                              ],
                                              decoration: InputDecoration(
                                                border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                labelText: 'Nomor Telepon',
                                              ),
                                            ),
                                          ),
                                          Container(
                                            margin: const EdgeInsets.symmetric(
                                                vertical: 10),
                                            child: TextField(
                                                controller:
                                                    tanggalLahirUpdateController
                                                      ..text =
                                                          widget.profileWarga![
                                                              "tgl_lahir"],
                                                decoration: InputDecoration(
                                                  border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10)),
                                                  labelText: 'Tanggal Lahir',
                                                ),
                                                readOnly: true,
                                                onTap: () async {
                                                  var date =
                                                      await showDatePicker(
                                                          context: context,
                                                          initialDate:
                                                              DateTime.now(),
                                                          firstDate:
                                                              DateTime(1900),
                                                          lastDate:
                                                              DateTime(2100));
                                                  if (date != null) {
                                                    tanggalLahirUpdateController
                                                            .text =
                                                        DateFormat('dd/MM/yyyy')
                                                            .format(date);
                                                  }
                                                }),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, 'Cancel'),
                                    child: const Text('Tutup'),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      setState(() {
                                        profileWargaBaru = widget.profileWarga;
                                      });
                                      profileWargaBaru!["nik"] =
                                          nikUpdateController.text;
                                      profileWargaBaru!["full_name"] =
                                          namaUpdateController.text;
                                      profileWargaBaru!["jenis_kelamin"] =
                                          jenisKelamin;
                                      profileWargaBaru!["alamat"] =
                                          alamatUpdateController.text;
                                      profileWargaBaru!["no_hp"] =
                                          nomorTeleponUpdateController.text;
                                      profileWargaBaru!["tgl_lahir"] =
                                          tanggalLahirUpdateController.text;
                                      if (userId.isEmpty) {
                                        userId = await AuthService
                                            .getCurrentUserID();
                                      }
                                      DatabaseService.updateData(
                                          userId, profileWargaBaru);
                                      Navigator.pop(context, 'OK');
                                    },
                                    child: const Text('Update'),
                                  ),
                                ],
                              ),
                            );
                          },
                          child: const Text("Edit")),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
