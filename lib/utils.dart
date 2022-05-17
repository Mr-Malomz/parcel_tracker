class AppConstant {
  final String projectId = "6282b18069da02a92d06";
  final String endpoint = "http://192.168.1.7/v1";
  final String collectionId = "6282b1c4a392b2dcbf3b";
}

class Parcel {
  String? $id;
  String parcel_img;
  String status;

  Parcel({this.$id, required this.parcel_img, required this.status});

  factory Parcel.fromJson(Map<dynamic, dynamic> json) {
    return Parcel(
        $id: json['\$id'],
        parcel_img: json['parcel_img'],
        status: json['status']);
  }

  Map<dynamic, dynamic> toJson() {
    return {'parcel_img': parcel_img, 'status': status};
  }
}
