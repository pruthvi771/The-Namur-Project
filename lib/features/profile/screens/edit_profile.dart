import 'package:active_ecommerce_flutter/custom/device_info.dart';
import 'package:active_ecommerce_flutter/custom/input_decorations.dart';
import 'package:active_ecommerce_flutter/custom/toast_component.dart';
import 'package:active_ecommerce_flutter/features/profile/enum.dart';
import 'package:active_ecommerce_flutter/features/profile/hive_bloc/hive_bloc.dart';
import 'package:active_ecommerce_flutter/features/profile/hive_bloc/hive_event.dart';
import 'package:active_ecommerce_flutter/features/profile/hive_bloc/hive_state.dart';
import 'package:active_ecommerce_flutter/features/profile/hive_models/models.dart';
import 'package:active_ecommerce_flutter/features/profile/screens/more_details.dart';
import 'package:flutter/material.dart';
import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:toast/toast.dart';

import 'package:active_ecommerce_flutter/features/profile/address_list.dart'
    as addressList;

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  // TextEditingController _districtController = TextEditingController();
  // TextEditingController _talukController = TextEditingController();
  TextEditingController _hobliController = TextEditingController();
  TextEditingController _villageController = TextEditingController();

  TextEditingController _village2Controller = TextEditingController();
  TextEditingController _synoController = TextEditingController();
  TextEditingController _areaController = TextEditingController();

  TextEditingController _aadharController = TextEditingController();
  TextEditingController _panController = TextEditingController();
  TextEditingController _gstController = TextEditingController();

  TextEditingController _yieldController = TextEditingController();

  final districts = addressList.districtTalukMap;

  final cropsList = addressList.crops;
  final equipmentsList = addressList.equipment;

  List<String> taluks = [];

  String districtDropdownValue = addressList.districtTalukMap[0][0] as String;
  String talukDropdownValue = addressList.districtTalukMap[1][0] as String;

  String landDropdownValue = '';

  String cropDropdownValue = '';
  String equipmentDropdownValue = '';

  void _addAddressToHive(district, taluk, hobli, village) async {
    var dataBox = Hive.box<ProfileData>('profileDataBox3');

    var savedData = dataBox.get('profile');

    if (savedData!.address.length != 0) {
      ToastComponent.showDialog('You have already added an address',
          gravity: Toast.center, duration: Toast.lengthLong);
      return;
    }
    if (district.isEmpty) {
      ToastComponent.showDialog('Select District',
          gravity: Toast.center, duration: Toast.lengthLong);
      return;
    }
    if (taluk.isEmpty) {
      ToastComponent.showDialog('Select Taluk',
          gravity: Toast.center, duration: Toast.lengthLong);
      return;
    }
    if (hobli.isEmpty) {
      ToastComponent.showDialog('Please Enter Hobli',
          gravity: Toast.center, duration: Toast.lengthLong);
      return;
    }
    if (village.isEmpty) {
      ToastComponent.showDialog('Please Enter Village',
          gravity: Toast.center, duration: Toast.lengthLong);
      return;
    }

    var address = Address()
      ..district = district
      ..taluk = taluk
      ..hobli = hobli
      ..village = village;

    if (savedData != null) {
      print('object detected');
      print(savedData.id);
      var newData = ProfileData()
        ..id = savedData.id
        ..updated = savedData.updated
        ..address = [...savedData.address, address]
        ..kyc = savedData.kyc
        ..land = savedData.land;

      await dataBox.put(newData.id, newData);
      print('object updated');
    }

    _hobliController.clear();
    _villageController.clear();

    BlocProvider.of<HiveBloc>(context).add(
      HiveDataRequested(),
      // HiveAppendAddress(context: context),
    );
    // } else {
    //   ToastComponent.showDialog('Only 2 Addresses are allowed',
    //       gravity: Toast.center, duration: Toast.lengthLong);
    //   return;
    // }
  }

  void _addLandToHive(area, syno, village) async {
    if (village.isEmpty) {
      ToastComponent.showDialog('Enter Village name',
          gravity: Toast.center, duration: Toast.lengthLong);
      return;
    }

    if (syno.isEmpty) {
      ToastComponent.showDialog('Enter Sy No',
          gravity: Toast.center, duration: Toast.lengthLong);
      return;
    }

    if (area.isEmpty) {
      ToastComponent.showDialog('Enter Area name',
          gravity: Toast.center, duration: Toast.lengthLong);
      return;
    }

    double areaDouble = 0.0;
    try {
      areaDouble = double.parse(area);
    } catch (e) {
      ToastComponent.showDialog('Please Enter Valid Area',
          gravity: Toast.center, duration: Toast.lengthLong);
      return;
    }

    var dataBox = Hive.box<ProfileData>('profileDataBox3');

    var savedData = dataBox.get('profile');

    var land = Land()
      ..area = areaDouble
      ..syno = syno
      ..village = village
      ..crops = []
      ..equipments = [];

    if (savedData != null) {
      print('object detected');
      print(savedData.id);
      var newData = ProfileData()
        ..id = savedData.id
        ..updated = savedData.updated
        ..address = savedData.address
        ..kyc = savedData.kyc
        ..land = [...savedData.land, land];

      await dataBox.put(newData.id, newData);
      print('object updated');
    }

    _areaController.clear();
    _synoController.clear();
    _village2Controller.clear();

    BlocProvider.of<HiveBloc>(context).add(
      HiveDataRequested(),
      // HiveAppendAddress(context: context),
    );
  }

  void initState() {
    super.initState();
    var dataBox = Hive.box<ProfileData>('profileDataBox3');

    var savedData = dataBox.get('profile');

    if (savedData == null) {
      var kyc = KYC()
        ..aadhar = ''
        ..pan = ''
        ..gst = '';
      var emptyProfileData = ProfileData()
        ..id = 'profile'
        ..updated = true
        ..address = []
        ..kyc = kyc
        ..land = [];
      dataBox.put(emptyProfileData.id, emptyProfileData);
    }
    BlocProvider.of<HiveBloc>(context).add(
      HiveDataRequested(),
      // HiveAppendAddress(context: context),
    );
  }

  void _saveKycToHive(aadhar, pan, gst) async {
    if (aadhar.length != 12) {
      ToastComponent.showDialog('Enter a valid Aadhar Number',
          gravity: Toast.center, duration: Toast.lengthLong);
      return;
    }

    // if (pan.length != 12) {
    //   ToastComponent.showDialog('Enter a valid PAN Card Number',
    //       gravity: Toast.center, duration: Toast.lengthLong);
    //   return;
    // }

    // if (gst.length != 15) {
    //   ToastComponent.showDialog('Enter a valid GST Number',
    //       gravity: Toast.center, duration: Toast.lengthLong);
    //   return;
    // }

    var dataBox = Hive.box<ProfileData>('profileDataBox3');

    var savedData = dataBox.get('profile');

    if (savedData != null) {
      var kyc = KYC()
        ..aadhar = aadhar
        ..pan = pan
        ..gst = gst;

      var newData = ProfileData()
        ..id = savedData.id
        ..updated = savedData.updated
        ..address = savedData.address
        ..kyc = kyc
        ..land = savedData.land;

      await dataBox.put(newData.id, newData);
    }

    BlocProvider.of<HiveBloc>(context).add(
      HiveDataRequested(),
    );
  }

  void _deleteKycFromHive() async {
    var dataBox = Hive.box<ProfileData>('profileDataBox3');

    var savedData = dataBox.get('profile');

    if (savedData != null) {
      var kyc = KYC()
        ..aadhar = ''
        ..pan = ''
        ..gst = '';

      var newData = ProfileData()
        ..id = savedData.id
        ..updated = savedData.updated
        ..address = savedData.address
        ..kyc = kyc
        ..land = savedData.land;

      await dataBox.put(newData.id, newData);
    }

    BlocProvider.of<HiveBloc>(context).add(
      HiveDataRequested(),
    );
  }

  void _deleteDataFromHive(DataCollectionType dataCollectionType, index) async {
    var dataBox = Hive.box<ProfileData>('profileDataBox3');

    var savedData = dataBox.get('profile');

    if (dataCollectionType == DataCollectionType.address) {
      savedData!.address.removeAt(index);
    } else if (dataCollectionType == DataCollectionType.land) {
      landDropdownValue = '';
      savedData!.land.removeAt(index);
    }

    var newData = ProfileData()
      ..id = savedData!.id
      ..updated = savedData.updated
      ..address = savedData.address
      ..kyc = savedData.kyc
      ..land = savedData.land;

    await dataBox.put(newData.id, newData);

    BlocProvider.of<HiveBloc>(context).add(
      HiveDataRequested(),
      // HiveAppendAddress(context: context),
    );
  }

  void _addCropToHive(landSyno, crop, yieldOfCrop) async {
    if (landSyno.isEmpty) {
      ToastComponent.showDialog('Select Land',
          gravity: Toast.center, duration: Toast.lengthLong);
      return;
    }

    if (crop.isEmpty) {
      ToastComponent.showDialog('Select Crop',
          gravity: Toast.center, duration: Toast.lengthLong);
      return;
    }

    if (yieldOfCrop.isEmpty) {
      ToastComponent.showDialog('Enter Yield',
          gravity: Toast.center, duration: Toast.lengthLong);
      return;
    }

    double yieldOfCropDouble = 0.0;
    try {
      yieldOfCropDouble = double.parse(yieldOfCrop);
    } catch (e) {
      ToastComponent.showDialog('Please Enter Valid Yield',
          gravity: Toast.center, duration: Toast.lengthLong);
      return;
    }

    var dataBox = Hive.box<ProfileData>('profileDataBox3');

    var savedData = dataBox.get('profile');

    // Find the Land instance with the specified syno
    int index = savedData!.land.indexWhere((land) => land.syno == landSyno);

    if (index != -1) {
      savedData.land[index].crops.add(Crop()
        ..name = crop
        ..yieldOfCrop = yieldOfCropDouble);

      dataBox.put(savedData.id, savedData);

      print('Crop added');
    } else {
      // Handle the case where the Land instance with the specified syno is not found
      print('Land with syno $landSyno not found.');
    }

    // var land = Land()
    //   ..area = areaDouble
    //   ..syno = syno
    //   ..village = village
    //   ..crops = []
    //   ..equipments = [];

    // // if (savedData != null) {
    //   print('object detected');
    //   print(savedData!.id);

    //   var newData = ProfileData()
    //     ..id = savedData!.id
    //     ..updated = savedData.updated
    //     ..address = savedData.address
    //     ..kyc = savedData.kyc
    //     ..land = [...savedData.land, land];

    //   await dataBox.put(newData.id, newData);
    //   print('object updated');
    // // }

    _yieldController.clear();

    BlocProvider.of<HiveBloc>(context).add(
      HiveDataRequested(),
    );
  }

  void _deleteCropFromHive(landSyno, indexToDelete) async {
    var dataBox = Hive.box<ProfileData>('profileDataBox3');

    var savedData = dataBox.get('profile');

    // Find the Land instance with the specified syno
    int index = savedData!.land.indexWhere((land) => land.syno == landSyno);

    if (index != -1) {
      savedData.land[index].crops.removeAt(indexToDelete);

      dataBox.put(savedData.id, savedData);

      print('Crop removed');
    } else {
      // Handle the case where the Land instance with the specified syno is not found
      print('Land with syno $landSyno not found.');
    }

    BlocProvider.of<HiveBloc>(context).add(
      HiveDataRequested(),
    );
  }

  List<Crop> getCropsForSyno(ProfileData profileData, String landSyno) {
    int index = profileData.land.indexWhere((land) => land.syno == landSyno);
    // if (index != -1) {
    return profileData.land[index].crops;
  }

  List<String> getMachinesForSyno(ProfileData profileData, String landSyno) {
    int index = profileData.land.indexWhere((land) => land.syno == landSyno);
    // if (index != -1) {
    return profileData.land[index].equipments;
  }

  void _addEquipmentToHive(landSyno, equipment) async {
    if (landSyno.isEmpty) {
      ToastComponent.showDialog('Select Land',
          gravity: Toast.center, duration: Toast.lengthLong);
      return;
    }

    if (equipment.isEmpty) {
      ToastComponent.showDialog('Select Crop',
          gravity: Toast.center, duration: Toast.lengthLong);
      return;
    }

    var dataBox = Hive.box<ProfileData>('profileDataBox3');

    var savedData = dataBox.get('profile');

    // Find the Land instance with the specified syno
    int index = savedData!.land.indexWhere((land) => land.syno == landSyno);

    if (index != -1) {
      savedData.land[index].equipments.add(equipment);

      dataBox.put(savedData.id, savedData);

      print('equipment added');
    } else {
      // Handle the case where the Land instance with the specified syno is not found
      print('Land with syno $landSyno not found.');
    }

    BlocProvider.of<HiveBloc>(context).add(
      HiveDataRequested(),
    );
  }

  void _deleteEquipmentFromHive(landSyno, indexToDelete) async {
    var dataBox = Hive.box<ProfileData>('profileDataBox3');

    var savedData = dataBox.get('profile');

    // Find the Land instance with the specified syno
    int index = savedData!.land.indexWhere((land) => land.syno == landSyno);

    if (index != -1) {
      savedData.land[index].equipments.removeAt(indexToDelete);

      dataBox.put(savedData.id, savedData);

      print('equipment removed');
    } else {
      // Handle the case where the Land instance with the specified syno is not found
      print('Land with syno $landSyno not found.');
    }

    BlocProvider.of<HiveBloc>(context).add(
      HiveDataRequested(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: DeviceInfo(context).height,
      child: Scaffold(
        // key: homeData.scaffoldKey,
        // drawer: const MainDrawer(),
        backgroundColor: Colors.transparent,
        appBar: buildCustomAppBar(context),
        body: BlocListener<HiveBloc, HiveState>(
          listener: (context, state) {
            if (state is Error) {
              print('STATE: Error: ${state.error}');
            }
            if (state is HiveDataNotReceived) {
              print('STATE: No Data Found');
            }
            if (state is HiveDataReceived) {
              print('STATE: Data Received');
              print(state.profileData.land);
            }
          },
          child: BlocBuilder<HiveBloc, HiveState>(
            builder: (context, state) {
              if (state is Loading)
                return Center(
                  child: CircularProgressIndicator(),
                );
              if (state is HiveDataReceived)
                return ListView(
                  physics: BouncingScrollPhysics(),
                  padding: EdgeInsets.all(15),
                  children: [
                    // The top bar section
                    SizedBox(
                      height: 10,
                    ),
                    HeadingTextWidget('KYC'),

                    if (state.profileData.kyc.aadhar.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 3),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: MyTheme.green_lighter,
                          ),
                          padding:
                              EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                        'Aadhar: ${state.profileData.kyc.aadhar}'),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                        "PAN: ${state.profileData.kyc.pan == '' ? 'N/A' : state.profileData.kyc.pan}"),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                        "GST: ${state.profileData.kyc.gst == '' ? 'N/A' : state.profileData.kyc.gst}"),
                                  ),
                                ],
                              ),
                              // Expanded(child: Text('PAN')),
                              InkWell(
                                onTap: () {
                                  _deleteKycFromHive();
                                },
                                child: CircleAvatar(
                                  radius: 12,
                                  backgroundColor: MyTheme.green,
                                  child: Icon(
                                    Icons.delete,
                                    size: 15.0,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    SizedBox(
                      height: 10,
                    ),
                    if (state.profileData.kyc.aadhar.isEmpty)
                      Column(
                        children: [
                          TextFieldWidget('Aadhar Card', _aadharController,
                              'Enter Aadhar Card Number'),
                          Row(
                            children: [
                              Expanded(child: SizedBox.shrink()),
                              Text(
                                '${_aadharController.text.length}/12',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: _aadharController.text.length > 12
                                      ? Colors.red
                                      : _aadharController.text.length == 12
                                          ? Colors.green
                                          : Colors.grey,
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              )
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextFieldWidget('PAN Card', _panController,
                              'Enter PAN Card Number'),
                          TextFieldWidget(
                              'GST', _gstController, 'Enter GST Number'),
                          Row(
                            children: [
                              Expanded(child: SizedBox()),
                              TextButton(
                                child: Text('Save'),
                                onPressed: () {
                                  _saveKycToHive(_aadharController.text,
                                      _panController.text, _gstController.text);
                                },
                              ),
                            ],
                          ),
                        ],
                      ),

                    SizedBox(
                      height: 8,
                    ),
                    Divider(
                      // color: MyTheme.grey_153,
                      thickness: 2,
                    ),
                    SizedBox(
                      height: 12,
                    ),

                    HeadingTextWidget('Address Details'),
                    Column(
                      children: List.generate(
                        state.profileData.address.length,
                        (index) {
                          var item = state.profileData.address[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 3),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: MyTheme.green_lighter,
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 5),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(child: Text(item.district)),
                                  Expanded(child: Text(item.taluk)),
                                  Expanded(child: Text(item.hobli)),
                                  Expanded(child: Text(item.village)),
                                  InkWell(
                                    onTap: () {
                                      _deleteDataFromHive(
                                        DataCollectionType.address,
                                        index,
                                      );
                                    },
                                    child: CircleAvatar(
                                      radius: 12,
                                      backgroundColor: MyTheme.green,
                                      child: Icon(
                                        Icons.delete,
                                        size: 15.0,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),

                    //Dropdown for district
                    DropdownButtonWidget(
                        'District',
                        districts.map((district) {
                          return DropdownMenuItem<String>(
                            value: district[0] as String,
                            child: Text(district[0] as String),
                          );
                        }).toList(),
                        districtDropdownValue, (value) {
                      setState(() {
                        districtDropdownValue = value;
                        taluks = addressList.districtTalukMap.firstWhere(
                                (element) =>
                                    element[0] == districtDropdownValue)[1]
                            as List<String>;
                        talukDropdownValue = taluks[0];
                      });
                    }),

                    // Dropdown for Taluk
                    DropdownButtonWidget(
                        'Taluk',
                        taluks.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        talukDropdownValue, (value) {
                      setState(() {
                        talukDropdownValue = value;
                      });
                    }),

                    TextFieldWidget('Hobli', _hobliController, 'Enter Hobli'),
                    TextFieldWidget(
                        'Village', _villageController, 'Enter Village'),

                    Row(
                      children: [
                        Expanded(child: SizedBox()),
                        TextButton(
                          child: Text('Add Record'),
                          onPressed: () {
                            _addAddressToHive(
                                districtDropdownValue,
                                talukDropdownValue,
                                _hobliController.text,
                                _villageController.text);
                          },
                        ),
                      ],
                    ),

                    SizedBox(
                      height: 8,
                    ),
                    Divider(
                      // color: MyTheme.grey_153,
                      thickness: 2,
                    ),
                    SizedBox(
                      height: 12,
                    ),

                    HeadingTextWidget('Land Details'),
                    Column(
                      children: List.generate(
                        state.profileData.land.length,
                        (index) {
                          var item = state.profileData.land[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 3),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: MyTheme.green_lighter,
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 5),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(child: Text(item.village)),
                                  Expanded(child: Text(item.syno)),
                                  Expanded(child: Text(item.area.toString())),
                                  // Expanded(child: Text(item.village)),
                                  InkWell(
                                    onTap: () {
                                      _deleteDataFromHive(
                                        DataCollectionType.land,
                                        index,
                                      );
                                      setState(() {});
                                    },
                                    child: CircleAvatar(
                                      radius: 12,
                                      backgroundColor: MyTheme.green,
                                      child: Icon(
                                        Icons.delete,
                                        size: 15.0,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),

                    TextFieldWidget(
                        'Village', _village2Controller, 'Enter Village'),
                    TextFieldWidget('Syno', _synoController, 'Enter Syno'),

                    //custom Area text field for accepting double values
                    TexiFieldWidgetForDouble(
                        'Area', _areaController, 'Enter Area (in Acres)'),

                    //Add Land to Hive
                    Row(
                      children: [
                        Expanded(child: SizedBox()),
                        TextButton(
                          child: Text('Add Record'),
                          onPressed: () {
                            _addLandToHive(
                              _areaController.text,
                              _synoController.text,
                              _village2Controller.text,
                            );
                          },
                        ),
                      ],
                    ),

                    SizedBox(
                      height: 8,
                    ),
                    Divider(
                      // color: MyTheme.grey_153,
                      thickness: 2,
                    ),
                    SizedBox(
                      height: 12,
                    ),

                    HeadingTextWidget('Farm Details'),
                    SizedBox(
                      height: 10,
                    ),

                    (state.profileData.land.length == 0)
                        ? Padding(
                            padding: const EdgeInsets.all(20),
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                'Add Land First',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: .5,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            ),
                          )
                        : Column(
                            children: [
                              DropdownButtonWidget(
                                  'Select Land',
                                  List.generate(
                                    state.profileData.land.length + 1,
                                    (index) {
                                      var item = [
                                        Land()
                                          ..village = ''
                                          ..area = 0
                                          ..syno = '',
                                        ...state.profileData.land
                                      ][index];
                                      return DropdownMenuItem(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(child: Text(item.village)),
                                            Expanded(child: Text(item.syno)),
                                            Expanded(
                                                child:
                                                    Text(item.area.toString())),
                                            // Expanded(child: Text(item.village)),
                                          ],
                                        ),
                                        value: item.syno,
                                      );
                                    },
                                  ),
                                  landDropdownValue, (value) {
                                setState(() {
                                  landDropdownValue = value;
                                  setState(() {});
                                });
                              }),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 8, top: 10),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Add Crop',
                                    style: TextStyle(
                                        // color: MyTheme.accent_color,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                        letterSpacing: .5,
                                        fontFamily: 'Poppins'),
                                  ),
                                ),
                              ),
                              if (landDropdownValue.isNotEmpty)
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Wrap(
                                    children: List.generate(
                                      getCropsForSyno(state.profileData,
                                              landDropdownValue)
                                          .length,
                                      (index) {
                                        var item = getCropsForSyno(
                                            state.profileData,
                                            landDropdownValue)[index];
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 2),
                                          child: Chip(
                                            backgroundColor:
                                                MyTheme.green_lighter,
                                            labelPadding: EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 0),
                                            label: Text(
                                                '${item.name} (${item.yieldOfCrop.toInt()})'),
                                            // deleteIcon: Icon(Icons.delete),
                                            onDeleted: () {
                                              _deleteCropFromHive(
                                                  landDropdownValue, index);
                                              setState(() {});
                                            },
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              // for crop
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                child: Column(
                                  children: [
                                    DropdownButtonWidget(
                                        '',
                                        cropsList.map<DropdownMenuItem<String>>(
                                            (String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value),
                                          );
                                        }).toList(),
                                        cropDropdownValue, (value) {
                                      setState(() {
                                        cropDropdownValue = value;
                                      });
                                    }),
                                    TexiFieldWidgetForDouble(
                                        'Yield',
                                        _yieldController,
                                        'Enter Crop Yield (in Acres)'),
                                    Row(
                                      children: [
                                        Expanded(child: SizedBox()),
                                        TextButton(
                                          child: Text('Add Record'),
                                          onPressed: () {
                                            _addCropToHive(
                                              landDropdownValue,
                                              cropDropdownValue,
                                              _yieldController.text,
                                            );
                                            setState(() {});
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),

                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 8, top: 10),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Add Machines',
                                    style: TextStyle(
                                        // color: MyTheme.accent_color,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                        letterSpacing: .5,
                                        fontFamily: 'Poppins'),
                                  ),
                                ),
                              ),
                              if (landDropdownValue.isNotEmpty)
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Wrap(
                                    children: List.generate(
                                      getMachinesForSyno(state.profileData,
                                              landDropdownValue)
                                          .length,
                                      (index) {
                                        var item = getMachinesForSyno(
                                            state.profileData,
                                            landDropdownValue)[index];
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 2),
                                          child: Chip(
                                            backgroundColor:
                                                MyTheme.green_lighter,
                                            labelPadding: EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 0),
                                            label: Text(item),
                                            // deleteIcon: Icon(Icons.delete),
                                            onDeleted: () {
                                              _deleteEquipmentFromHive(
                                                  landDropdownValue, index);
                                              setState(() {});
                                            },
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                child: Column(
                                  children: [
                                    DropdownButtonWidget(
                                        '',
                                        equipmentsList
                                            .map<DropdownMenuItem<String>>(
                                                (String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value),
                                          );
                                        }).toList(),
                                        equipmentDropdownValue, (value) {
                                      setState(() {
                                        equipmentDropdownValue = value;
                                      });
                                    }),
                                    Row(
                                      children: [
                                        Expanded(child: SizedBox()),
                                        TextButton(
                                          child: Text('Add Record'),
                                          onPressed: () {
                                            _addEquipmentToHive(
                                              landDropdownValue,
                                              equipmentDropdownValue,
                                            );
                                            setState(() {});
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                    // SizedBox(
                    //   height: 8,
                    // ),
                    // Divider(
                    //   // color: MyTheme.grey_153,
                    //   thickness: 2,
                    // ),
                    // SizedBox(
                    //   height: 12,
                    // ),
                    // HeadingTextWidget('Machines and Equipments'),

                    // (state.profileData.land.length == 0)
                    //     ? Padding(
                    //         padding: const EdgeInsets.all(20),
                    //         child: Align(
                    //           alignment: Alignment.center,
                    //           child: Text(
                    //             'Add Land First',
                    //             style: TextStyle(
                    //               color: Colors.red,
                    //               fontSize: 18,
                    //               fontWeight: FontWeight.w500,
                    //               letterSpacing: .5,
                    //               fontFamily: 'Poppins',
                    //             ),
                    //           ),
                    //         ),
                    //       )
                    //     : Column(
                    //         children: [
                    //           // DropdownButtonWidget(
                    //           //     'Select Land',
                    //           //     List.generate(
                    //           //       state.profileData.land.length + 1,
                    //           //       (index) {
                    //           //         var item = [
                    //           //           Land()
                    //           //             ..village = ''
                    //           //             ..area = 0
                    //           //             ..syno = '',
                    //           //           ...state.profileData.land
                    //           //         ][index];
                    //           //         return DropdownMenuItem(
                    //           //           child: Row(
                    //           //             mainAxisAlignment:
                    //           //                 MainAxisAlignment.spaceBetween,
                    //           //             children: [
                    //           //               Expanded(child: Text(item.village)),
                    //           //               Expanded(child: Text(item.syno)),
                    //           //               Expanded(
                    //           //                   child:
                    //           //                       Text(item.area.toString())),
                    //           //               // Expanded(child: Text(item.village)),
                    //           //             ],
                    //           //           ),
                    //           //           value: item.syno,
                    //           //         );
                    //           //       },
                    //           //     ),
                    //           //     landDropdownValue, (value) {
                    //           //   setState(() {
                    //           //     landDropdownValue = value;
                    //           //     setState(() {});
                    //           //   });
                    //           // }),
                    //           if (landDropdownValue.isNotEmpty)
                    //             Align(
                    //               alignment: Alignment.topLeft,
                    //               child: Wrap(
                    //                 children: List.generate(
                    //                   getMachinesForSyno(state.profileData,
                    //                           landDropdownValue)
                    //                       .length,
                    //                   (index) {
                    //                     var item = getMachinesForSyno(
                    //                         state.profileData,
                    //                         landDropdownValue)[index];
                    //                     return Padding(
                    //                       padding: const EdgeInsets.symmetric(
                    //                           horizontal: 2),
                    //                       child: Chip(
                    //                         backgroundColor:
                    //                             MyTheme.green_lighter,
                    //                         labelPadding: EdgeInsets.symmetric(
                    //                             horizontal: 10, vertical: 0),
                    //                         label: Text(item),
                    //                         // deleteIcon: Icon(Icons.delete),
                    //                         onDeleted: () {
                    //                           _deleteEquipmentFromHive(
                    //                               landDropdownValue, index);
                    //                           setState(() {});
                    //                         },
                    //                       ),
                    //                     );
                    //                   },
                    //                 ),
                    //               ),
                    //             ),
                    //           DropdownButtonWidget(
                    //               'Select Machine',
                    //               equipmentsList.map<DropdownMenuItem<String>>(
                    //                   (String value) {
                    //                 return DropdownMenuItem<String>(
                    //                   value: value,
                    //                   child: Text(value),
                    //                 );
                    //               }).toList(),
                    //               equipmentDropdownValue, (value) {
                    //             setState(() {
                    //               equipmentDropdownValue = value;
                    //             });
                    //           }),
                    //           Row(
                    //             children: [
                    //               Expanded(child: SizedBox()),
                    //               TextButton(
                    //                 child: Text('Add Record'),
                    //                 onPressed: () {
                    //                   _addEquipmentToHive(
                    //                     landDropdownValue,
                    //                     equipmentDropdownValue,
                    //                   );
                    //                   setState(() {});
                    //                 },
                    //               ),
                    //             ],
                    //           ),
                    //         ],
                    //       ),
                  ],
                );
              return Container(
                color: Colors.white30,
                child: Text('Error'),
              );
            },
          ),
        ),
      ),
    );
  }

  Container CropDisplayWidget() {
    return Container(
      color: MyTheme.green_lighter,
      margin: EdgeInsets.all(5),
      padding: EdgeInsets.all(5),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text('Croperinsta',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 13,
            )),
        SizedBox(width: 8),
        CircleAvatar(
          radius: 12,
          backgroundColor: MyTheme.green,
          child: Icon(
            Icons.delete,
            size: 15.0,
            color: Colors.white,
          ),
        ),
      ]),
    );
  }

  Column TexiFieldWidgetForDouble(
      String title, TextEditingController _textController, String hintText) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Padding(
        //   padding: const EdgeInsets.only(left: 4, bottom: 5),
        //   child: Text(
        //     title,
        //     style: TextStyle(
        //         // color: MyTheme.accent_color,
        //         fontSize: 12,
        //         fontWeight: FontWeight.w500,
        //         letterSpacing: .5,
        //         fontFamily: 'Poppins'),
        //   ),
        // ),
        Container(
          height: 40,
          child: TextField(
            controller: _textController,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            autofocus: false,
            decoration:
                InputDecorations.buildInputDecoration_1(hint_text: hintText),
          ),
        ),
        SizedBox(
          height: 10,
        )
      ],
    );
  }

  Column DropdownButtonWidget(
      String title,
      List<DropdownMenuItem<String>>? itemList,
      String dropdownValue,
      Function(String) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 5),
          child: Text(
            title,
            style: TextStyle(
                // color: MyTheme.accent_color,
                fontSize: 12,
                fontWeight: FontWeight.w500,
                letterSpacing: .5,
                fontFamily: 'Poppins'),
          ),
        ),
        Container(
          height: 40,
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: Colors.grey, // You can customize the border color here
            ),
          ),
          child: DropdownButton<String>(
            isExpanded: true,
            value: dropdownValue,
            icon: Icon(Icons.arrow_drop_down),
            iconSize: 24,
            elevation: 16,
            underline: SizedBox(), // Remove the underline
            style: TextStyle(
              fontSize: 16,
              color: Colors.black, // You can customize the text color here
            ),
            onChanged: (String? value) {
              // This is called when the user selects an item.
              onChanged(value!);
            },
            // items: itemList.map<DropdownMenuItem<String>>((String value) {
            //   return DropdownMenuItem<String>(
            //     value: value,
            //     child: Text(value),
            //   );
            // }).toList(),
            items: itemList,
          ),
        ),
        SizedBox(
          height: 10,
        )
      ],
    );
  }

  Padding HeadingTextWidget(String headingText) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 7),
      child: Text(
        headingText,
        style: TextStyle(
            color: MyTheme.accent_color,
            fontSize: 25,
            fontWeight: FontWeight.w800,
            // letterSpacing: .5,
            // decoration: TextDecoration.underline,
            fontFamily: 'Poppins'),
      ),
    );
  }

  Column TextFieldWidget(
      String title, TextEditingController _textController, String hintText) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Padding(
        //   padding: const EdgeInsets.only(left: 4, bottom: 5),
        //   child: Text(
        //     title,
        //     style: TextStyle(
        //         // color: MyTheme.accent_color,
        //         fontSize: 12,
        //         fontWeight: FontWeight.w500,
        //         letterSpacing: .5,
        //         fontFamily: 'Poppins'),
        //   ),
        // ),
        Container(
          height: 40,
          child: TextField(
            onChanged: (value) {
              setState(() {});
            },
            controller: _textController,
            autofocus: false,
            decoration:
                InputDecorations.buildInputDecoration_1(hint_text: hintText),
          ),
        ),
        SizedBox(
          height: 10,
        )
      ],
    );
  }
}

PreferredSize buildCustomAppBar(context) {
  return PreferredSize(
    preferredSize: Size(DeviceInfo(context).width!, 80),
    child: Container(
      height: 92,
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xff107B28), Color(0xff4C7B10)])),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 30,
              ),
              Center(
                child: Text('Edit Profile',
                    style: TextStyle(
                        color: MyTheme.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        letterSpacing: .5,
                        fontFamily: 'Poppins')),
              ),
              Container(
                margin: EdgeInsets.only(right: 0),
                height: 30,
                child: Container(
                  child: InkWell(
                    //padding: EdgeInsets.zero,
                    onTap: () {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) {
                        return MoreDetails();
                      }));
                      // Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.keyboard_arrow_left,
                      size: 35,
                      color: MyTheme.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
