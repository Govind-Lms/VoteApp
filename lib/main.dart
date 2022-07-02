// ignore: import_of_legacy_library_into_null_safe
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vote_app/screens/homePage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SharedPreferences.getInstance().then((pref) => runApp(VotingApp(
    pref: pref,
  )));
}

class VotingApp extends StatelessWidget {
  final SharedPreferences pref;

  const VotingApp({Key? key, required this.pref}) : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Votin\'U',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.white, colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.white)
      ),
      home: HomePage(),
    );
  }
}