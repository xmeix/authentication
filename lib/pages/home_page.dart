import 'package:authentication/auth.dart';
import 'package:authentication/models/personnel.dart';
import 'package:firebase_database/firebase_database.dart';
import "package:flutter/material.dart";
import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  User? user;
  late Personnel pers;
  DatabaseReference? dataRef;
  final FirebaseAuth auth = FirebaseAuth.instance;
  late String role;
  List<Personnel> dataList = [];

  @override
  void initState() {
    super.initState();
    user = auth.currentUser;
    if (user != null) {
      dataRef = FirebaseDatabase.instance.ref().child("users");
      dataRef?.once().then((event) {
        final dataSnapshot = event.snapshot;
        dataList.clear();
        Map<dynamic, dynamic> values =
            dataSnapshot.value as Map<dynamic, dynamic>;

        var keys = values.keys;

        for (var key in keys) {
          print(key);
          pers = Personnel(
            user!.uid,
            values[key]["email"],
            values[key]["password"],
            values[key]["role"],
          );
          dataList.add(pers);
        }
        setState(() {
          role = pers.role;
        });
      });
    }
  }

  Future<void> signOut() async {
    await Auth().signOut().then((value) {
      //go to login screen
    });
  }

  Widget _title() {
    return const Text('Firebase Auth');
  }

  Widget _userUid() {
    return Text(user?.email ?? 'User email');
  }

  Widget _userRole() {
    if (dataList.isEmpty) {
      return const Center(child: Text("no data"));
    } else {
      return Text(role);
    }
  }

  Widget _signOutButton() {
    return ElevatedButton(onPressed: signOut, child: const Text('Sign Out'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _title(),
      ),
      body: Container(
          height: double.infinity,
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _userRole(),
              _userUid(),
              _signOutButton(),
            ],
          )),
    );
  }
}
