import 'dart:ui';

import 'package:active_ecommerce_flutter/custom/box_decorations.dart';
import 'package:active_ecommerce_flutter/custom/device_info.dart';
import 'package:active_ecommerce_flutter/features/calendar/screens/calendar_screen.dart';
import 'package:active_ecommerce_flutter/features/sellAndBuy/screens/parent_screen.dart';
// import 'package:active_ecommerce_flutter/features/testscreen.dart';
import 'package:active_ecommerce_flutter/helpers/shimmer_helper.dart';
import 'package:active_ecommerce_flutter/presenter/bottom_appbar_index.dart';
import 'package:active_ecommerce_flutter/utils/enums.dart';
import 'package:active_ecommerce_flutter/utils/profile_completion_bloc/profile_completion_bloc.dart';
import 'package:active_ecommerce_flutter/utils/profile_completion_bloc/profile_completion_event.dart';
import 'package:active_ecommerce_flutter/utils/profile_completion_bloc/profile_completion_state.dart';
import 'package:flutter/material.dart';
import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexagon/hexagon.dart';
import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../controller/sub_category_controller.dart';
import '../features/profile/screens/edit_profile.dart';
import '../presenter/home_presenter.dart';
import '../features/profile/title_bar_widget.dart';
import 'package:get/get.dart';

class CategoryList extends StatefulWidget {
  CategoryList({
    Key? key,
    this.parentCategoryId = 0,
    this.parentCategoryName = "",
    this.isBaseCategory = false,
    this.isTopCategory = false,
    this.bottomAppbarIndex,
  }) : super(key: key);

  final int parentCategoryId;
  final String parentCategoryName;
  final bool isBaseCategory;
  final bool isTopCategory;
  final BottomAppbarIndex? bottomAppbarIndex;

  @override
  _CategoryListState createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  SubCategoryController subCategoryCon = Get.put(SubCategoryController());
  HomePresenter homeData = HomePresenter();

  String color = "buy";
  bool isBuyActive = true;
  bool isvalue = true;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<ProfileCompletionBloc>(context).add(
      ProfileCompletionDataRequested(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection:
          app_language_rtl.$! ? TextDirection.rtl : TextDirection.ltr,
      child: Stack(children: [
        Scaffold(
          // key: homeData.scaffoldKey,
          // drawer: const MainDrawer(),
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            automaticallyImplyLeading: false,
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
          body: buildBody(),
        ),
        // Align(
        //   alignment: Alignment.bottomCenter,
        //   child: widget.is_base_category || widget.is_top_category
        //       ? Container(
        //           height: 0,
        //         )
        //       : buildBottomContainer(),
        // )
      ]),
    );
  }

  Widget buildBody() {
    return BlocBuilder<ProfileCompletionBloc, ProfileCompletionState>(
      builder: (context, state) {
        if (state is ProfileCompletionDataReceived) {
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
                      // TextButton(
                      //     onPressed: () {
                      //       Navigator.push(
                      //         context,
                      //         MaterialPageRoute(
                      //             builder: (context) => TestWidget()),
                      //       );
                      //     },
                      //     child: Text('Test Widget')),

                      SizedBox(height: 10),

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
                                          AppLocalizations.of(context)!
                                              .sell_upper,
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
                                      AppLocalizations.of(context)!.buy_upper,
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
                                      state.profileProgress == 1 ? false : true,
                                  child: buildCategoryList(isBuy: false),
                                ),
                                state.profileProgress == 1
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
                                                      const EdgeInsets.all(30),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        AppLocalizations.of(
                                                                context)!
                                                            .complate_profile_to_become_seller,
                                                        style: TextStyle(
                                                            fontSize: 20,
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w700),
                                                        textAlign: TextAlign
                                                            .center, // Align text to the center
                                                      ),
                                                      ElevatedButton(
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                            backgroundColor:
                                                                MyTheme
                                                                    .primary_color,
                                                          ),
                                                          onPressed: () {
                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            EditProfileScreen()));
                                                          },
                                                          child: Text(
                                                              AppLocalizations.of(
                                                                      context)!
                                                                  .complate_profile)),
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
                            AppLocalizations.of(context)!.calendar,
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Poppins'),
                          ),
                        ],
                      ),

                      Container(
                        height: widget.isBaseCategory ? 90 : 90,
                      ),
                    ]))
                  ],
                ),
              ),
            ],
          );
        } else {
          return buildShimmer();
        }
      },
    );
  }
  // if (snapshot.hasError) {
  //   _getProfileDataFuture = _getProfileData();
  //   return Text('Error');
  // }
  //   return buildShimmer();
  // });

  String getAppBarTitle() {
    String name = widget.parentCategoryName == ""
        ? (widget.isTopCategory
            ? AppLocalizations.of(context)!.top_categories_ucf
            : AppLocalizations.of(context)!.home_ucf)
        : widget.parentCategoryName;

    return name;
  }

  buildCategoryList({required bool isBuy}) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        mainAxisSpacing: 10,
        crossAxisSpacing: 20,
        childAspectRatio: 1.15,
        crossAxisCount: 2,
      ),
      itemCount: 4,
      padding: EdgeInsets.only(
          left: 18, right: 18, bottom: widget.isBaseCategory ? 10 : 0),
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

    return Container(
      // decoration: BoxDecorations.buildBoxDecoration_1(),
      child: InkWell(
        onTap: () {
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
                          ? ParentEnum.market
                          : null;
          if (!isBuy) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return ParentScreen(
                    parentEnum: parentEnum!,
                    isSecondHand: false,
                    // parentEnum == ParentEnum.market ? true : false,
                  );
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
                    isSecondHand: false,
                    // parentEnum == ParentEnum.market ? true : false,
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
              Expanded(
                child: Text(
                  // "${categoryResponse.categories[index].name}",
                  index == 0
                      ? AppLocalizations.of(context)!.animal
                      : index == 1
                          ? AppLocalizations.of(context)!.food
                          : index == 2
                              ? AppLocalizations.of(context)!.machine
                              : index == 3
                                  ? AppLocalizations.of(context)!.market
                                  : AppLocalizations.of(context)!.calendar,
                  style: TextStyle(
                      fontWeight: FontWeight.w600, fontFamily: 'Poppins'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  // Container buildBottomContainer() {
  //   return Container(
  //     decoration: BoxDecoration(
  //       color: Colors.white,
  //     ),
  //     // height: 80,
  //     height: widget.is_base_category ? 0 : 80,
  //     //color: Colors.white,
  //     child: Padding(
  //       padding: const EdgeInsets.all(16.0),
  //       child: Column(
  //         children: [
  //           Padding(
  //             padding: const EdgeInsets.only(top: 8.0),
  //             child: Container(
  //               width: (MediaQuery.of(context).size.width - 32),
  //               height: 40,
  //               child: Btn.basic(
  //                 minWidth: MediaQuery.of(context).size.width,
  //                 color: MyTheme.accent_color,
  //                 shape: RoundedRectangleBorder(
  //                     borderRadius:
  //                         const BorderRadius.all(Radius.circular(8.0))),
  //                 child: Text(
  //                   AppLocalizations.of(context)!.all_products_of_ucf +
  //                       " " +
  //                       widget.parent_category_name,
  //                   style: TextStyle(
  //                       color: Colors.white,
  //                       fontSize: 13,
  //                       fontWeight: FontWeight.w600),
  //                 ),
  //                 onPressed: () {
  //                   Navigator.push(context,
  //                       MaterialPageRoute(builder: (context) {
  //                     return CategoryProducts(
  //                       category_id: widget.parent_category_id,
  //                       category_name: widget.parent_category_name,
  //                     );
  //                   }));
  //                 },
  //               ),
  //             ),
  //           )
  //         ],
  //       ),
  //     ),
  //   );
  // }

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
          left: 18, right: 18, bottom: widget.isBaseCategory ? 30 : 0),
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
