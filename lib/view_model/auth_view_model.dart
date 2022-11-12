import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class AuthViewModel {
  Future<void> login({required String email, required String password}) async {

        await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signUp(
      {required String email,
      required String password,
      required String username}) async {
    UserCredential userCredential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    userCredential.user!.updateDisplayName(username);
    String uid = userCredential.user!.uid;
    DatabaseReference userRef = FirebaseDatabase.instance.ref('students/$uid');
    await userRef.set({'email': email, 'username': username});
  }
}
