// translation done.

import 'dart:ffi';

import 'package:active_ecommerce_flutter/custom/toast_component.dart';
import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:toast/toast.dart';

class CheckoutAddressAdd extends StatefulWidget {
  final String uid;

  const CheckoutAddressAdd({
    Key? key,
    required this.uid,
  }) : super(key: key);

  @override
  State<CheckoutAddressAdd> createState() => _CheckoutAddressAddState();
}

class _CheckoutAddressAddState extends State<CheckoutAddressAdd> {
  TextEditingController _houseNameController = TextEditingController();
  TextEditingController _streetNameController = TextEditingController();
  TextEditingController _pincodeController = TextEditingController();
  TextEditingController _cityController = TextEditingController();
  TextEditingController _stateController = TextEditingController();
  TextEditingController _landmarkController = TextEditingController();

  onPressedPost(BuildContext buildContext) async {
    String houseName = _houseNameController.text.toString();
    String streetName = _streetNameController.text.toString();
    String pincode = _pincodeController.text.toString();
    String city = _cityController.text.toString();
    String state = _stateController.text.toString();
    String landmark = _landmarkController.text.toString();

    if (houseName == "") {
      ToastComponent.showDialog(AppLocalizations.of(context)!.enter_house_no,
          gravity: Toast.center, duration: Toast.lengthLong);
      return;
    }
    if (streetName == "") {
      ToastComponent.showDialog(AppLocalizations.of(context)!.enter_street_name,
          gravity: Toast.center, duration: Toast.lengthLong);
      return;
    }
    if (pincode == "") {
      ToastComponent.showDialog(AppLocalizations.of(context)!.enter_pincode,
          gravity: Toast.center, duration: Toast.lengthLong);
      return;
    }
    if (city == "") {
      ToastComponent.showDialog(AppLocalizations.of(context)!.enter_city,
          gravity: Toast.center, duration: Toast.lengthLong);
      return;
    }
    if (state == "") {
      ToastComponent.showDialog(AppLocalizations.of(context)!.enter_state,
          gravity: Toast.center, duration: Toast.lengthLong);
      return;
    }

    await FirebaseFirestore.instance.collection('buyer').doc(widget.uid).update(
      {
        'address': FieldValue.arrayUnion(
          [
            {
              'houseNumber': houseName,
              'streetName': streetName,
              'pincode': pincode,
              'city': city,
              'state': state,
              'landmark': landmark,
            }
          ],
        ),
      },
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(AppLocalizations.of(context)!.address_details,
            style: TextStyle(
                color: MyTheme.white,
                fontWeight: FontWeight.w500,
                letterSpacing: .5,
                fontFamily: 'Poppins')),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xff107B28), Color(0xff4C7B10)]),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.keyboard_arrow_left,
              size: 35,
              color: MyTheme.white,
            ),
          ),
          SizedBox(
            width: 10,
          ),
        ],
      ),
      bottomSheet: Container(
        height: 60,
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () async {
            await onPressedPost(context);
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(MyTheme.primary_color),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(0))),
          ),
          child: Text(
            AppLocalizations.of(context)!.add_address,
            style: TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500),
          ),
        ),
      ),
      body: bodycontent(),
    );
  }

  bodycontent() {
    return ListView(
      physics: BouncingScrollPhysics(),
      children: [
        SizedBox(
          height: 15,
        ),

        // house number
        Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0),
          child: Container(
            decoration: BoxDecoration(
                color: MyTheme.field_color,
                borderRadius: BorderRadius.circular(10)),
            child: TextFormField(
              controller: _houseNameController,
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(left: 15),
                hintText: AppLocalizations.of(context)!.house_no,
                hintStyle: TextStyle(
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Poppins'),
              ),
            ),
          ),
        ),

        SizedBox(
          height: 15,
        ),

        // street name
        Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0),
          child: Container(
            decoration: BoxDecoration(
                color: MyTheme.field_color,
                borderRadius: BorderRadius.circular(10)),
            child: TextFormField(
              controller: _streetNameController,
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(left: 15),
                hintText: AppLocalizations.of(context)!.street_name,
                hintStyle: TextStyle(
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Poppins'),
              ),
            ),
          ),
        ),

        SizedBox(
          height: 15,
        ),

        // landmark
        Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0),
          child: Container(
            decoration: BoxDecoration(
                color: MyTheme.field_color,
                borderRadius: BorderRadius.circular(10)),
            child: TextFormField(
              controller: _landmarkController,
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(left: 15),
                hintText: AppLocalizations.of(context)!.landmark_optional,
                hintStyle: TextStyle(
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Poppins'),
              ),
            ),
          ),
        ),

        SizedBox(
          height: 15,
        ),

        // city
        Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0),
          child: Container(
            decoration: BoxDecoration(
                color: MyTheme.field_color,
                borderRadius: BorderRadius.circular(10)),
            child: TextFormField(
              controller: _cityController,
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(left: 15),
                hintText: AppLocalizations.of(context)!.city_ucf,
                hintStyle: TextStyle(
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Poppins'),
              ),
            ),
          ),
        ),

        Container(
          margin: const EdgeInsets.only(top: 20.0, left: 20.0, right: 15.0),
          height: 50, // Specify a fixed height for the container
          child: Container(
            decoration: BoxDecoration(
              color: MyTheme.field_color,
              borderRadius: BorderRadius.circular(10),
            ),
            child: TextFormField(
              controller: _pincodeController,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly,
              ],
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(left: 15),
                hintText: 'Pincode',
                hintStyle: TextStyle(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
          ),
        ),

        SizedBox(
          height: 15,
        ),

        // state
        Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0),
          child: Container(
            decoration: BoxDecoration(
                color: MyTheme.field_color,
                borderRadius: BorderRadius.circular(10)),
            child: TextFormField(
              controller: _stateController,
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(left: 15),
                hintText: AppLocalizations.of(context)!.state_ucf,
                hintStyle: TextStyle(
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Poppins'),
              ),
            ),
          ),
        ),

        SizedBox(
          height: 60,
        ),
      ],
    );
  }

  Container DropdownButtonWidget(
      String title,
      String hintText,
      List<DropdownMenuItem<String>>? itemList,
      String? dropdownValue,
      Function(String) onChanged) {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      margin: EdgeInsets.only(top: 20, left: 20, right: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: MyTheme.field_color,
      ),
      child: DropdownButton<String>(
        hint: Text(
          hintText,
          style: TextStyle(
            color: Colors.grey,
            fontSize: 14,
          ),
        ),
        isExpanded: true,
        value: dropdownValue,
        icon: Icon(Icons.arrow_drop_down),
        iconSize: 24,
        elevation: 16,
        underline: SizedBox(),
        style: TextStyle(
          fontSize: 16,
          color: Colors.black,
        ),
        onChanged: (String? value) {
          onChanged(value!);
        },
        items: itemList,
      ),
    );
  }
}
