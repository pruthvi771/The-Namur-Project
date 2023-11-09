class SellerGroupItem {
  final String name;
  final String imageURL;
  final String sellerId;

  SellerGroupItem({
    required this.name,
    required this.imageURL,
    required this.sellerId,
  });

  // factory SellerGroupItem.fromJson(Map<String, dynamic> json) {
  //   return SellerGroupItem(
  //     name: json['name'],
  //     sellerId: json['']

  //   );
  // }

  // Map<String, dynamic> toJson() {
  //   return {
  //     'name': name,
  //     'email': email,
  //     // 'address': address,
  //     'phone number': phoneNumber,
  //     'location_id': locationId,
  //     'photoURL': photoURL,
  //   };
  // }
}
