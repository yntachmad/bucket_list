import 'package:flutter/material.dart';

class AddBucketList extends StatefulWidget {
  const AddBucketList({super.key});

  @override
  State<AddBucketList> createState() => _AddBucketListState();
}

class _AddBucketListState extends State<AddBucketList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // ignore: prefer_const_constructors
        title: Text("Add Bucket List"),
      ),
    );
  }
}
