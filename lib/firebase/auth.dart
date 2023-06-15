import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  // Method untuk login user
  static Future<User?> signIn(String email, String password) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      print('Error: $e');
      return null;
    }
  }

  static Future<Map<String, dynamic>> getDetailUsers(User user) async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection('users')
        .where('email', isEqualTo: user.email)
        .get();
    QueryDocumentSnapshot<Map<String, dynamic>> document = snapshot.docs[0];
    Map<String, dynamic> res = document.data();
    return res;
  }

  // Method untuk logout user
  static Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  static String getCurrentUserID() {
    final User? user = FirebaseAuth.instance.currentUser;
    final String userID = user!.uid;
    return userID;
  }

  static Future<String> registerAccount(
      String email, String password, String role, String idPengungsian) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = userCredential.user;

      if (role == "petugas") {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user?.uid)
            .set({
          'alamat': "",
          'email': email,
          'full_name': "",
          'jenis_kelamin': "",
          'nik': "",
          'no_hp': "",
          'password': password,
          'pengungsian': "",
          'role': role,
          'tgl_lahir': "",
        });
      } else if (role == "warga") {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user?.uid)
            .set({
          'alamat': "",
          'email': email,
          'full_name': "",
          'jenis_kelamin': "",
          'nik': "",
          'no_hp': "",
          'occupied': "",
          'reserve': "",
          'role': role,
          'tgl_lahir': "",
          'pulang': false,
          'keluarga': 1
        });
      }
      return "success";
      // Simpan data pengguna ke koleksi "users" di Firestore
    } on FirebaseAuthException catch (e) {
      // Handle error jika terjadi kesalahan
      // print(e.code);
      // print(e.message);
      return e.code;
    }
  }

  static Future<void> deleteUserById(String docId) async {
    try {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(docId)
          .delete();
    } catch (e) {
      // Handle error jika terjadi kesalahan
      print(e.toString());
    }
  }
}
