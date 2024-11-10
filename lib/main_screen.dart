import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<dynamic> bucketListData = [];
  bool isLoading = false;

  Future<void> getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      Response response = await Dio().get(
          'https://flutterbucketlist-default-rtdb.asia-southeast1.firebasedatabase.app/bucketlist.json');

      bucketListData = response.data;
      isLoading = false;
      setState(() {});
    } catch (e) {
      isLoading = false;
      setState(() {});
      showDialog(
          // ignore: use_build_context_synchronously
          context: context,
          builder: (contect) {
            return AlertDialog(
              title: const Text('Error'),
              content: const Text(
                  "can't connect to the server, please try after few second"),
              actions: [
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          });
      // print(e);
    }
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        shape: const CircleBorder(),
        // ignore: prefer_const_constructors
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        centerTitle: true,
        // ignore: prefer_const_constructors
        title: Text("Bucket List"),
        actions: [
          InkWell(
            onTap: () {
              getData();
            },
            // ignore: prefer_const_constructors
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              // ignore: prefer_const_constructors
              child: Icon(Icons.refresh),
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          getData();
        },
        child: isLoading
            // ignore: prefer_const_constructors
            ? LinearProgressIndicator()
            : ListView.builder(
                itemCount: bucketListData.length,
                itemBuilder: (BuildContext connect, int index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 25,
                        backgroundImage:
                            NetworkImage(bucketListData[index]['image'] ?? ""),
                      ),
                      title: Text(bucketListData[index]['item'] ?? ""),
                      trailing:
                          Text(bucketListData[index]['cost'].toString() ?? ""),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
