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
  late List<String> crops;

  @HiveField(4)
  late List<String> equipments;
}

@HiveType(typeId: 3)
class Data {
  @HiveField(0)
  late bool updated;

  @HiveField(1)
  late Address address;

  @HiveField(2)
  late KYC kyc;

  @HiveField(3)
  late Land land;
}
