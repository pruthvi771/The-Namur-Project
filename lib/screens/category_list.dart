import 'dart:ui';

import 'package:active_ecommerce_flutter/custom/box_decorations.dart';
import 'package:active_ecommerce_flutter/custom/btn.dart';
import 'package:active_ecommerce_flutter/custom/device_info.dart';
import 'package:active_ecommerce_flutter/features/auth/screens/add_phone.dart';
import 'package:active_ecommerce_flutter/features/calendar/screens/calendar_screen.dart';
import 'package:active_ecommerce_flutter/features/sellAndBuy/screens/my_purchases.dart';
import 'package:active_ecommerce_flutter/utils/hive_models/models.dart';
import 'package:active_ecommerce_flutter/features/screen_database.dart';
import 'package:active_ecommerce_flutter/features/sellAndBuy/screens/parent_screen.dart';
import 'package:active_ecommerce_flutter/features/sellAndBuy/screens/seller_orderlist.dart';
import 'package:active_ecommerce_flutter/helpers/shimmer_helper.dart';
import 'package:active_ecommerce_flutter/presenter/bottom_appbar_index.dart';
import 'package:active_ecommerce_flutter/screens/calender/calender.dart';
import 'package:active_ecommerce_flutter/screens/profile_edit.dart';
import 'package:active_ecommerce_flutter/utils/enums.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:active_ecommerce_flutter/drawer/drawer.dart';
import 'package:active_ecommerce_flutter/custom/toast_component.dart';
import 'package:hexagon/hexagon.dart';
import 'package:hive/hive.dart';
import 'package:toast/toast.dart';
import 'package:active_ecommerce_flutter/screens/category_products.dart';
import 'package:active_ecommerce_flutter/repositories/category_repository.dart';
import 'package:shimmer/shimmer.dart';
import 'package:active_ecommerce_flutter/app_config.dart';
import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../controller/sub_category_controller.dart';
import '../features/profile/screens/edit_profile.dart';
import '../presenter/home_presenter.dart';
import 'category/sub_category.dart';
import 'home_widget/buy_sell_button_widget.dart';
import 'home_widget/hexagonal_widget.dart';
import '../features/profile/title_bar_widget.dart';
import 'package:get/get.dart';

class CategoryList extends StatefulWidget {
  CategoryList({
    Key? key,
    this.parent_category_id = 0,
    this.parent_category_name = "",
    this.is_base_category = false,
    this.is_top_category = false,
    this.bottomAppbarIndex,
  }) : super(key: key);

  final int parent_category_id;
  final String parent_category_name;
  final bool is_base_category;
  final bool is_top_category;
  final BottomAppbarIndex? bottomAppbarIndex;

  @override
  _CategoryListState createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  SubCategoryController subCategoryCon = Get.put(SubCategoryController());
  HomePresenter homeData = HomePresenter();

  String color = "buy";
  bool isBuyActive = true;
  bool isvalue = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getProfileDataFuture = _getProfileData();
  }

  late Future<ProfileData> _getProfileDataFuture;

  Future<ProfileData> _getProfileData() async {
    var dataBox = Hive.box<ProfileData>('profileDataBox3');

    var savedData = dataBox.get('profile');
    if (savedData == null) {
      throw Exception('No data found');
    }
    return savedData;
  }

  double profileProgress = 0;

  double calculatingProfileProgress({required ProfileData profileData}) {
    var tempProgress = 0.0;

    if (!(profileData.address.length == 0)) {
      tempProgress += 0.2;
    }
    if (profileData.kyc.aadhar.isNotEmpty) {
      tempProgress += 0.2;
    }
    int cropCount = 0;

    for (Land land in profileData.land) {
      cropCount += land.crops.length;
    }

    if (cropCount > 0) {
      tempProgress += 0.2;
    }

    int machineCount = 0;

    for (Land land in profileData.land) {
      machineCount += land.equipments.length;
    }

    if (machineCount > 0) {
      tempProgress += 0.2;
    }

    if (!(profileData.land.length == 0)) {
      tempProgress += 0.2;
    }

    return tempProgress;
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection:
          app_language_rtl.$! ? TextDirection.rtl : TextDirection.ltr,
      child: Stack(children: [
        Scaffold(
            key: homeData.scaffoldKey,
            drawer: const MainDrawer(),
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              // elevation: 0,
              // backgroundColor: MyTheme.primary_color,
              flexibleSpace: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xff107B28), Color(0xff4C7B10)]),
                ),
              ),
              title: Text(
                AppLocalizations.of(context)!.home_ucf,
                style: TextStyle(
                    color: MyTheme.white,
                    fontWeight: FontWeight.w500,
                    letterSpacing: .5,
                    fontFamily: 'Poppins'),
              ),
              centerTitle: true,
            ),
            body: buildBody()),
        Align(
          alignment: Alignment.bottomCenter,
          child: widget.is_base_category || widget.is_top_category
              ? Container(
                  height: 0,
                )
              : buildBottomContainer(),
        )
      ]),
    );
  }

  Widget buildBody() {
    return FutureBuilder(
        future: _getProfileDataFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            profileProgress =
                calculatingProfileProgress(profileData: snapshot.data!);
            print('profile progress is $profileProgress');
            return Column(
              children: [
                TitleBar(),
                Expanded(
                  child: CustomScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    slivers: [
                      SliverList(
                          delegate: SliverChildListDelegate([
                        // TitleBar(),

                        // screen database button
                        TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          PurchaseHistoryScreen()));
                            },
                            child: Text('Purchase History')),

                        SizedBox(height: 15),

                        //Buy Sell Button Design
                        Center(
                          child: Stack(
                            children: [
                              Container(
                                height: 44,
                                width: 162,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: MyTheme.light_grey,
                                    border:
                                        Border.all(color: MyTheme.light_grey)),
                                child: Center(
                                    child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(),
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          color = "sell";
                                          isBuyActive = false;
                                          isvalue = false;
                                          CategoryList();
                                        });
                                        //  Navigator.push(context, MaterialPageRoute(builder: (context)=> ProductInventory() ));
                                      },
                                      child: Container(
                                        height: 44,
                                        width: 77,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            color: !isBuyActive
                                                ? MyTheme.primary_color
                                                : MyTheme.light_grey),
                                        child: Center(
                                          child: Text(
                                            "SELL",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color: !isBuyActive
                                                  ? MyTheme.white
                                                  : Colors.black,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )),
                              ),
                              Positioned(
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      isBuyActive = true;
                                      isvalue = true;
                                    });
                                  },
                                  child: Container(
                                    height: 44,
                                    width: 77,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        color: isBuyActive
                                            ? MyTheme.primary_color
                                            : MyTheme.light_grey),
                                    child: Center(
                                      child: Text(
                                        "BUY",
                                        textAlign: TextAlign.right,
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: isBuyActive
                                              ? MyTheme.white
                                              : Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),

                        // buy sell button design closed

                        SizedBox(height: 10),

                        // Category hexagonal widget design start
                        isBuyActive
                            ? buildCategoryList(isBuy: true)
                            : ClipRRect(
                                child: Stack(children: [
                                  IgnorePointer(
                                    ignoring:
                                        profileProgress == 1 ? false : true,
                                    child: buildCategoryList(isBuy: false),
                                  ),
                                  profileProgress == 1
                                      ? SizedBox.shrink()
                                      : Positioned.fill(
                                          child: Center(
                                            child: BackdropFilter(
                                              filter: ImageFilter.blur(
                                                  sigmaX: 10, sigmaY: 10),
                                              child: Container(
                                                // color: Colors.black.withOpacity(0.5),
                                                child: Center(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            30),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          'Complete Your Profile to Become a Seller',
                                                          style: TextStyle(
                                                              fontSize: 20,
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700),
                                                          textAlign: TextAlign
                                                              .center, // Align text to the center
                                                        ),
                                                        ElevatedButton(
                                                            style:
                                                                ElevatedButton
                                                                    .styleFrom(
                                                              backgroundColor:
                                                                  MyTheme
                                                                      .primary_color,
                                                            ),
                                                            onPressed: () {
                                                              Navigator.pushAndRemoveUntil(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder:
                                                                          (context) =>
                                                                              EditProfileScreen()),
                                                                  (route) =>
                                                                      false);
                                                            },
                                                            child: Text(
                                                                'Complete Profile')),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                ]),
                              ),

                        // Calender widget design start
                        Column(
                          children: [
                            Stack(
                              children: [
                                HexagonWidget.flat(
                                  width: 122,
                                  cornerRadius: 15,
                                  color: Colors.black,
                                  elevation: 3,
                                ),
                                Positioned(
                                  top: 1,
                                  left: 1,
                                  right: 1,
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  CalendarScreen()));
                                    },
                                    child: HexagonWidget.flat(
                                        width: 120,
                                        cornerRadius: 15,
                                        color: MyTheme.field_color,
                                        elevation: 3,
                                        child:
                                            Image.asset('assets/calender.png')),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 5),
                            Text(
                              "Calender",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Poppins'),
                            ),
                          ],
                        ),

                        Container(
                          height: widget.is_base_category ? 90 : 90,
                        ),
                      ]))
                    ],
                  ),
                ),
              ],
            );
          }
          if (snapshot.hasError) {
            _getProfileDataFuture = _getProfileData();
            return Text('Error');
          }
          return buildShimmer();
        });
  }

  String getAppBarTitle() {
    String name = widget.parent_category_name == ""
        ? (widget.is_top_category
            ? AppLocalizations.of(context)!.top_categories_ucf
            : AppLocalizations.of(context)!.home_ucf)
        : widget.parent_category_name;

    return name;
  }

  buildCategoryList({required bool isBuy}) {
    // var data = widget.is_top_category
    //     ? CategoryRepository().getTopCategories()
    //     : CategoryRepository()
    //         .getCategories(parent_id: widget.parent_category_id);
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        mainAxisSpacing: 10,
        crossAxisSpacing: 20,
        childAspectRatio: 1.15,
        crossAxisCount: 2,
      ),
      itemCount: 4,
      padding: EdgeInsets.only(
          left: 18, right: 18, bottom: widget.is_base_category ? 10 : 0),
      scrollDirection: Axis.vertical,
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return buildCategoryItemCard(index, isvalue, isBuy);
      },
    );
  }

  //widget for each category
  // Widget buildCategoryItemCard(categoryResponse, index, isvalue) {
  Widget buildCategoryItemCard(index, isvalue, isBuy) {
    var itemWidth = ((DeviceInfo(context).width! - 31) / 2);
    print(itemWidth);

    return Container(
      // decoration: BoxDecorations.buildBoxDecoration_1(),
      child: InkWell(
        onTap: () {
          print('Tapped index $index');
          // if (index == 2 || index == 3) {
          //   return;
          // }
          ParentEnum? parentEnum = index == 0
              ? ParentEnum.animal
              : index == 1
                  ? ParentEnum.food
                  : index == 2
                      ? ParentEnum.machine
                      : index == 3
                          ? ParentEnum.land
                          : null;
          if (!isBuy) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return ParentScreen(
                      parentEnum: parentEnum!,
                      isSecondHand:
                          parentEnum == ParentEnum.land ? true : false);
                },
              ),
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return ParentScreen(
                    parentEnum: parentEnum!,
                    isBuy: true,
                    isSecondHand: parentEnum == ParentEnum.land ? true : false,
                  );
                },
              ),
            );
          }
        },
        child: Container(
          child: Column(
            children: [
              // Text(isBuyActive ? "Buy" : "Sell",
              //     style: TextStyle(
              //         fontWeight: FontWeight.w600, fontFamily: 'Poppins')),
              Stack(
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 5, top: 5),
                    child: HexagonWidget.flat(
                      color: Colors.black,
                      cornerRadius: 15,
                      width: 122,
                      inBounds: true,
                      elevation: 3,
                      child: AspectRatio(
                        aspectRatio: HexagonType.FLAT.ratio,
                        child: Padding(
                          padding: EdgeInsets.all(18.0),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 1,
                    left: 1,
                    right: 1,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 5, top: 5),
                      child: HexagonWidget.flat(
                        color: MyTheme.field_color,
                        cornerRadius: 15,
                        width: 120,
                        inBounds: true,
                        elevation: 3,
                        child: AspectRatio(
                          aspectRatio: HexagonType.FLAT.ratio,
                          child: Padding(
                            padding: EdgeInsets.all(18),
                            child: index == 0
                                ? Image.asset(
                                    "assets/animal.png",
                                    fit: BoxFit.fitHeight,
                                  )
                                : index == 1
                                    ? Image.asset(
                                        "assets/Frame6.png",
                                        fit: BoxFit.fitHeight,
                                      )
                                    : index == 2
                                        ? Image.asset(
                                            "assets/machine.png",
                                            fit: BoxFit.fitHeight,
                                          )
                                        : index == 3
                                            ? Image.asset(
                                                "assets/village.png",
                                                fit: BoxFit.fitHeight,
                                              )
                                            : Image.asset(
                                                "assets/calender.png",
                                                fit: BoxFit.fitHeight,
                                              ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Text(
                // "${categoryResponse.categories[index].name}",
                index == 0
                    ? "Animal"
                    : index == 1
                        ? "Food"
                        : index == 2
                            ? "Machine"
                            : index == 3
                                ? "Land"
                                : "Calendar",
                style: TextStyle(
                    fontWeight: FontWeight.w600, fontFamily: 'Poppins'),
              )
            ],
          ),
        ),
      ),
    );
  }

  Container buildBottomContainer() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      // height: 80,
      height: widget.is_base_category ? 0 : 80,
      //color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Container(
                width: (MediaQuery.of(context).size.width - 32),
                height: 40,
                child: Btn.basic(
                  minWidth: MediaQuery.of(context).size.width,
                  color: MyTheme.accent_color,
                  shape: RoundedRectangleBorder(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(8.0))),
                  child: Text(
                    AppLocalizations.of(context)!.all_products_of_ucf +
                        " " +
                        widget.parent_category_name,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w600),
                  ),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return CategoryProducts(
                        category_id: widget.parent_category_id,
                        category_name: widget.parent_category_name,
                      );
                    }));
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildShimmer() {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        mainAxisSpacing: 14,
        crossAxisSpacing: 14,
        childAspectRatio: 1,
        crossAxisCount: 3,
      ),
      itemCount: 18,
      padding: EdgeInsets.only(
          left: 18, right: 18, bottom: widget.is_base_category ? 30 : 0),
      scrollDirection: Axis.vertical,
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecorations.buildBoxDecoration_1(),
          child: ShimmerHelper().buildBasicShimmer(),
        );
      },
    );
  }
}
