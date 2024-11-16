import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

// ignore: must_be_immutable
class ViewItem extends StatefulWidget {
  String title;
  String image;
  int index;
  ViewItem(
      {super.key,
      required this.title,
      required this.image,
      required this.index});

  @override
  State<ViewItem> createState() => _ViewItemState();
}

class _ViewItemState extends State<ViewItem> {
  Future<void> deleteData() async {
    Navigator.pop(context);
    try {
      Response response = await Dio().delete(
          'https://flutterbucketlist-default-rtdb.asia-southeast1.firebasedatabase.app/bucketlist/${widget.index}.json');

      Navigator.pop(context, "refresh");
    } catch (e) {
      print("error");
    }
  }

  Future<void> updateData() async {
    try {
      Map<String, dynamic> updateData = {
        'completed': true,
      };
      Response response = await Dio().patch(
          'https://flutterbucketlist-default-rtdb.asia-southeast1.firebasedatabase.app/bucketlist/${widget.index}.json',
          data: updateData);

      Navigator.pop(context, "refresh");
    } catch (e) {
      print("error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          PopupMenuButton(
            onSelected: (value) {
              if (value == 1) {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text(
                            "Are you sure you want to delete this ??"),
                        actions: [
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: const Text("Cancel"),
                          ),
                          InkWell(
                            onTap: () {
                              deleteData();
                            },
                            child: const Text("Delete"),
                          ),

                          // Add your other actions here like "Edit", "Share", etc.
                        ],
                      );
                    });
              }

              if (value == 2) {
                updateData();
              }
              // print(value);
            },
            itemBuilder: (context) {
              return [
                const PopupMenuItem(
                  value: 1,
                  child: Text('Delete'),
                ),
                const PopupMenuItem(
                  value: 2,
                  child: Text('Mark as Completed'),
                ),
              ];
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            height: 300,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.amber,
              image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(widget.image),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
