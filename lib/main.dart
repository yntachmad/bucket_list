import 'package:bucket_list/add_bucket_list.dart';
import 'package:bucket_list/main_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        "/home": (context) => const MainScreen(),
        "/add": (context) => const AddBucketList(),
      },
      initialRoute: "home",
      theme: ThemeData.light(useMaterial3: true),
      home: const MainScreen(),
    );
  }
}
