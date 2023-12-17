import 'package:hive/hive.dart';

part 'models.g.dart'; // Hive Part File

@HiveType(typeId: 0)
class Address {
  @HiveField(0)
  late String district;

  @HiveField(1)
  late String taluk;

  @HiveField(2)
  late String gramPanchayat;

  @HiveField(3)
  late String village;

  @HiveField(4)
  late String pincode;
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

  @HiveField(5)
  late List<Animal> animals;
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

  @HiveField(2)
  late String id;
}

@HiveType(typeId: 5)
class PrimaryLocation {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late bool isAddress;

  @HiveField(2)
  late double latitude;

  @HiveField(3)
  late double longitude;

  @HiveField(4)
  late String? address;
}

@HiveType(typeId: 6)
class SecondaryLocations {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late List<String> address;
}

@HiveType(typeId: 7)
class CropCalendarItem {
  @HiveField(0)
  late String cropName;

  @HiveField(1)
  late String landSyno;

  @HiveField(2)
  late DateTime plantingDate;

  @HiveField(3)
  late String id;
}

@HiveType(typeId: 8)
class CropCalendarData {
  @HiveField(0)
  late List<CropCalendarItem> cropCalendarItems;
}

@HiveType(typeId: 9)
class Animal {
  @HiveField(0)
  late String name;

  @HiveField(1)
  late int quantity;
}
