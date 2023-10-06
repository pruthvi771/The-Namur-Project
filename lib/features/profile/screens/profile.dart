import 'dart:async';

import 'package:active_ecommerce_flutter/custom/box_decorations.dart';
import 'package:active_ecommerce_flutter/custom/btn.dart';
import 'package:active_ecommerce_flutter/custom/device_info.dart';
import 'package:active_ecommerce_flutter/custom/lang_text.dart';
import 'package:active_ecommerce_flutter/features/profile/enum.dart';
import 'package:active_ecommerce_flutter/features/profile/screens/edit_profile.dart';
import 'package:active_ecommerce_flutter/features/profile/screens/more_details.dart';
import 'package:active_ecommerce_flutter/helpers/auth_helper.dart';
import 'package:active_ecommerce_flutter/presenter/home_presenter.dart';
import 'package:active_ecommerce_flutter/screens/auction_products.dart';
import 'package:active_ecommerce_flutter/screens/change_language.dart';
import 'package:active_ecommerce_flutter/screens/classified_ads/classified_ads.dart';
import 'package:active_ecommerce_flutter/screens/classified_ads/my_classified_ads.dart';
import 'package:active_ecommerce_flutter/screens/currency_change.dart';
import 'package:active_ecommerce_flutter/screens/digital_product/digital_products.dart';
import 'package:active_ecommerce_flutter/screens/digital_product/purchased_digital_produts.dart';
import 'package:active_ecommerce_flutter/screens/filter.dart';
import 'package:active_ecommerce_flutter/screens/followed_sellers.dart';
import 'package:active_ecommerce_flutter/features/auth/screens/login.dart';
import 'package:active_ecommerce_flutter/screens/main.dart';
import 'package:active_ecommerce_flutter/screens/messenger_list.dart';
// import 'package:active_ecommerce_flutter/screens/setting/setting.dart';
import 'package:active_ecommerce_flutter/screens/whole_sale_products.dart';
import 'package:active_ecommerce_flutter/screens/wishlist.dart';
import 'package:active_ecommerce_flutter/sell_screen/more_detail/more_detail.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:active_ecommerce_flutter/drawer/drawer.dart';
import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';
// import 'package:active_ecommerce_flutter/app_config.dart';
import 'package:active_ecommerce_flutter/screens/wallet.dart';
import 'package:active_ecommerce_flutter/screens/profile_edit.dart';
import 'package:active_ecommerce_flutter/screens/address.dart';
import 'package:active_ecommerce_flutter/screens/order_list.dart';
import 'package:active_ecommerce_flutter/screens/club_point.dart';
import 'package:active_ecommerce_flutter/screens/refund_request.dart';
import 'package:active_ecommerce_flutter/repositories/profile_repository.dart';
import 'package:active_ecommerce_flutter/custom/toast_component.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:route_transitions/route_transitions.dart';
import 'package:toast/toast.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

class Profile extends StatefulWidget {
  Profile({Key? key, this.show_back_button = false}) : super(key: key);

  bool show_back_button;

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  HomePresenter homeData = HomePresenter();
  ScrollController _mainScrollController = ScrollController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  int? _cartCounter = 0;
  String _cartCounterString = "00";
  int? _wishlistCounter = 0;
  String _wishlistCounterString = "00";
  int? _orderCounter = 0;
  String _orderCounterString = "00";
  late BuildContext loadingcontext;

  ProfileSection _profileSection = ProfileSection.updates;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // if (is_logged_in.$ == true) {

    // fetchAll();
    // }
  }

  void dispose() {
    _mainScrollController.dispose();
    super.dispose();
  }

  Future<void> _onPageRefresh() async {
    reset();
    // fetchAll();
  }

  onPopped(value) async {
    reset();
    // fetchAll();
  }

  // fetchAll() {
  //   fetchCounters();
  // }

  // fetchCounters() async {
  //   var profileCountersResponse =
  //       await ProfileRepository().getProfileCountersResponse();

  //   _cartCounter = profileCountersResponse.cart_item_count;
  //   _wishlistCounter = profileCountersResponse.wishlist_item_count;
  //   _orderCounter = profileCountersResponse.order_count;

  //   _cartCounterString =
  //       counterText(_cartCounter.toString(), default_length: 2);
  //   _wishlistCounterString =
  //       counterText(_wishlistCounter.toString(), default_length: 2);
  //   _orderCounterString =
  //       counterText(_orderCounter.toString(), default_length: 2);

  //   setState(() {});
  // }

  // deleteAccountReq() async {
  //   loading();
  //   var response = await AuthRepository().getAccountDeleteResponse();

  //   if (response.result!) {
  //     AuthHelper().clearUserData();
  //     Navigator.pop(loadingcontext);
  //     Navigator.pushAndRemoveUntil(context,
  //         MaterialPageRoute(builder: (context) {
  //       return Main();
  //     }), (route) => false);
  //   }
  //   ToastComponent.showDialog(response.message!);
  // }

  String counterText(String txt, {default_length = 3}) {
    var blank_zeros = default_length == 3 ? "000" : "00";
    var leading_zeros = "";
    if (txt != null) {
      if (default_length == 3 && txt.length == 1) {
        leading_zeros = "00";
      } else if (default_length == 3 && txt.length == 2) {
        leading_zeros = "0";
      } else if (default_length == 2 && txt.length == 1) {
        leading_zeros = "0";
      }
    }

    var newtxt = (txt == null || txt == "" || txt == null.toString())
        ? blank_zeros
        : txt;

    // print(txt + " " + default_length.toString());
    // print(newtxt);

    if (default_length > txt.length) {
      newtxt = leading_zeros + newtxt;
    }
    //print(newtxt);

    return newtxt;
  }

  reset() {
    _cartCounter = 0;
    _cartCounterString = "00";
    _wishlistCounter = 0;
    _wishlistCounterString = "00";
    _orderCounter = 0;
    _orderCounterString = "00";
    setState(() {});
  }

  onTapLogout(context) async {
    AuthHelper().clearUserData();

    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) {
      return Main();
    }), (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection:
          app_language_rtl.$! ? TextDirection.rtl : TextDirection.ltr,
      child: buildView(context, _profileSection),
    );
  }

  Widget buildView(context, _profileSection) {
    return Container(
      color: Colors.white,
      height: DeviceInfo(context).height,
      child: Stack(
        children: [
          Scaffold(
            key: homeData.scaffoldKey,
            drawer: const MainDrawer(),
            backgroundColor: Colors.transparent,
            //   appBar: buildCustomAppBar(context),
            body: buildBody(_profileSection),
          ),
        ],
      ),
    );
  }

  RefreshIndicator buildBody(_profileSection) {
    return RefreshIndicator(
      color: MyTheme.white,
      backgroundColor: MyTheme.primary_color,
      onRefresh: _onPageRefresh,
      displacement: 10,
      child: buildBodyChildren(_profileSection),
    );
  }

  CustomScrollView buildBodyChildren(profileSection) {
    final stocks = [
      'assets/onion.png',
      'assets/coconut 1.png',
      'assets/bugs.png',
      'assets/orange (1).png',
      'assets/onion.png',
      'assets/coconut 1.png',
      'assets/bugs.png',
      'assets/orange (1).png',
      'assets/onion.png',
      'assets/coconut 1.png',
      'assets/bugs.png',
      'assets/orange (1).png',
    ];

    _launchYouTubeVideo(url) async {
      print('clicked');
      final Uri _url = Uri.parse(url);
      if (await canLaunchUrl(_url)) {
        await launchUrl(_url);
      } else {
        throw 'Could not launch';
      }
    }

    return CustomScrollView(
      controller: _mainScrollController,
      physics:
          const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      slivers: [
        SliverList(
          delegate: SliverChildListDelegate([
            Stack(
              children: [
                Column(
                  children: [
                    Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height / 2,
                        child: Image.asset(
                          "assets/girl1.png",
                          fit: BoxFit.cover,
                        )),
                  ],
                ),
                Positioned(
                    top: 45,
                    right: 30,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return MoreDetails();
                        }));
                      },
                      child: Icon(
                        Icons.settings_outlined,
                        size: 30,
                        color: Colors.white,
                        weight: 10,
                      ),
                    )),
                Positioned(
                  top: 45,
                  left: 30,
                  child: IconButton(
                      onPressed: () {
                        homeData.scaffoldKey.currentState?.openDrawer();
                      },
                      icon: Icon(
                        Icons.menu,
                        color: Colors.white,
                        size: 30,
                      )),
                ),
                Positioned(
                  bottom: 0,
                  child: Container(
                    height: 15,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: MyTheme.white,
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(20),
                            topLeft: Radius.circular(20))),
                  ),
                )
              ],
            ),

            //Profile Name
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
              child: Text(
                // "${user_name.$}",
                "Chiranthana",
                style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w600,
                    fontFamily: "Poppins"),
              ),
            ),

            // CircleAvatar, Region, Friends and Neighbors texts
            Padding(
              padding: const EdgeInsets.only(top: 8.0, left: 20, right: 20),
              child: Container(
                height: 50,
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: 50,
                      width: 130,
                      child: Stack(
                        children: [
                          for (var i = 0; i < [1, 2, 3, 4].length; i++)
                            Positioned(
                              left: (i * (1 - .4) * 40).toDouble(),
                              top: 0,
                              child: CircleAvatar(
                                radius: 28,
                                backgroundColor: Colors.transparent,
                                // Set the background color to transparent
                                backgroundImage: AssetImage(
                                    'assets/Ellipse2.png'), // Provide the asset image path
                              ),
                            ),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        //Region text
                        SizedBox(
                          height: 20,
                          child: RichText(
                              text: TextSpan(children: [
                            TextSpan(
                                text: 'Pitlali : ',
                                style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15,
                                    color: Colors.black)),
                            TextSpan(
                                text: '577511',
                                style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15,
                                    color: Colors.black))
                          ])),
                        ),

                        //Friends and Neighbors text
                        SizedBox(
                          height: 20,
                          child: RichText(
                              text: TextSpan(children: [
                            TextSpan(
                                text: '125 Friends & ',
                                style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15,
                                    color: Colors.black)),
                            TextSpan(
                                text: 'Neighbors',
                                style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15,
                                    color: Colors.black))
                          ])),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),

            //Updates, My Strock navigation buttons
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20, top: 16),
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 5),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _profileSection = ProfileSection.updates;
                            });
                          },
                          child: Container(
                            width: 100,
                            height: 44,
                            decoration: BoxDecoration(
                                color: _profileSection == ProfileSection.updates
                                    ? MyTheme.primary_color
                                    : MyTheme.field_color,
                                borderRadius: BorderRadius.circular(10)),
                            child: Center(
                              child: Text(
                                "Updates",
                                style: TextStyle(
                                    color: _profileSection ==
                                            ProfileSection.updates
                                        ? Colors.white
                                        : Colors.black,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: .5,
                                    fontFamily: "Poppins",
                                    fontSize: 15),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: GestureDetector(
                          onTap: () {
                            print('clicked');
                            setState(() {
                              _profileSection = ProfileSection.myStock;
                            });
                          },
                          child: Container(
                            // width: 100,
                            height: 44,
                            decoration: BoxDecoration(
                                // color: MyTheme.primary_color,
                                color: _profileSection == ProfileSection.myStock
                                    ? MyTheme.primary_color
                                    : MyTheme.field_color,
                                borderRadius: BorderRadius.circular(10)),
                            child: Center(
                              child: Text(
                                "My Stock",
                                style: TextStyle(
                                    color: _profileSection ==
                                            ProfileSection.myStock
                                        ? Colors.white
                                        : Colors.black,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: "Poppins",
                                    letterSpacing: .5,
                                    fontSize: 15),
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),

            if (_profileSection == ProfileSection.updates)
              Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: InkWell(
                        onTap: () async {
                          await _launchYouTubeVideo(
                              'https://www.youtube.com/watch?v=o5DGLMY7jsc');
                        },
                        child: Image.network(
                            'https://i.ytimg.com/vi/o5DGLMY7jsc/maxresdefault.jpg'),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: InkWell(
                        onTap: () async {
                          await _launchYouTubeVideo(
                              'https://www.youtube.com/watch?v=VeO_kVYPmmg');
                        },
                        child: Image.network(
                            'https://i.ytimg.com/vi/VeO_kVYPmmg/maxresdefault.jpg'),
                      ),
                    ),
                  ),
                  // ElevatedButton(
                  //   onPressed: () {
                  //     Navigator.push(context,
                  //         MaterialPageRoute(builder: (context) {
                  //       return EditProfileScreen();
                  //     }));
                  //   },
                  //   child: Text('Profile Edit'),
                  // )
                ],
              ),

            if (_profileSection == ProfileSection.myStock)
              // Text(
              //   'updates',
              // ),
              SingleChildScrollView(
                // controller: _xcrollController,
                /* physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),*/
                child: MasonryGridView.count(
                  crossAxisCount: 3,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  itemCount: stocks.length,
                  shrinkWrap: true,
                  padding: EdgeInsets.only(top: 10.0, left: 18, right: 18),
                  physics: NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) {
                    //
                    return Container(
                      //  height: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: (index % 5 == 0)
                            ? MyTheme.green_neon
                            : MyTheme.white,
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Container(
                              height: 50,
                              width: 50,
                              child: Image.asset(
                                stocks[index],
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 8.0, bottom: 8.0),
                            child: Text(
                              "Grapes",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500),
                            ),
                          )
                        ],
                      ),
                    );
                  },
                ),
              ),

            // //divider
            // SizedBox(
            //   height: 20,
            // ),
            // Container(
            //   padding: const EdgeInsets.all(8.0),
            //   child: Divider(
            //     thickness: 30,
            //     color: Colors.red,
            //   ),
            // ),

            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 18.0),
            //   child: buildCountersRow(),
            // ),

            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 18.0),
            //   child: buildHorizontalSettings(),
            // ),
            // // Padding(
            // //   padding: const EdgeInsets.symmetric(horizontal: 18.0),
            // //   child: buildSettingAndAddonsVerticalMenu(),
            // // ),
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 18.0),
            //   child: buildSettingAndAddonsHorizontalMenu(),
            // ),
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 18.0),
            //   child: buildBottomVerticalCardList(),
            // ),
          ]),
        )
      ],
    );
  }

  PreferredSize buildCustomAppBar(context) {
    return PreferredSize(
      preferredSize: Size(DeviceInfo(context).width!, 80),
      child: Container(
        // color: Colors.green,
        child: SafeArea(
          child: Column(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: Container(
                  margin: EdgeInsets.only(right: 18),
                  height: 30,
                  child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(
                        Icons.close,
                        color: MyTheme.white,
                        size: 20,
                      )),
                ),
              ),

              // Container(
              //   margin: EdgeInsets.symmetric(vertical: 8),
              //   width: DeviceInfo(context).width,height: 1,color: MyTheme.medium_grey_50,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: buildAppbarSection(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildBottomVerticalCardList() {
    return Container(
      margin: EdgeInsets.only(bottom: 120, top: 14),
      padding: EdgeInsets.symmetric(horizontal: 22, vertical: 20),
      decoration: BoxDecorations.buildBoxDecoration_1(),
      child: Column(
        children: [
          if (false)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildBottomVerticalCardListItem(
                    "assets/coupon.png", LangText(context).local!.coupons_ucf,
                    onPressed: () {}),
                Divider(
                  thickness: 1,
                  color: MyTheme.light_grey,
                ),
                buildBottomVerticalCardListItem("assets/favoriteseller.png",
                    LangText(context).local!.favorite_seller_ucf,
                    onPressed: () {}),
                Divider(
                  thickness: 1,
                  color: MyTheme.light_grey,
                ),
              ],
            ),

          buildBottomVerticalCardListItem("assets/download.png",
              LangText(context).local!.all_digital_products_ucf, onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return DigitalProducts();
            }));
          }),
          Divider(
            thickness: 1,
            color: MyTheme.light_grey,
          ),

          // this is addon
          if (false)
            Column(
              children: [
                buildBottomVerticalCardListItem("assets/auction.png",
                    LangText(context).local!.on_auction_products_ucf,
                    onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return AuctionProducts();
                  }));
                }),
                Divider(
                  thickness: 1,
                  color: MyTheme.light_grey,
                ),
              ],
            ),
          if (classified_product_status.$)
            Column(
              children: [
                buildBottomVerticalCardListItem("assets/classified_product.png",
                    LangText(context).local!.classified_ads_ucf, onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return ClassifiedAds();
                  }));
                }),
                Divider(
                  thickness: 1,
                  color: MyTheme.light_grey,
                ),
              ],
            ),

          // this is addon auction product
          if (false)
            Column(
              children: [
                buildBottomVerticalCardListItem("assets/auction.png",
                    LangText(context).local!.on_auction_products_ucf,
                    onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return AuctionProducts();
                  }));
                }),
                Divider(
                  thickness: 1,
                  color: MyTheme.light_grey,
                ),
              ],
            ),
          if (auction_addon_installed.$)
            Column(
              children: [
                buildBottomVerticalCardListItem("assets/auction.png",
                    LangText(context).local!.on_auction_products_ucf,
                    onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return AuctionProducts();
                  }));
                }),
                Divider(
                  thickness: 1,
                  color: MyTheme.light_grey,
                ),
              ],
            ),

          // this is addon
          if (false)
            Column(
              children: [
                buildBottomVerticalCardListItem("assets/wholesale.png",
                    LangText(context).local!.wholesale_products_ucf,
                    onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return WholeSaleProducts();
                  }));
                }),
                Divider(
                  thickness: 1,
                  color: MyTheme.light_grey,
                ),
              ],
            ),

          if (vendor_system.$)
            Column(
              children: [
                buildBottomVerticalCardListItem("assets/shop.png",
                    LangText(context).local!.browse_all_sellers_ucf,
                    onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return Filter(
                      selected_filter: "sellers",
                    );
                  }));
                }),
                Divider(
                  thickness: 1,
                  color: MyTheme.light_grey,
                ),
              ],
            ),

          // if (is_logged_in.$)
          Column(
            children: [
              buildBottomVerticalCardListItem("assets/shop.png",
                  LangText(context).local!.followed_sellers_ucf, onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return FollowedSellers();
                }));
              }),
              Divider(
                thickness: 1,
                color: MyTheme.light_grey,
              ),
            ],
          ),

          // if (is_logged_in.$)
          Column(
            children: [
              buildBottomVerticalCardListItem("assets/delete.png",
                  LangText(context).local!.delete_my_account, onPressed: () {
                deleteWarningDialog();

                // Navigator.push(context, MaterialPageRoute(builder: (context) {
                //   return Filter(
                //     selected_filter: "sellers",
                //   );
                // }
                //)
                //);
              }),
              Divider(
                thickness: 1,
                color: MyTheme.light_grey,
              ),
            ],
          ),

          if (false)
            buildBottomVerticalCardListItem(
                "assets/blog.png", LangText(context).local!.blogs_ucf,
                onPressed: () {}),
        ],
      ),
    );
  }

  Container buildBottomVerticalCardListItem(String img, String label,
      {Function()? onPressed, bool isDisable = false}) {
    return Container(
      height: 40,
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
            splashFactory: NoSplash.splashFactory,
            alignment: Alignment.center,
            padding: EdgeInsets.zero),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 24.0),
              child: Image.asset(
                img,
                height: 16,
                width: 16,
                color: isDisable ? MyTheme.grey_153 : MyTheme.dark_font_grey,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                  fontSize: 12,
                  color: isDisable ? MyTheme.grey_153 : MyTheme.dark_font_grey),
            ),
          ],
        ),
      ),
    );
  }

  // This section show after counter section
  // change Language, Edit Profile and Address section
  Widget buildHorizontalSettings() {
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          buildHorizontalSettingItem(true, "assets/language.png",
              AppLocalizations.of(context)!.language_ucf, () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return ChangeLanguage();
                },
              ),
            );
          }),
          InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return CurrencyChange();
              }));
            },
            child: Column(
              children: [
                Image.asset(
                  "assets/currency.png",
                  height: 16,
                  width: 16,
                  color: MyTheme.white,
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  AppLocalizations.of(context)!.currency_ucf,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 10,
                      color: MyTheme.white,
                      fontWeight: FontWeight.w500),
                )
              ],
            ),
          ),
          buildHorizontalSettingItem(
              // is_logged_in.$,
              true,
              "assets/edit.png",
              AppLocalizations.of(context)!.edit_profile_ucf,
              // is_logged_in.$
              true
                  ? () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return ProfileEdit();
                      })).then((value) {
                        onPopped(value);
                      });
                    }
                  : () => showLoginWarning()),
          buildHorizontalSettingItem(
              // is_logged_in.$,
              true,
              "assets/location.png",
              AppLocalizations.of(context)!.address_ucf,
              // is_logged_in.$
              true
                  ? () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return Address();
                          },
                        ),
                      );
                    }
                  : () => showLoginWarning()),
        ],
      ),
    );
  }

  InkWell buildHorizontalSettingItem(
      bool isLogin, String img, String text, Function() onTap) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Image.asset(
            img,
            height: 16,
            width: 16,
            color: isLogin ? MyTheme.white : MyTheme.blue_grey,
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 10,
                color: isLogin ? MyTheme.white : MyTheme.blue_grey,
                fontWeight: FontWeight.w500),
          )
        ],
      ),
    );
  }

  showLoginWarning() {
    return ToastComponent.showDialog(
        AppLocalizations.of(context)!.you_need_to_log_in,
        gravity: Toast.center,
        duration: Toast.lengthLong);
  }

  deleteWarningDialog() {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(
                LangText(context).local!.delete_account_warning_title,
                style: TextStyle(fontSize: 15, color: MyTheme.dark_font_grey),
              ),
              content: Text(
                LangText(context).local!.delete_account_warning_description,
                style: TextStyle(fontSize: 13, color: MyTheme.dark_font_grey),
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      pop(context);
                    },
                    child: Text(LangText(context).local!.no_ucf)),
                TextButton(
                    onPressed: () {
                      pop(context);
                      // deleteAccountReq();
                    },
                    child: Text(LangText(context).local!.yes_ucf))
              ],
            ));
  }
/*
  Widget buildSettingAndAddonsHorizontalMenu() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20),
      margin: EdgeInsets.only(top: 14),
      width: DeviceInfo(context).width,
      decoration: BoxDecorations.buildBoxDecoration_1(),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16),
        //color: Colors.blue,
        child: Wrap(
          direction: Axis.horizontal,
          runAlignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          runSpacing: 20,
          spacing: 10,
          //mainAxisAlignment: MainAxisAlignment.start,
          alignment: WrapAlignment.center,
          children: [
            if (wallet_system_status.$)
              buildSettingAndAddonsHorizontalMenuItem("assets/wallet.png",
                  AppLocalizations.of(context).wallet_screen_my_wallet, () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return Wallet();
                }));
              }),
            buildSettingAndAddonsHorizontalMenuItem(
                "assets/orders.png",
                AppLocalizations.of(context).profile_screen_orders,
                is_logged_in.$
                    ? () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return OrderList();
                        }));
                      }
                    : () => null),
            buildSettingAndAddonsHorizontalMenuItem(
                "assets/heart.png",
                AppLocalizations.of(context).main_drawer_my_wishlist,
                is_logged_in.$
                    ? () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return Wishlist();
                        }));
                      }
                    : () => null),
            if (club_point_addon_installed.$)
              buildSettingAndAddonsHorizontalMenuItem(
                  "assets/points.png",
                  AppLocalizations.of(context).club_point_screen_earned_points,
                  is_logged_in.$
                      ? () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return Clubpoint();
                          }));
                        }
                      : () => null),
            if (refund_addon_installed.$)
              buildSettingAndAddonsHorizontalMenuItem(
                  "assets/refund.png",
                  AppLocalizations.of(context)
                      .refund_request_screen_refund_requests,
                  is_logged_in.$
                      ? () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return RefundRequest();
                          }));
                        }
                      : () => null),
            if (conversation_system_status.$)
              buildSettingAndAddonsHorizontalMenuItem(
                  "assets/messages.png",
                  AppLocalizations.of(context).main_drawer_messages,
                  is_logged_in.$
                      ? () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return MessengerList();
                          }));
                        }
                      : () => null),
            if (true)
              buildSettingAndAddonsHorizontalMenuItem(
                  "assets/auction.png",
                  AppLocalizations.of(context).profile_screen_auction,
                  is_logged_in.$
                      ? () {
                          // Navigator.push(context,
                          //     MaterialPageRoute(builder: (context) {
                          //   return MessengerList();
                          // }));
                        }
                      : () => null),
            if (true)
              buildSettingAndAddonsHorizontalMenuItem(
                  "assets/classified_product.png",
                  AppLocalizations.of(context).profile_screen_classified_products,
                  is_logged_in.$
                      ? () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return MessengerList();
                          }));
                        }
                      : () => null),
          ],
        ),
      ),
    );
  }*/

  Widget buildSettingAndAddonsHorizontalMenu() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      margin: EdgeInsets.only(top: 14),
      width: DeviceInfo(context).width,
      decoration: BoxDecorations.buildBoxDecoration_1(),
      child: GridView.count(
        // gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        //   crossAxisCount: 3,
        // ),
        crossAxisCount: 3,

        childAspectRatio: 2,
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        cacheExtent: 5.0,
        mainAxisSpacing: 16,
        children: [
          if (wallet_system_status.$)
            Container(
              // color: Colors.red,

              child: buildSettingAndAddonsHorizontalMenuItem(
                  "assets/wallet.png",
                  AppLocalizations.of(context)!.my_wallet_ucf, () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return Wallet();
                }));
              }),
            ),
          buildSettingAndAddonsHorizontalMenuItem(
              "assets/orders.png",
              AppLocalizations.of(context)!.orders_ucf,
              // is_logged_in.$
              true
                  ? () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return OrderList();
                      }));
                    }
                  : () => null),
          buildSettingAndAddonsHorizontalMenuItem(
              "assets/heart.png",
              AppLocalizations.of(context)!.my_wishlist_ucf,
              // is_logged_in.$
              true
                  ? () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return Wishlist();
                      }));
                    }
                  : () => null),
          if (club_point_addon_installed.$)
            buildSettingAndAddonsHorizontalMenuItem(
                "assets/points.png",
                AppLocalizations.of(context)!.earned_points_ucf,
                // is_logged_in.$
                true
                    ? () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return Clubpoint();
                        }));
                      }
                    : () => null),
          if (refund_addon_installed.$)
            buildSettingAndAddonsHorizontalMenuItem(
                "assets/refund.png",
                AppLocalizations.of(context)!.refund_requests_ucf,
                // is_logged_in.$
                true
                    ? () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return RefundRequest();
                        }));
                      }
                    : () => null),
          if (conversation_system_status.$)
            buildSettingAndAddonsHorizontalMenuItem(
                "assets/messages.png",
                AppLocalizations.of(context)!.messages_ucf,
                // is_logged_in.$
                true
                    ? () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return MessengerList();
                        }));
                      }
                    : () => null),
          // if (auction_addon_installed.$)
          if (false)
            buildSettingAndAddonsHorizontalMenuItem(
                "assets/auction.png",
                AppLocalizations.of(context)!.auction_ucf,
                // is_logged_in.$
                true
                    ? () {
                        // Navigator.push(context,
                        //     MaterialPageRoute(builder: (context) {
                        //   return MessengerList();
                        // }));
                      }
                    : () => null),
          if (classified_product_status.$)
            buildSettingAndAddonsHorizontalMenuItem(
                "assets/classified_product.png",
                AppLocalizations.of(context)!.classified_products,
                // is_logged_in.$
                true
                    ? () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return MyClassifiedAds();
                        }));
                      }
                    : () => null),

          buildSettingAndAddonsHorizontalMenuItem(
              "assets/download.png",
              AppLocalizations.of(context)!.downloads_ucf,
              // is_logged_in.$
              true
                  ? () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return PurchasedDigitalProducts();
                      }));
                    }
                  : () => null),
        ],
      ),
    );
  }

  Container buildSettingAndAddonsHorizontalMenuItem(
      String img, String text, Function() onTap) {
    return Container(
      alignment: Alignment.center,
      // color: Colors.red,
      // width: DeviceInfo(context).width / 4,
      child: InkWell(
        // onTap: is_logged_in.$
        onTap: true
            ? onTap
            : () {
                showLoginWarning();
              },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              img,
              width: 16,
              height: 16,
              // color: is_logged_in.$
              color: true ? MyTheme.dark_font_grey : MyTheme.medium_grey_50,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              text,
              textAlign: TextAlign.center,
              maxLines: 1,
              style: TextStyle(
                  // color: is_logged_in.$
                  color: true ? MyTheme.dark_font_grey : MyTheme.medium_grey_50,
                  fontSize: 12),
            )
          ],
        ),
      ),
    );
  }

/*
  Widget buildSettingAndAddonsVerticalMenu() {
    return Container(
      margin: EdgeInsets.only(bottom: 120, top: 14),
      padding: EdgeInsets.symmetric(horizontal: 22, vertical: 20),
      decoration: BoxDecorations.buildBoxDecoration_1(),
      child: Column(
        children: [
          Visibility(
            visible: wallet_system_status.$,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 40,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return Wallet();
                      }));
                    },
                    style: TextButton.styleFrom(
                        splashFactory: NoSplash.splashFactory,
                        alignment: Alignment.center,
                        padding: EdgeInsets.zero),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/wallet.png",
                          width: 16,
                          height: 16,
                          color: MyTheme.dark_font_grey,
                        ),
                        SizedBox(
                          width: 24,
                        ),
                        Text(
                          AppLocalizations.of(context).wallet_screen_my_wallet,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: MyTheme.dark_font_grey, fontSize: 12),
                        )
                      ],
                    ),
                  ),
                ),
                Divider(
                  thickness: 1,
                  color: MyTheme.light_grey,
                ),
              ],
            ),
          ),
          Container(
            height: 40,
            child: TextButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return OrderList();
                }));
              },
              style: TextButton.styleFrom(
                  splashFactory: NoSplash.splashFactory,
                  alignment: Alignment.center,
                  padding: EdgeInsets.zero),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/orders.png",
                    width: 16,
                    height: 16,
                    color: MyTheme.dark_font_grey,
                  ),
                  SizedBox(
                    width: 24,
                  ),
                  Text(
                    AppLocalizations.of(context).profile_screen_orders,
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(color: MyTheme.dark_font_grey, fontSize: 12),
                  )
                ],
              ),
            ),
          ),
          Divider(
            thickness: 1,
            color: MyTheme.light_grey,
          ),
          Container(
            height: 40,
            child: TextButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return Wishlist();
                }));
              },
              style: TextButton.styleFrom(
                  splashFactory: NoSplash.splashFactory,
                  alignment: Alignment.center,
                  padding: EdgeInsets.zero),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/heart.png",
                    width: 16,
                    height: 16,
                    color: MyTheme.dark_font_grey,
                  ),
                  SizedBox(
                    width: 24,
                  ),
                  Text(
                    AppLocalizations.of(context).main_drawer_my_wishlist,
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(color: MyTheme.dark_font_grey, fontSize: 12),
                  )
                ],
              ),
            ),
          ),
          Divider(
            thickness: 1,
            color: MyTheme.light_grey,
          ),
          Visibility(
            visible: club_point_addon_installed.$,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 40,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return Clubpoint();
                      }));
                    },
                    style: TextButton.styleFrom(
                        splashFactory: NoSplash.splashFactory,
                        alignment: Alignment.center,
                        padding: EdgeInsets.zero),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/points.png",
                          width: 16,
                          height: 16,
                          color: MyTheme.dark_font_grey,
                        ),
                        SizedBox(
                          width: 24,
                        ),
                        Text(
                          AppLocalizations.of(context)
                              .club_point_screen_earned_points,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: MyTheme.dark_font_grey, fontSize: 12),
                        )
                      ],
                    ),
                  ),
                ),
                Divider(
                  thickness: 1,
                  color: MyTheme.light_grey,
                ),
              ],
            ),
          ),
          Visibility(
            visible: refund_addon_installed.$,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 40,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return RefundRequest();
                      }));
                    },
                    style: TextButton.styleFrom(
                        splashFactory: NoSplash.splashFactory,
                        alignment: Alignment.center,
                        padding: EdgeInsets.zero),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/refund.png",
                          width: 16,
                          height: 16,
                          color: MyTheme.dark_font_grey,
                        ),
                        SizedBox(
                          width: 24,
                        ),
                        Text(
                          AppLocalizations.of(context)
                              .refund_request_screen_refund_requests,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: MyTheme.dark_font_grey, fontSize: 12),
                        )
                      ],
                    ),
                  ),
                ),
                Divider(
                  thickness: 1,
                  color: MyTheme.light_grey,
                ),
              ],
            ),
          ),
          Visibility(
            visible: conversation_system_status.$,
            child: Container(
              height: 40,
              child: TextButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return MessengerList();
                  }));
                },
                style: TextButton.styleFrom(
                    splashFactory: NoSplash.splashFactory,
                    alignment: Alignment.center,
                    padding: EdgeInsets.zero),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/messages.png",
                      width: 16,
                      height: 16,
                      color: MyTheme.dark_font_grey,
                    ),
                    SizedBox(
                      width: 24,
                    ),
                    Text(
                      AppLocalizations.of(context).main_drawer_messages,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: MyTheme.dark_font_grey, fontSize: 12),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
*/
  Widget buildCountersRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        buildCountersRowItem(
          _cartCounterString,
          AppLocalizations.of(context)!.in_your_cart_all_lower,
        ),
        buildCountersRowItem(
          _wishlistCounterString,
          AppLocalizations.of(context)!.in_your_wishlist_all_lower,
        ),
        buildCountersRowItem(
          _orderCounterString,
          AppLocalizations.of(context)!.your_ordered_all_lower,
        ),
      ],
    );
  }

  Widget buildCountersRowItem(String counter, String title) {
    return Container(
      margin: EdgeInsets.only(top: 20),
      padding: EdgeInsets.symmetric(vertical: 14),
      width: DeviceInfo(context).width! / 3.5,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: MyTheme.white,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            counter,
            maxLines: 2,
            style: TextStyle(
                fontSize: 16,
                color: MyTheme.dark_font_grey,
                fontWeight: FontWeight.w600),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            title,
            maxLines: 2,
            style: TextStyle(
              color: MyTheme.dark_font_grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildAppbarSection() {
    return Container(
      // color: Colors.amber,
      alignment: Alignment.center,
      height: 48,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          /* Container(
            child: InkWell(
              //padding: EdgeInsets.zero,
              onTap: (){
              Navigator.pop(context);
            } ,child:Icon(Icons.arrow_back,size: 25,color: MyTheme.white,), ),
          ),*/
          // SizedBox(width: 10,),
          Padding(
            padding: const EdgeInsets.only(right: 14.0),
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(100),
                border: Border.all(color: MyTheme.white, width: 1),
                //shape: BoxShape.rectangle,
              ),
              // child: is_logged_in.$
              child: true
                  ? ClipRRect(
                      clipBehavior: Clip.hardEdge,
                      borderRadius: BorderRadius.all(Radius.circular(100.0)),
                      child: FadeInImage.assetNetwork(
                        placeholder: 'assets/placeholder.png',
                        image: "${avatar_original.$}",
                        fit: BoxFit.fill,
                      ))
                  : Image.asset(
                      'assets/profile_placeholder.png',
                      height: 48,
                      width: 48,
                      fit: BoxFit.fitHeight,
                    ),
            ),
          ),
          buildUserInfo(),
          Spacer(),
          Container(
            width: 70,
            height: 26,
            child: Btn.basic(
              padding: EdgeInsets.symmetric(horizontal: 14, vertical: 7),
              // 	rgb(50,205,50)
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                  side: BorderSide(color: MyTheme.white)),
              child: Text(
                // is_logged_in.$
                true
                    ? AppLocalizations.of(context)!.logout_ucf
                    : LangText(context).local!.login_ucf,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w500),
              ),
              onPressed: () {
                // if (is_logged_in.$)
                if (true)
                  onTapLogout(context);
                else
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Login()));
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildUserInfo() {
    // return is_logged_in.$
    return true
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "${user_name.$}",
                style: TextStyle(
                    fontSize: 14,
                    color: MyTheme.white,
                    fontWeight: FontWeight.w600),
              ),
              Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text(
                    //if user email is not available then check user phone if user phone is not available use empty string
                    "${user_email.$ != "" && user_email.$ != null ? user_email.$ : user_phone.$ != "" && user_phone.$ != null ? user_phone.$ : ''}",
                    style: TextStyle(
                      color: MyTheme.light_grey,
                    ),
                  )),
            ],
          )
        : Text(
            "Login/Registration",
            style: TextStyle(
                fontSize: 14,
                color: MyTheme.white,
                fontWeight: FontWeight.bold),
          );
  }

/*
  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      centerTitle: true,
      automaticallyImplyLeading: false,
      /* leading: GestureDetector(
        child: widget.show_back_button
            ? Builder(
                builder: (context) => IconButton(
                  icon:
                      Icon(CupertinoIcons.arrow_left, color: MyTheme.dark_grey),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              )
            : Builder(
                builder: (context) => GestureDetector(
                  onTap: () {
                    _scaffoldKey.currentState.openDrawer();
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 18.0, horizontal: 0.0),
                    child: Container(
                      child: Image.asset(
                        'assets/hamburger.png',
                        height: 16,
                        color: MyTheme.dark_grey,
                      ),
                    ),
                  ),
                ),
              ),
      ),*/
      title: Text(
        AppLocalizations.of(context).profile_screen_account,
        style: TextStyle(fontSize: 16, color: MyTheme.accent_color),
      ),
      elevation: 0.0,
      titleSpacing: 0,
    );
  }*/

  loading() {
    showDialog(
        context: context,
        builder: (context) {
          loadingcontext = context;
          return AlertDialog(
              content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(
                width: 10,
              ),
              Text("${AppLocalizations.of(context)!.please_wait_ucf}"),
            ],
          ));
        });
  }
}
