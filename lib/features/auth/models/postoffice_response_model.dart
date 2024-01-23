class PostOfficeResponse {
  String message;
  String status;
  List<PostOffice> postOffices;

  PostOfficeResponse({
    required this.message,
    required this.status,
    required this.postOffices,
  });

  factory PostOfficeResponse.fromJson(Map<String, dynamic> json) {
    var postOfficesList = json['PostOffice'] as List;
    List<PostOffice> postOffices = postOfficesList
        .map((postOfficeJson) => PostOffice.fromJson(postOfficeJson))
        .toList();

    return PostOfficeResponse(
      message: json['Message'],
      status: json['Status'],
      postOffices: postOffices,
    );
  }
}

class PostOffice {
  String name;
  String deliveryStatus;
  String circle;
  String district;
  String division;
  String region;
  String block;

  PostOffice({
    required this.name,
    required this.deliveryStatus,
    required this.circle,
    required this.district,
    required this.division,
    required this.region,
    required this.block,
  });

  factory PostOffice.fromJson(Map<String, dynamic> json) {
    return PostOffice(
      name: json['Name'],
      deliveryStatus: json['DeliveryStatus'],
      circle: json['Circle'],
      district: json['District'],
      division: json['Division'],
      region: json['Region'],
      block: json['Block'],
    );
  }
}
