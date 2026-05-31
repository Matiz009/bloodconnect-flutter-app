import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class AuthService {
  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;

  // Register
  Future<String?> register({
    required String email,
    required String password,
    required String name,
    required String phone,
    required String bloodGroup,
    required String city,
  }) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = UserModel(
        uid: cred.user!.uid,
        name: name,
        phone: phone,
        bloodGroup: bloodGroup,
        city: city,
      );
      await _db.collection('users').doc(cred.user!.uid).set(user.toMap());
      await _saveUserLocally(user);
      return null; // no error
    } catch (e) {
      return e.toString();
    }
  }

  // Login
  Future<String?> login(String email, String password) async {
    try {
      final cred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final doc = await _db.collection('users').doc(cred.user!.uid).get();
      if (doc.exists) {
        await _saveUserLocally(UserModel.fromMap(doc.data()!));
      }
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  // Logout
  Future<void> logout() async {
    await _auth.signOut();
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  // Save user to SharedPrefs
  Future<void> _saveUserLocally(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('uid', user.uid);
    await prefs.setString('name', user.name);
    await prefs.setString('phone', user.phone);
    await prefs.setString('bloodGroup', user.bloodGroup);
    await prefs.setString('city', user.city);
  }

  // Get local user (no Firestore call)
  Future<UserModel?> getLocalUser() async {
    final prefs = await SharedPreferences.getInstance();
    final uid = prefs.getString('uid');
    if (uid == null) return null;
    return UserModel(
      uid: uid,
      name: prefs.getString('name') ?? '',
      phone: prefs.getString('phone') ?? '',
      bloodGroup: prefs.getString('bloodGroup') ?? '',
      city: prefs.getString('city') ?? '',
    );
  }
}
