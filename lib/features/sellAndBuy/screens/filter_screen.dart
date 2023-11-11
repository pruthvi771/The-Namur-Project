import 'package:active_ecommerce_flutter/features/auth/models/auth_user.dart';
import 'package:active_ecommerce_flutter/features/auth/models/seller_group_item.dart';
import 'package:active_ecommerce_flutter/features/auth/services/auth_repository.dart';
import 'package:active_ecommerce_flutter/features/auth/services/firestore_repository.dart';
import 'package:active_ecommerce_flutter/features/profile/hive_models/models.dart';
import 'package:active_ecommerce_flutter/features/profile/models/userdata.dart';
import 'package:active_ecommerce_flutter/features/sellAndBuy/models/subSubCategory_filter_item.dart';
import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:active_ecommerce_flutter/screens/category_list.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:hive/hive.dart';
import '../../../custom/device_info.dart';

// import '../seller_platform/seller_platform.dart';

enum FilterSection {
  price,
  categories,
  sellerLocations,
}

class FilterScreen extends StatefulWidget {
  const FilterScreen({Key? key}) : super(key: key);

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  FilterSection sectionOpened = FilterSection.price;

  List<FilterItem> subSubCategoryList = [];
  List<FilterItem> locationsList = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: DeviceInfo(context).height,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 1,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xff107B28), Color(0xff4C7B10)]),
            ),
          ),
          title: Text(
            'Filters',
            // "new ",
            style: TextStyle(
                color: MyTheme.white,
                fontWeight: FontWeight.w500,
                letterSpacing: .5,
                fontFamily: 'Poppins'),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'Close',
                  style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontWeight: FontWeight.w500,
                      letterSpacing: .5,
                      fontFamily: 'Poppins'),
                ))
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Container(
                      color: Colors.grey[100],
                      child: ListView(
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                if (sectionOpened != FilterSection.price) {
                                  sectionOpened = FilterSection.price;
                                }
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.all(8),
                              height: 50,
                              color: sectionOpened == FilterSection.price
                                  ? Colors.white
                                  : Colors.grey[200],
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Price',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                if (sectionOpened != FilterSection.categories) {
                                  sectionOpened = FilterSection.categories;
                                }
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.all(8),
                              height: 50,
                              color: sectionOpened == FilterSection.categories
                                  ? Colors.white
                                  : Colors.grey[200],
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Categories',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                if (sectionOpened !=
                                    FilterSection.sellerLocations) {
                                  sectionOpened = FilterSection.sellerLocations;
                                }
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.all(8),
                              height: 50,
                              color:
                                  sectionOpened == FilterSection.sellerLocations
                                      ? Colors.white
                                      : Colors.grey[200],
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Seller\'s Location',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                      flex: 3,
                      child: sectionOpened == FilterSection.price
                          ? Container(color: Colors.white, child: Text('price'))
                          : sectionOpened == FilterSection.categories
                              ? Container(
                                  color: Colors.white,
                                  child: Text('categories'))
                              : Container(
                                  color: Colors.white, child: Text('location')))
                ],
              ),
            ),
            Divider(
              thickness: 2,
              height: 0,
            ),
            Container(
              padding:
                  EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 20),
              height: 70,
              color: Colors.white,
              child: Row(
                children: [
                  Expanded(child: SizedBox()),
                  Container(
                    // width: 100,
                    height: 40,
                    child: ElevatedButton(
                      onPressed: () {},
                      child: Text('Show Results'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: MyTheme.accent_color,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
