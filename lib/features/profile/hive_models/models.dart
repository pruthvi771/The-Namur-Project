import 'package:hive/hive.dart';

part 'models.g.dart'; // Hive Part File

@HiveType(typeId: 0)
class Address {
  @HiveField(0)
  late String district;

  @HiveField(1)
  late String taluk;

  @HiveField(2)
  late String hobli;

  @HiveField(3)
  late String village;
}

@HiveType(typeId: 1)
class KYC {
  @HiveField(0)
  late String aadhar;

  @HiveField(1)
  late String pan;

  @HiveField(2)
  late String gst;
}

@HiveType(typeId: 2)
class Land {
  @HiveField(0)
  late String village;

  @HiveField(1)
  late String syno;

  @HiveField(2)
  late double area;

  @HiveField(3)
  late List<Crop> crops;

  @HiveField(4)
  late List<String> equipments;
}

@HiveType(typeId: 3)
class ProfileData {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late bool updated;

  @HiveField(2)
  late List<Address> address;

  @HiveField(3)
  late KYC kyc;

  @HiveField(4)
  late List<Land> land;
}

@HiveType(typeId: 4)
class Crop {
  @HiveField(0)
  late String name;

  @HiveField(1)
  late double yieldOfCrop;
}

@HiveType(typeId: 5)
class PrimaryLocation {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late double latitude;

  @HiveField(2)
  late double longitude;

  @HiveField(3)
  late String? address;
}
