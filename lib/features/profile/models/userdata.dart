class BuyerData {
  final String name;
  final String email;
  final String? address;
  final String? phoneNumber;
  final String? locationId;
  final String? photoURL;

  BuyerData({
    required this.name,
    required this.email,
    this.address,
    this.phoneNumber,
    this.locationId,
    this.photoURL,
  });

  factory BuyerData.fromJson(Map<String, dynamic> json) {
    return BuyerData(
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      address: json['address'] ?? '',
      phoneNumber: json['phone number'] ?? '',
      locationId: json['location_id'] ?? '',
      photoURL: json['photoURL'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'address': address,
      'phone number': phoneNumber,
      'location_id': locationId,
      'photoURL': photoURL,
    };
  }
}

class User {
  final String name;
  final String email;
  final String address;
  final String? phoneNumber;
  final String? locationId;
  final String? productsBuy;
  final String? adhaarId;
  final bool? adhaarIdVerified;
  final String? gst;
  final bool? gstVerified;
  final String? pan;
  final bool? panVerified;
  final bool? profileComplete;
  final String? photoURL;

  User({
    required this.name,
    required this.email,
    required this.address,
    this.phoneNumber,
    this.locationId,
    this.productsBuy,
    this.adhaarId,
    this.adhaarIdVerified,
    this.gst,
    this.gstVerified,
    this.pan,
    this.panVerified,
    this.profileComplete,
    this.photoURL,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      address: json['address'] ?? '',
      phoneNumber: json['phone number'] ?? '',
      locationId: json['location_id'] ?? '',
      productsBuy: json['Products_Buy'] ?? '',
      adhaarId: json['adhaar_id'] ?? '',
      adhaarIdVerified: json['adhaar_id_verified'] ?? false,
      gst: json['GST'] ?? '',
      gstVerified: json['GST_verified'] ?? false,
      pan: json['PAN'] ?? '',
      panVerified: json['PAN_verified'] ?? false,
      profileComplete: json['profile_complete'] ?? false,
      photoURL: json['photoURL'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'address': address,
      'phone number': phoneNumber,
      'location_id': locationId,
      'Products_Buy': productsBuy,
      'adhaar_id': adhaarId,
      'adhaar_id_verified': adhaarIdVerified,
      'GST': gst,
      'GST_verified': gstVerified,
      'PAN': pan,
      'PAN_verified': panVerified,
      'profile_complete': profileComplete,
      'photoURL': photoURL,
    };
  }
}
