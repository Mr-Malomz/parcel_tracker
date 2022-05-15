import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
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
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text(
                "Order ID:",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(width: 30.0),
              Text(
                'Pending',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ],
          ),
          const SizedBox(height: 15.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
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
                  color: Color(_getStatusColor("Packed")!),
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                ),
                child: const Text(
                  'Packed',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
          const SizedBox(height: 30.0),
          Image.network(
              "https://res.cloudinary.com/dtgbzmpca/image/upload/v1652648108/parcel.png"),
        ]),
      ),
    );
  }
}
