import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sipenca_mobile/components/appBar.dart';
import 'package:sipenca_mobile/firebase/auth.dart';
import 'package:sipenca_mobile/firebase/pengungsian.dart';

class PengungsiWarga extends StatefulWidget {
  const PengungsiWarga({super.key, required this.profileData});
  final Map<String, dynamic>? profileData;

  @override
  State<PengungsiWarga> createState() => _PengungsiWargaState();
}

class _PengungsiWargaState extends State<PengungsiWarga> {
  List<Map<String, dynamic>> dataPengungsiReserve = [];
  List<Map<String, dynamic>> dataPengungsiOccupied = [];
  bool isLoading = true;

  void getListReserve() async {
    List<Map<String, dynamic>> list = [];
    QuerySnapshot<Map<String, dynamic>> snap =
        await FirebaseFirestore.instance.collection('users').get();

    Map<String, dynamic>? userData =
        await DatabaseService.getDetailUsers(AuthService.getCurrentUserID());

    snap.docs.forEach((element) {
      if (element.data()['reserve'] == userData!['pengungsian']) {
        Map<String, dynamic> data = element.data();
        data['id'] = element.id;
        list.add(data);
      }
    });
    setState(() {
      dataPengungsiReserve = list;
      isLoading = false;
    });
  }

  void getListOccupied() async {
    List<Map<String, dynamic>> list = [];
    QuerySnapshot<Map<String, dynamic>> snap =
        await FirebaseFirestore.instance.collection('users').get();

    Map<String, dynamic>? userData =
        await DatabaseService.getDetailUsers(AuthService.getCurrentUserID());

    snap.docs.forEach((element) {
      if (element.data()['occupied'] == userData!['pengungsian']) {
        Map<String, dynamic> data = element.data();
        data['id'] = element.id;
        list.add(data);
      }
    });
    setState(() {
      dataPengungsiOccupied = list;
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getListReserve();
    getListOccupied();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
          body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              AppBarSipenca(role: widget.profileData!['full_name']),
              const SizedBox(height: 10),
              const TabBar(
                indicatorColor: Colors.indigoAccent,
                labelColor: Colors.indigoAccent,
                unselectedLabelColor: Colors.grey,
                overlayColor: MaterialStatePropertyAll(Colors.transparent),
                tabs: <Widget>[
                  Tab(
                    text: "Pengungsi Masuk",
                  ),
                  Tab(
                    text: "Daftar Pengungsi",
                  ),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: <Widget>[
                    dataPengungsiReserve.isEmpty
                        ? const Center(
                            child: Text("Tidak ada data untuk ditampilkan!"),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            itemCount: dataPengungsiReserve.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {},
                                child: Card(
                                  elevation: 0,
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(16))),
                                  child: InkWell(
                                    hoverColor: Colors.transparent,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(16)),
                                    onTap: () {},
                                    child: Container(
                                      padding: const EdgeInsets.all(20),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(dataPengungsiReserve[index]
                                                  ['full_name']),
                                              // Text(jarak),
                                              // Text("${dataPengungsi[index]['member']}orang"),
                                            ],
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 16),
                                            child: Text(
                                                dataPengungsiReserve[index]
                                                    ['alamat']),
                                          ),
                                          FloatingActionButton(
                                            heroTag: "btnPengungsi$index",
                                            onPressed: () {
                                              Map<String, dynamic> data =
                                                  dataPengungsiReserve[index];
                                              data['occupied'] =
                                                  data['reserve'];
                                              data['reserve'] = '';

                                              FirebaseFirestore.instance
                                                  .collection('users')
                                                  .doc(dataPengungsiReserve[
                                                      index]['id'])
                                                  .update(data);

                                              FirebaseFirestore.instance
                                                  .collection('pengungsians')
                                                  .doc(data['occupied'])
                                                  .update({
                                                'kapasitas_terisi':
                                                    FieldValue.increment(
                                                        data['keluarga'])
                                              });
                                              setState(() {
                                                getListReserve();
                                                getListOccupied();
                                              });
                                            },
                                            backgroundColor:
                                                Colors.indigoAccent,
                                            elevation: 5,
                                            shape: const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(12))),
                                            child: const Icon(Icons.input),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                    RefreshIndicator(
                      onRefresh: () async {
                        getListReserve();
                        getListOccupied();
                      },
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: dataPengungsiOccupied.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {},
                            child: Card(
                              elevation: 0,
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(16))),
                              child: InkWell(
                                hoverColor: Colors.transparent,
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(16)),
                                onTap: () {},
                                child: Container(
                                  padding: const EdgeInsets.all(20),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(dataPengungsiOccupied[index]
                                              ['full_name']),
                                        ],
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 16),
                                        child: Text(dataPengungsiOccupied[index]
                                            ['alamat']),
                                      ),
                                      if (dataPengungsiOccupied[index]
                                          ['pulang'])
                                        FloatingActionButton(
                                          heroTag: "btnPengungsi$index",
                                          onPressed: () {
                                            Map<String, dynamic> data =
                                                dataPengungsiOccupied[index];

                                            FirebaseFirestore.instance
                                                .collection('pengungsians')
                                                .doc(data['occupied'])
                                                .update({
                                              'kapasitas_terisi':
                                                  FieldValue.increment(
                                                      data['keluarga'] * -1)
                                            });

                                            data['occupied'] = '';
                                            data['reserve'] = '';
                                            data['pulang'] = false;
                                            FirebaseFirestore.instance
                                                .collection('users')
                                                .doc(
                                                    dataPengungsiOccupied[index]
                                                        ['id'])
                                                .update(data);
                                            setState(() {
                                              getListOccupied();
                                            });
                                          },
                                          backgroundColor: Colors.indigoAccent,
                                          elevation: 5,
                                          shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(12))),
                                          child: const Icon(Icons.input),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      )),
    );
  }
}
