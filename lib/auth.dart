import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class Auth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  User? get currentUser => _firebaseAuth.currentUser();

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    UserCredential userCredential =
        await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    if (userCredential.user != null) {
      //store in realtime database

      FirebaseDatabase database = FirebaseDatabase.instance;
      DatabaseReference userRef = database.ref('users');
      String uid = userCredential.user!.uid;

      await userRef.child(uid).set({
        'email': email,
        'password': password,
        'role': "user",
      });
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
