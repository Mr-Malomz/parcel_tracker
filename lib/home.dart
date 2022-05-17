import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:parcel_tracker/utils.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Parcel>? items;
  bool _isLoading = false;
  bool _isError = false;
  Client client = Client();
  Database? db;
  RealtimeSubscription? realtimeSubscription;

  @override
  void initState() {
    super.initState();
    client
        .setEndpoint(AppConstant().endpoint)
        .setProject(AppConstant().projectId);

    db = Database(client);
    _loadParcel();
    _subscribe();
  }

  _loadParcel() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final data =
          await db?.listDocuments(collectionId: AppConstant().collectionId);
      setState(() {
        items = data?.documents
            .map((parcel) => Parcel.fromJson(parcel.data))
            .toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _isError = true;
      });
      throw Exception('Error getting list of parcel');
    }
  }

  _subscribe() {
    final realtime = Realtime(client);
    String collectionID = AppConstant().collectionId;
    realtimeSubscription =
        realtime.subscribe(['collections.$collectionID.documents']);

    //listening to stream we can listen to
    realtimeSubscription!.stream.listen((e) {
      if (e.payload.isNotEmpty) {
        if (e.event == 'database.documents.update') {
          items!
              .map((element) => element.status = e.payload['status'])
              .toList();
          setState(() {});
        }
      }
    });
  }

  _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case "packed":
        return 0xffAEAEB2;
      case "shipped":
        return 0xffF1CFA0;
      case "in-transit":
        return 0xffD9D9F4;
      case "delivered":
        return 0xff92EAA8;
      default:
        return 0xffAEAEB2;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Parcel Tracker"),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _isError
              ? const Center(
                  child: Text(
                    'Error loading parcels',
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            const Text(
                              "Order ID:",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(width: 30.0),
                            Text(
                              items![0].$id!,
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15.0),
                        Row(
                          children: [
                            const Text(
                              "Status:",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(width: 30.0),
                            Container(
                              padding: const EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                color: Color(_getStatusColor(items![0].status)),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(20)),
                              ),
                              child: Text(
                                items![0].status,
                                style: TextStyle(fontWeight: FontWeight.w700),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 30.0),
                        Image.network(items![0].parcel_img),
                      ]),
                ),
    );
  }
}
