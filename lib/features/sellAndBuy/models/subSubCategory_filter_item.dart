class FilterItem {
  final String name;
  bool isSelected;

  FilterItem({
    required this.name,
    required this.isSelected,
  });
}

enum LocationFilterType {
  district,
  taluk,
  gramPanchayat,
  village,
}

class LocationFilterMap {
  bool district;
  bool taluk;
  bool gramPanchayat;
  bool village;

  LocationFilterMap({
    required this.district,
    required this.taluk,
    required this.gramPanchayat,
    required this.village,
  });
}
