import 'package:bucket_list/view_item.dart';
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
  bool isError = false;

  Future<void> getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      Response response = await Dio().get(
          'https://flutterbucketlist-default-rtdb.asia-southeast1.firebasedatabase.app/bucketlist.json');

      bucketListData = response.data ?? [];
      if (response.data is List) {
        bucketListData = response.data;
      } else {
        bucketListData = [];
      }

      isLoading = false;
      isError = false;
      setState(() {});
    } catch (e) {
      isLoading = false;
      isError = true;
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

  Widget errorWidgets({required String errorMessage}) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.warning),
          Text(errorMessage),
          ElevatedButton(
            onPressed: getData,
            child: const Text("Try again"),
          )
        ],
      ),
    );
  }

  Widget listDataWidget() {
    List<dynamic> filteredList = bucketListData.where((element) {
      return !(element['completed']);
    }).toList();
    return filteredList.isEmpty
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("No Data on Bucket List"),
                ElevatedButton(
                  onPressed: () => getData(),
                  child: const Text("Load Data"),
                ),
              ],
            ),
          )
        : ListView.builder(
            itemCount: bucketListData.length,
            itemBuilder: (BuildContext connect, int index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: (bucketListData[index] is Map)
                    ? ListTile(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                // ignore: prefer_const_constructors
                                return ViewItem(
                                  title:
                                      bucketListData[index]['item'].toString(),
                                  image:
                                      bucketListData[index]['image'].toString(),
                                  index: index,
                                );
                              },
                            ),
                          ).then(
                            (value) {
                              if (value == "refresh") {
                                getData();
                              }
                            },
                          );
                        },
                        leading: CircleAvatar(
                          radius: 25,
                          backgroundImage: NetworkImage(
                              bucketListData[index]?['image'] ?? ""),
                        ),
                        title: Text(bucketListData[index]?['item'] ?? ""),
                        trailing: Text(
                          bucketListData[index]?['cost'].toString() ?? "",
                        ),
                      )
                    : const SizedBox(),
              );
            },
          );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, "/add");
        },
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
            : isError
                ? errorWidgets(errorMessage: "Error get Loading Data from")
                :
                // bucketListData.isEmpty
                //     ? const Center(child: Text("No Data on Bucket List"))
                //     :
                listDataWidget(),
      ),
    );
  }
}
