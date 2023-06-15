import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  static Future<List<Map<String, dynamic>>> getAllUsers() async {
    List<Map<String, dynamic>> listUser = [];

    QuerySnapshot<Map<String, dynamic>> snapshot =
        await FirebaseFirestore.instance.collection('users').get();

    snapshot.docs.forEach((element) {
      listUser.add(element.data());
    });

    return listUser;
  }

  static Future<List<Map<String, dynamic>>> getAllPetugas() async {
    List<Map<String, dynamic>> listPetugas = [];

    QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection('users')
        .where('role', isEqualTo: 'petugas')
        .get();

    snapshot.docs.forEach((element) {
      listPetugas.add(element.data());
    });

    return listPetugas;
  }

  static Future<Map<String, dynamic>?> getDetailUsers(String documentId) async {
    DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection('users')
        .doc(documentId)
        .get();

    // return snapshot;
    Map<String, dynamic>? res = snapshot.data();

    return res;
  }

  static Future<void> updateData(
      String documentId, Map<String, dynamic>? data) async {
    try {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(documentId)
          .update(data!);
    } catch (e) {
      // Handle error jika terjadi kesalahan
      print(e.toString());
    }
  }

  static Future<String> getDocumentIdFromQuery(
      String collection, String field, String value) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(collection)
        .where(field, isEqualTo: value)
        .get();

    if (querySnapshot.size > 0) {
      QueryDocumentSnapshot documentSnapshot = querySnapshot.docs[0];
      return documentSnapshot.id;
    } else {
      return "";
    }
  }

  static Future<List<Map<String, dynamic>>> getUnverifPengungsian() async {
    List<Map<String, dynamic>> listPengungsian = [];

    List<Map<String, dynamic>> listPetugas = await getAllPetugas();
    Map<String, dynamic> combinedData;

    for (var element in listPetugas) {
      if (element['pengungsian'] != null && element['pengungsian'] != '') {
        DocumentSnapshot<Map<String, dynamic>> tes = await FirebaseFirestore
            .instance
            .collection('pengungsians')
            .doc(element['pengungsian'])
            .get();

        combinedData = {
          ...element,
          'rescueData': tes.data(),
        };
        listPengungsian.add(combinedData);
      }
    }
    List<Map<String, dynamic>> newPengungsian = listPengungsian
        .where((element) => element['rescueData']['verified'] == false)
        .toList();
    // print(newPengungsian);

    return newPengungsian;
  }

  static Future<List<Map<String, dynamic>>> getVerifiedPengungsian() async {
    List<Map<String, dynamic>> listPengungsian = [];

    QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection('pengungsians')
        .where('verified', isEqualTo: true)
        .get();
    snapshot.docs.forEach((element) {
      Map<String, dynamic> data = element.data();
      data['id'] = element.id;
      listPengungsian.add(data);
    });

    return listPengungsian;
  }

  static Future<List<Map<String, dynamic>>> getAllPengungsian() async {
    List<Map<String, dynamic>> listPengungsian = [];

    QuerySnapshot<Map<String, dynamic>> snapshot =
        await FirebaseFirestore.instance.collection('pengungsians').get();
    snapshot.docs.forEach((element) {
      listPengungsian.add(element.data());
    });

    return listPengungsian;
  }

  static Future<Map<String, dynamic>?> getPengungsianById(
      String documentId) async {
    List<Map<String, dynamic>> listPengungsian = [];

    DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection('pengungsians')
        .doc(documentId)
        .get();

    Map<String, dynamic>? res = snapshot.data();

    return res;
  }

  static Future<List<Map<String, dynamic>>> getPengungsiOnPengungsian(
      String pengungsian) async {
    List<Map<String, dynamic>> listPengungsi = [];

    QuerySnapshot<Map<String, dynamic>> snapshot =
        await FirebaseFirestore.instance.collection('users').get();
    snapshot.docs.forEach((element) {
      // print(element['reserve']);
      if (element['reserve'] == pengungsian) {
        listPengungsi.add(element.data());
      }
    });

    return listPengungsi;
  }

  static Future<void> updatePengungsian(
      String documentId, Map<String, dynamic>? data) async {
    try {
      await FirebaseFirestore.instance
          .collection("pengungsians")
          .doc(documentId)
          .update(data!);
    } catch (e) {
      // Handle error jika terjadi kesalahan
      print(e.toString());
    }
  }

  static Future<void> deletePengungsianById(String docId) async {
    try {
      await FirebaseFirestore.instance
          .collection("pengungsians")
          .doc(docId)
          .delete();
    } catch (e) {
      // Handle error jika terjadi kesalahan
      print(e.toString());
    }
  }
}
