import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

// ignore: must_be_immutable
class AddBucketList extends StatefulWidget {
  int newIndex;
  AddBucketList({super.key, required this.newIndex});

  @override
  State<AddBucketList> createState() => _AddBucketListState();
}

class _AddBucketListState extends State<AddBucketList> {
  TextEditingController itemText = TextEditingController();
  TextEditingController costText = TextEditingController();
  TextEditingController imageText = TextEditingController();

  Future<void> addData() async {
    try {
      Map<String, dynamic> updateData = {
        "item": itemText.text,
        "cost": costText.text,
        "image": imageText.text,
        "completed": false
      };
      Response response = await Dio().patch(
          'https://flutterbucketlist-default-rtdb.asia-southeast1.firebasedatabase.app/bucketlist/${widget.newIndex}.json',
          data: updateData);

      Navigator.pop(context, "refresh");
    } catch (e) {
      print("error");
    }
  }

  @override
  Widget build(BuildContext context) {
    var addForm = GlobalKey<FormState>();
    return Scaffold(
        appBar: AppBar(
          // ignore: prefer_const_constructors
          title: Text("Add Bucket List"),
        ),
        body: Form(
          key: addForm,
          child: Column(
            children: [
              TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Item cannot be empty";
                  }
                  if (value.toString().length < 3) {
                    return "Item name should be at least 3 characters long";
                  }
                },
                controller: itemText,
                decoration: InputDecoration(label: Text("Item")),
              ),
              const SizedBox(
                height: 30,
              ),
              TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Item cannot be empty";
                  }
                  if (value.toString().length < 3) {
                    return "Item name should be at least 3 characters long";
                  }
                },
                controller: costText,
                decoration: InputDecoration(label: Text("Cost")),
              ),
              const SizedBox(
                height: 30,
              ),
              TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Item cannot be empty";
                  }
                  if (value.toString().length < 3) {
                    return "Item name should be at least 3 characters long";
                  }
                },
                controller: imageText,
                decoration: InputDecoration(label: Text("Image URL")),
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (addForm.currentState!.validate()) {
                          addData();
                        }
                      },
                      child: const Text("Add Item"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}
