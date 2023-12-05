// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AddressAdapter extends TypeAdapter<Address> {
  @override
  final int typeId = 0;

  @override
  Address read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Address()
      ..district = fields[0] as String
      ..taluk = fields[1] as String
      ..hobli = fields[2] as String
      ..village = fields[3] as String
      ..pincode = fields[4] as String;
  }

  @override
  void write(BinaryWriter writer, Address obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.district)
      ..writeByte(1)
      ..write(obj.taluk)
      ..writeByte(2)
      ..write(obj.hobli)
      ..writeByte(3)
      ..write(obj.village)
      ..writeByte(4)
      ..write(obj.pincode);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AddressAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class KYCAdapter extends TypeAdapter<KYC> {
  @override
  final int typeId = 1;

  @override
  KYC read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return KYC()
      ..aadhar = fields[0] as String
      ..pan = fields[1] as String
      ..gst = fields[2] as String;
  }

  @override
  void write(BinaryWriter writer, KYC obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.aadhar)
      ..writeByte(1)
      ..write(obj.pan)
      ..writeByte(2)
      ..write(obj.gst);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is KYCAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class LandAdapter extends TypeAdapter<Land> {
  @override
  final int typeId = 2;

  @override
  Land read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Land()
      ..village = fields[0] as String
      ..syno = fields[1] as String
      ..area = fields[2] as double
      ..crops = (fields[3] as List).cast<Crop>()
      ..equipments = (fields[4] as List).cast<String>();
  }

  @override
  void write(BinaryWriter writer, Land obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.village)
      ..writeByte(1)
      ..write(obj.syno)
      ..writeByte(2)
      ..write(obj.area)
      ..writeByte(3)
      ..write(obj.crops)
      ..writeByte(4)
      ..write(obj.equipments);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LandAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ProfileDataAdapter extends TypeAdapter<ProfileData> {
  @override
  final int typeId = 3;

  @override
  ProfileData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProfileData()
      ..id = fields[0] as String
      ..updated = fields[1] as bool
      ..address = (fields[2] as List).cast<Address>()
      ..kyc = fields[3] as KYC
      ..land = (fields[4] as List).cast<Land>();
  }

  @override
  void write(BinaryWriter writer, ProfileData obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.updated)
      ..writeByte(2)
      ..write(obj.address)
      ..writeByte(3)
      ..write(obj.kyc)
      ..writeByte(4)
      ..write(obj.land);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProfileDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class CropAdapter extends TypeAdapter<Crop> {
  @override
  final int typeId = 4;

  @override
  Crop read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Crop()
      ..name = fields[0] as String
      ..yieldOfCrop = fields[1] as double;
  }

  @override
  void write(BinaryWriter writer, Crop obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.yieldOfCrop);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CropAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PrimaryLocationAdapter extends TypeAdapter<PrimaryLocation> {
  @override
  final int typeId = 5;

  @override
  PrimaryLocation read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PrimaryLocation()
      ..id = fields[0] as String
      ..isAddress = fields[1] as bool
      ..latitude = fields[2] as double
      ..longitude = fields[3] as double
      ..address = fields[4] as String?;
  }

  @override
  void write(BinaryWriter writer, PrimaryLocation obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.isAddress)
      ..writeByte(2)
      ..write(obj.latitude)
      ..writeByte(3)
      ..write(obj.longitude)
      ..writeByte(4)
      ..write(obj.address);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PrimaryLocationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SecondaryLocationsAdapter extends TypeAdapter<SecondaryLocations> {
  @override
  final int typeId = 6;

  @override
  SecondaryLocations read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SecondaryLocations()
      ..id = fields[0] as String
      ..address = (fields[1] as List).cast<String>();
  }

  @override
  void write(BinaryWriter writer, SecondaryLocations obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.address);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SecondaryLocationsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class CropCalendarItemAdapter extends TypeAdapter<CropCalendarItem> {
  @override
  final int typeId = 7;

  @override
  CropCalendarItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CropCalendarItem()
      ..cropName = fields[0] as String
      ..landSyno = fields[1] as String
      ..plantingDate = fields[2] as DateTime;
  }

  @override
  void write(BinaryWriter writer, CropCalendarItem obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.cropName)
      ..writeByte(1)
      ..write(obj.landSyno)
      ..writeByte(2)
      ..write(obj.plantingDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CropCalendarItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class CropCalendarDataAdapter extends TypeAdapter<CropCalendarData> {
  @override
  final int typeId = 8;

  @override
  CropCalendarData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CropCalendarData()
      ..cropCalendarItems = (fields[0] as List).cast<CropCalendarItem>();
  }

  @override
  void write(BinaryWriter writer, CropCalendarData obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.cropCalendarItems);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CropCalendarDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
