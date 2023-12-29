// translation done.

import 'package:active_ecommerce_flutter/custom/toast_component.dart';
import 'package:active_ecommerce_flutter/features/profile/services/hive_bloc/hive_bloc.dart';
import 'package:active_ecommerce_flutter/features/profile/services/hive_bloc/hive_event.dart';
import 'package:active_ecommerce_flutter/features/profile/services/hive_bloc/hive_state.dart';
import 'package:active_ecommerce_flutter/features/sellAndBuy/models/subSubCategory_filter_item.dart';
import 'package:active_ecommerce_flutter/features/sellAndBuy/screens/buy_product_list.dart';
import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:active_ecommerce_flutter/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toast/toast.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum FilterSection {
  price,
  categories,
  sellerLocations,
}

enum SortType {
  ascending,
  descending,
}

class FilterScreen extends StatefulWidget {
  final SubCategoryEnum subCategoryEnum;
  final bool isSecondHand;
  final List<FilterItem> subSubCategoryList;
  final SortType? sortType;
  final LocationFilterMap locationFilterMap;
  final bool? isRent;

  const FilterScreen({
    Key? key,
    required this.subCategoryEnum,
    required this.isSecondHand,
    required this.subSubCategoryList,
    required this.sortType,
    required this.locationFilterMap,
    this.isRent,
  }) : super(key: key);

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  FilterSection sectionOpened = FilterSection.price;

  late List<FilterItem> subSubCategoryList;
  late List<FilterItem> locationsList;
  late LocationFilterMap newLocationFilterMap;

  SortType? sortType;

  @override
  void initState() {
    newLocationFilterMap = widget.locationFilterMap;
    BlocProvider.of<HiveBloc>(context).add(
      HiveDataRequested(),
    );
    subSubCategoryList = widget.subSubCategoryList.map((e) {
      return FilterItem(name: e.name, isSelected: e.isSelected);
    }).toList();

    sortType = widget.sortType;
    super.initState();
  }

  bool containsAtLeastOneSelected({required List<FilterItem> list}) {
    bool containsAtLeastOneSelected = false;
    for (var item in list) {
      if (item.isSelected) {
        containsAtLeastOneSelected = true;
        break;
      }
    }
    return containsAtLeastOneSelected;
  }

  void filterChange(LocationFilterType locationFilterType) {
    if (locationFilterType == LocationFilterType.district) {
      newLocationFilterMap.district = true;
      newLocationFilterMap.gramPanchayat = false;
      newLocationFilterMap.taluk = false;
      newLocationFilterMap.village = false;
    } else if (locationFilterType == LocationFilterType.taluk) {
      newLocationFilterMap.taluk = true;
      newLocationFilterMap.gramPanchayat = false;
      newLocationFilterMap.district = false;
      newLocationFilterMap.village = false;
    } else if (locationFilterType == LocationFilterType.gramPanchayat) {
      newLocationFilterMap.gramPanchayat = true;
      newLocationFilterMap.district = false;
      newLocationFilterMap.taluk = false;
      newLocationFilterMap.village = false;
    } else if (locationFilterType == LocationFilterType.village) {
      newLocationFilterMap.village = true;
      newLocationFilterMap.district = false;
      newLocationFilterMap.taluk = false;
      newLocationFilterMap.gramPanchayat = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          // 'Filters',
          AppLocalizations.of(context)!.filter_ucf,
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
                AppLocalizations.of(context)!.close_ucf,
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
                    color: Colors.grey[200],
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
                                : Colors.transparent,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                AppLocalizations.of(context)!.price_ucf,
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        ),
                        widget.isRent == null
                            ? GestureDetector(
                                onTap: () {
                                  setState(() {
                                    if (sectionOpened !=
                                        FilterSection.categories) {
                                      sectionOpened = FilterSection.categories;
                                    }
                                  });
                                },
                                child: Container(
                                  padding: EdgeInsets.all(8),
                                  height: 50,
                                  color:
                                      sectionOpened == FilterSection.categories
                                          ? Colors.white
                                          : Colors.transparent,
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      AppLocalizations.of(context)!
                                          .categories_ucf,
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                              )
                            : SizedBox.shrink(),
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
                                    : Colors.transparent,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                AppLocalizations.of(context)!.locations,
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w600),
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
                        ? Container(
                            color: Colors.white,
                            child: ListView(
                              children: [
                                SizedBox(
                                  height: 20,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        if (sortType == SortType.ascending) {
                                          sortType = null;
                                        } else {
                                          sortType = SortType.ascending;
                                        }
                                      });
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(8.0),
                                      height: 35,
                                      decoration: BoxDecoration(
                                          color: sortType != null
                                              ? sortType == SortType.ascending
                                                  ? const Color.fromARGB(
                                                      198, 216, 255, 199)
                                                  : Colors.blueGrey[50]
                                              : Colors.blueGrey[50],
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          border:
                                              Border.all(color: Colors.black)),
                                      child: Center(
                                          child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          // 'Price (Low to high)',
                                          AppLocalizations.of(context)!
                                              .price_low_to_high,
                                          style: TextStyle(
                                              fontSize: 13,
                                              color: sortType != null
                                                  ? sortType ==
                                                          SortType.ascending
                                                      ? MyTheme.primary_color
                                                      : Colors.black
                                                  : Colors.black,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      )),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        if (sortType == SortType.descending) {
                                          sortType = null;
                                        } else {
                                          sortType = SortType.descending;
                                        }
                                      });
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(8.0),
                                      height: 35,
                                      decoration: BoxDecoration(
                                          color: sortType != null
                                              ? sortType == SortType.descending
                                                  ? const Color.fromARGB(
                                                      198, 216, 255, 199)
                                                  : Colors.blueGrey[50]
                                              : Colors.blueGrey[50],
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          border:
                                              Border.all(color: Colors.black)),
                                      child: Center(
                                          child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          AppLocalizations.of(context)!
                                              .price_high_to_low,
                                          style: TextStyle(
                                              fontSize: 13,
                                              color: sortType != null
                                                  ? sortType ==
                                                          SortType.descending
                                                      ? MyTheme.primary_color
                                                      : Colors.black
                                                  : Colors.black,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      )),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )
                        : sectionOpened == FilterSection.categories
                            ? Container(
                                height: double.infinity,
                                // color: Colors.red[300],
                                padding:
                                    EdgeInsets.only(left: 8, right: 8, top: 20),
                                child: subSubCategoryList.length == 0
                                    ? Container(
                                        child: Text(
                                          AppLocalizations.of(context)!
                                              .no_data_is_available,
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black45,
                                          ),
                                        ),
                                      )
                                    : ListView.builder(
                                        itemCount: subSubCategoryList.length,
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        scrollDirection: Axis.vertical,
                                        itemBuilder: (context, index) {
                                          return Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Container(
                                              color: Colors.grey[200],
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      subSubCategoryList[index]
                                                          .name,
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                  ),
                                                  Checkbox(
                                                      activeColor:
                                                          MyTheme.primary_color,
                                                      value: subSubCategoryList[
                                                              index]
                                                          .isSelected,
                                                      onChanged: (value) {
                                                        setState(() {
                                                          subSubCategoryList[
                                                                      index]
                                                                  .isSelected =
                                                              value!;
                                                        });
                                                      }),
                                                ],
                                              ),
                                            ),
                                          );
                                        }))
                            : BlocBuilder<HiveBloc, HiveState>(
                                builder: (context, state) {
                                  if (state is HiveDataReceived) {
                                    return Column(
                                      children: [
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Expanded(
                                          child: ListView.builder(
                                            itemCount: state
                                                .profileData.address.length,
                                            itemBuilder: (context, index) {
                                              var addressObject = state
                                                  .profileData.address[index];
                                              return Column(
                                                children: [
                                                  CheckboxButton(
                                                    heading:
                                                        AppLocalizations.of(
                                                                context)!
                                                            .district,
                                                    title:
                                                        addressObject.district,
                                                    checkValue:
                                                        newLocationFilterMap
                                                            .district,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        filterChange(
                                                            LocationFilterType
                                                                .district);
                                                      });
                                                    },
                                                  ),
                                                  CheckboxButton(
                                                    heading:
                                                        AppLocalizations.of(
                                                                context)!
                                                            .taluk,
                                                    title: addressObject.taluk,
                                                    checkValue:
                                                        newLocationFilterMap
                                                            .taluk,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        filterChange(
                                                            LocationFilterType
                                                                .taluk);
                                                      });
                                                    },
                                                  ),
                                                  CheckboxButton(
                                                    heading:
                                                        AppLocalizations.of(
                                                                context)!
                                                            .gram_panchayat,
                                                    title: addressObject
                                                        .gramPanchayat,
                                                    checkValue:
                                                        newLocationFilterMap
                                                            .gramPanchayat,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        filterChange(
                                                            LocationFilterType
                                                                .gramPanchayat);
                                                      });
                                                    },
                                                  ),
                                                  CheckboxButton(
                                                    heading:
                                                        AppLocalizations.of(
                                                                context)!
                                                            .village,
                                                    title:
                                                        addressObject.village,
                                                    checkValue:
                                                        newLocationFilterMap
                                                            .village,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        filterChange(
                                                            LocationFilterType
                                                                .village);
                                                      });
                                                    },
                                                  ),
                                                ],
                                              );
                                            },
                                          ),
                                        )
                                      ],
                                    );
                                  }
                                  return Container(
                                    child: Text(AppLocalizations.of(context)!
                                        .no_data_is_available),
                                  );
                                },
                              ))
              ],
            ),
          ),
          Divider(
            thickness: 2,
            height: 0,
          ),
          Container(
            padding: EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 20),
            height: 70,
            color: Colors.white,
            child: Row(
              children: [
                Expanded(child: SizedBox()),
                Container(
                  height: 40,
                  child: ElevatedButton(
                    onPressed: () {
                      if (!containsAtLeastOneSelected(
                          list: subSubCategoryList)) {
                        ToastComponent.showDialog(
                            AppLocalizations.of(context)!
                                .select_at_least_one_category,
                            gravity: Toast.center,
                            duration: Toast.lengthLong);
                        return;
                      }
                      // pop until BuyProductList
                      Navigator.pop(context);
                      Navigator.pop(context);

                      Navigator.of(context).push(
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) {
                            return BuyProductList(
                              subCategoryEnum: widget.subCategoryEnum,
                              isSecondHand: widget.isSecondHand,
                              subSubCategoryList: subSubCategoryList,
                              locationFilterMap: newLocationFilterMap,
                              sortType: sortType,
                            );
                          },
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                            const begin = Offset(0.0, 0.0);
                            const end = Offset.zero;
                            const curve = Curves.easeInOut;
                            var tween = Tween(begin: begin, end: end)
                                .chain(CurveTween(curve: curve));
                            var offsetAnimation = animation.drive(tween);

                            return SlideTransition(
                              position: offsetAnimation,
                              child: child,
                            );
                          },
                        ),
                      );
                    },
                    child: Text(AppLocalizations.of(context)!.show_results),
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
    );
  }

  Container CheckboxButton({
    required String title,
    required bool checkValue,
    required void Function(bool?) onChanged,
    required String heading,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Text(heading.toUpperCase()),
          ),
          SizedBox(
            height: 3,
          ),
          Container(
            color: Colors.grey[200],
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                ),
                Checkbox(
                    activeColor: MyTheme.primary_color,
                    value: checkValue,
                    onChanged: (value) {
                      onChanged(value);
                    }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
