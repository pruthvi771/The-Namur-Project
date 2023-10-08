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

import 'package:active_ecommerce_flutter/features/profile/expanded_tile_widget.dart';
import 'package:active_ecommerce_flutter/features/profile/screens/land_screen.dart';
import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:hive/hive.dart';
import 'package:toast/toast.dart';
import '../../../custom/device_info.dart';

import 'package:flutter_expanded_tile/flutter_expanded_tile.dart';
import 'package:percent_indicator/percent_indicator.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final String title = 'KYC';
  var _textController = TextEditingController();
  String hintText = "Email ID";

  // TextEditingController _districtController = TextEditingController();
  // TextEditingController _talukController = TextEditingController();
  // TextEditingController _hobliController = TextEditingController();
  // TextEditingController _villageController = TextEditingController();

  TextEditingController _village2Controller = TextEditingController();
  TextEditingController _synoController = TextEditingController();
  TextEditingController _areaController = TextEditingController();

  TextEditingController _aadharController = TextEditingController();
  TextEditingController _panController = TextEditingController();
  TextEditingController _gstController = TextEditingController();

  String districtDropdownValue = '';
  String talukDropdownValue = '';
  String hobliDropdownValue = '';
  String villageDropdownValue = '';

  var districtList = [
    '',
    'District 1',
    'District 2',
    'District 3',
    'District 4',
    'District 5',
    'District 6',
    'District 7',
    'District 8',
  ];

  var talukList = [
    '',
    'Taluk A',
    'Taluk B',
    'Taluk C',
    'Taluk D',
    'Taluk E',
    'Taluk F',
    'Taluk G',
    'Taluk H',
  ];

  var hobliList = [
    '',
    'Hobli X',
    'Hobli Y',
    'Hobli Z',
    'Hobli P',
    'Hobli Q',
    'Hobli R',
    'Hobli S',
    'Hobli T',
  ];

  var villageList = [
    '',
    'Village 1',
    'Village 2',
    'Village 3',
    'Village 4',
    'Village 5',
    'Village 6',
    'Village 7',
    'Village 8',
  ];

  void _viewDataFromHive() {
    var dataBox = Hive.box<ProfileData>('profileDataBox3');

    // dataBox.clear();
    print('viewing them');

    var savedData = dataBox.get('profile');

    if (savedData != null) {
      print('Length: ${savedData.address.length}');

      for (var address in savedData.address) {
        print(
            'Address: ${address.district}, ${address.taluk}, ${address.hobli}, ${address.village}');
      }
    } else {
      print('Data not found');
    }
  }

  void _clearHive() {
    var dataBox = Hive.box<ProfileData>('profileDataBox3');

    // dataBox.clear();
    print('Hive cleared');
  }

  // void _addAddressToHive(district, taluk, hobli, village) async {
  //   var dataBox = Hive.box<ProfileData>('profileDataBox3');

  //   var savedData = dataBox.get('profile');

  //   var address = Address()
  //     ..district = district
  //     ..taluk = taluk
  //     ..hobli = hobli
  //     ..village = village;

  //   if (savedData != null) {
  //     print('object detected');
  //     print(savedData.id);
  //     var newData = ProfileData()
  //       ..id = savedData.id
  //       ..updated = savedData.updated
  //       ..address = [...savedData.address, address]
  //       ..kyc = savedData.kyc
  //       ..land = savedData.land;

  //     await dataBox.put(newData.id, newData);
  //     print('object updated');
  //   }

  //   BlocProvider.of<HiveBloc>(context).add(
  //     HiveDataRequested(),
  //     // HiveAppendAddress(context: context),
  //   );
  // }

  void _addAddressToHive(district, taluk, hobli, village) async {
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
      ToastComponent.showDialog('Select Hobli',
          gravity: Toast.center, duration: Toast.lengthLong);
      return;
    }
    if (village.isEmpty) {
      ToastComponent.showDialog('Select Village',
          gravity: Toast.center, duration: Toast.lengthLong);
      return;
    }

    var dataBox = Hive.box<ProfileData>('profileDataBox3');

    var savedData = dataBox.get('profile');

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

    BlocProvider.of<HiveBloc>(context).add(
      HiveDataRequested(),
      // HiveAppendAddress(context: context),
    );
  }

  void _addLandToHive(area, syno, village) async {
    if (area == 0) {
      ToastComponent.showDialog('Enter Area name',
          gravity: Toast.center, duration: Toast.lengthLong);
      return;
    }
    if (syno.isEmpty) {
      ToastComponent.showDialog('Enter Sy No',
          gravity: Toast.center, duration: Toast.lengthLong);
      return;
    }

    if (village.isEmpty) {
      ToastComponent.showDialog('Enter Village name',
          gravity: Toast.center, duration: Toast.lengthLong);
      return;
    }

    var dataBox = Hive.box<ProfileData>('profileDataBox3');

    var savedData = dataBox.get('profile');

    var land = Land()
      ..area = area
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

  void _saveKycToHive(KycSection kycSection, value) async {
    if (kycSection == KycSection.aadhar && value.length != 12) {
      ToastComponent.showDialog('Enter a valid Aadhar Number',
          gravity: Toast.center, duration: Toast.lengthLong);
      return;
    }

    if (kycSection == KycSection.pan && value.length != 12) {
      ToastComponent.showDialog('Enter a valid PAN Card Number',
          gravity: Toast.center, duration: Toast.lengthLong);
      return;
    }

    if (kycSection == KycSection.gst && value.length != 15) {
      ToastComponent.showDialog('Enter a valid GST Number',
          gravity: Toast.center, duration: Toast.lengthLong);
      return;
    }

    var dataBox = Hive.box<ProfileData>('profileDataBox3');

    var savedData = dataBox.get('profile');

    if (savedData != null) {
      var kyc = KYC()
        ..aadhar =
            kycSection == KycSection.aadhar ? value : savedData.kyc.aadhar
        ..pan = kycSection == KycSection.pan ? value : savedData.kyc.pan
        ..gst = kycSection == KycSection.gst ? value : savedData.kyc.gst;

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

  void _deleteKycFromHive(KycSection kycSection) async {
    var dataBox = Hive.box<ProfileData>('profileDataBox3');

    var savedData = dataBox.get('profile');

    if (savedData != null) {
      var kyc = KYC()
        ..aadhar = kycSection == KycSection.aadhar ? '' : savedData.kyc.aadhar
        ..pan = kycSection == KycSection.pan ? '' : savedData.kyc.pan
        ..gst = kycSection == KycSection.gst ? '' : savedData.kyc.gst;

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
                              Expanded(
                                  child: Text(
                                      'Aadhar: ${state.profileData.kyc.aadhar}')),
                              // Expanded(child: Text('PAN')),
                              InkWell(
                                onTap: () {
                                  _deleteKycFromHive(KycSection.aadhar);
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
                    if (state.profileData.kyc.pan.isNotEmpty)
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
                              Expanded(
                                  child: Text(
                                      'PAN: ${state.profileData.kyc.pan}')),
                              // Expanded(child: Text('PAN')),
                              InkWell(
                                onTap: () {
                                  _deleteKycFromHive(KycSection.pan);
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
                    if (state.profileData.kyc.gst.isNotEmpty)
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
                              Expanded(
                                  child: Text(
                                      'GST: ${state.profileData.kyc.gst}')),
                              // Expanded(child: Text('PAN')),
                              InkWell(
                                onTap: () {
                                  _deleteKycFromHive(KycSection.gst);
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
                              Expanded(child: SizedBox()),
                              TextButton(
                                child: Text('Save'),
                                onPressed: () {
                                  _saveKycToHive(KycSection.aadhar,
                                      _aadharController.text);
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    if (state.profileData.kyc.pan.isEmpty)
                      Column(
                        children: [
                          TextFieldWidget('PAN Card', _panController,
                              'Enter PAN Card Number'),
                          Row(
                            children: [
                              Expanded(child: SizedBox()),
                              TextButton(
                                child: Text('Save'),
                                onPressed: () {
                                  _saveKycToHive(
                                      KycSection.pan, _panController.text);
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    if (state.profileData.kyc.gst.isEmpty)
                      Column(
                        children: [
                          TextFieldWidget(
                              'GST', _gstController, 'Enter GST Number'),
                          Row(
                            children: [
                              Expanded(child: SizedBox()),
                              TextButton(
                                child: Text('Save'),
                                onPressed: () {
                                  _saveKycToHive(
                                      KycSection.gst, _gstController.text);
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
                    // TextFieldWidget(
                    //     'District', _districtController, 'Enter District'),
                    DropdownButtonWidget(
                        'District', districtList, districtDropdownValue,
                        (value) {
                      setState(() {
                        districtDropdownValue = value;
                      });
                    }),
                    DropdownButtonWidget('Taluk', talukList, talukDropdownValue,
                        (value) {
                      setState(() {
                        talukDropdownValue = value;
                      });
                    }),
                    DropdownButtonWidget('Hobli', hobliList, hobliDropdownValue,
                        (value) {
                      setState(() {
                        hobliDropdownValue = value;
                      });
                    }),
                    DropdownButtonWidget(
                        'Village', villageList, villageDropdownValue, (value) {
                      setState(() {
                        villageDropdownValue = value;
                      });
                    }),
                    Row(
                      children: [
                        Expanded(child: SizedBox()),
                        TextButton(
                          child: Text('Add Record'),
                          onPressed: () {
                            // print('District: ${_districtController.text}');
                            // print('taluk: ${_talukController.text}');
                            // print('hobli: ${_hobliController.text}');
                            // print('village: ${_villageController.text}');
                            // _addAddressToHive(
                            //     _districtController.text,
                            //     _talukController.text,
                            //     _hobliController.text,
                            //     _villageController.text);
                            // _districtController.clear();
                            // _talukController.clear();
                            // _hobliController.clear();
                            // _villageController.clear();
                            _addAddressToHive(
                                districtDropdownValue,
                                talukDropdownValue,
                                hobliDropdownValue,
                                villageDropdownValue);
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
                    TextFieldWidget(
                        'Area', _areaController, 'Enter Area (in acres)'),
                    Row(
                      children: [
                        Expanded(child: SizedBox()),
                        TextButton(
                          child: Text('Add Record'),
                          onPressed: () {
                            _addLandToHive(
                              int.parse(_areaController.text).toDouble(),
                              _synoController.text,
                              _village2Controller.text,
                            );
                          },
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
                    // HeadingTextWidget('Crops Grown and Planned'),
                    // TextFieldWidget('Crop', _textController, 'Enter Crop Name'),
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

  Column DropdownButtonWidget(String title, List<String> itemList,
      String dropdownValue, Function(String) onChanged) {
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
            items: itemList.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
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
          child: TextField(
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
