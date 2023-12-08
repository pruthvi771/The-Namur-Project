import 'dart:async';
import 'package:active_ecommerce_flutter/custom/device_info.dart';
import 'package:active_ecommerce_flutter/custom/lang_text.dart';
import 'package:active_ecommerce_flutter/helpers/auth_helper.dart';
import 'package:active_ecommerce_flutter/presenter/home_presenter.dart';
import 'package:active_ecommerce_flutter/screens/change_language.dart';
import 'package:active_ecommerce_flutter/screens/currency_change.dart';
import 'package:active_ecommerce_flutter/screens/main.dart';
import 'package:active_ecommerce_flutter/screens/messenger_list.dart';
import 'package:flutter/material.dart';
import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:active_ecommerce_flutter/drawer/drawer.dart';
import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';
import 'package:active_ecommerce_flutter/screens/wallet.dart';
import 'package:active_ecommerce_flutter/screens/profile_edit.dart';
import 'package:active_ecommerce_flutter/screens/address.dart';
import 'package:active_ecommerce_flutter/screens/order_list.dart';
import 'package:active_ecommerce_flutter/repositories/profile_repository.dart';
import 'package:active_ecommerce_flutter/custom/toast_component.dart';
import 'package:route_transitions/route_transitions.dart';
import 'package:toast/toast.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../repositories/auth_repository.dart';
// import '../../features/auth/services/auth_service.text';
import '../notification/notification_screen.dart';

class MyAccount extends StatefulWidget {
  MyAccount({Key? key, this.show_back_button = false}) : super(key: key);
  bool show_back_button;
  @override
  State<MyAccount> createState() => _MyAccountState();
}

class _MyAccountState extends State<MyAccount> {
  HomePresenter homeData = HomePresenter();
  ScrollController _mainScrollController = ScrollController();
  // final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  int? _cartCounter = 0;
  String _cartCounterString = "00";
  int? _wishlistCounter = 0;
  String _wishlistCounterString = "00";
  int? _orderCounter = 0;
  // String _orderCounterString = "00";
  late BuildContext loadingcontext;

  // var user = AuthService.firebase().currentUser;
  var user = null;

  @override
  void initState() {
    super.initState();

    if (user != null) {
      fetchAll();
    }
  }

  void dispose() {
    _mainScrollController.dispose();
    super.dispose();
  }

  Future<void> _onPageRefresh() async {
    reset();
    fetchAll();
  }

  onPopped(value) async {
    reset();
    fetchAll();
  }

  fetchAll() {
    fetchCounters();
  }

  fetchCounters() async {
    var profileCountersResponse =
        await ProfileRepository().getProfileCountersResponse();

    _cartCounter = profileCountersResponse.cart_item_count;
    _wishlistCounter = profileCountersResponse.wishlist_item_count;
    _orderCounter = profileCountersResponse.order_count;

    _cartCounterString =
        counterText(_cartCounter.toString(), default_length: 2);
    _wishlistCounterString =
        counterText(_wishlistCounter.toString(), default_length: 2);
    _orderCounterString =
        counterText(_orderCounter.toString(), default_length: 2);

    setState(() {});
  }

  deleteAccountReq() async {
    loading();
    var response = await AuthRepository().getAccountDeleteResponse();

    if (response.result!) {
      AuthHelper().clearUserData();
      Navigator.pop(loadingcontext);
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (context) {
        return Main();
      }), (route) => false);
    }
    ToastComponent.showDialog(response.message!);
  }

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
      child: buildView(context),
    );
  }

  Widget buildView(context) {
    return Container(
      color: Colors.white,
      height: DeviceInfo(context).height,
      child: Stack(
        children: [
          /* Container(
              height: DeviceInfo(context).height! / 1.6,
              width: DeviceInfo(context).width,
              color: MyTheme.accent_color,
              alignment: Alignment.topRight,
              child: Image.asset(
                "assets/background_1.png",
              )),*/
          Scaffold(
            key: homeData.scaffoldKey,
            drawer: const MainDrawer(),
            backgroundColor: Colors.transparent,
            appBar: buildCustomAppBar(context),
            body: buildBody(),
          ),
        ],
      ),
    );
  }

  RefreshIndicator buildBody() {
    return RefreshIndicator(
      color: MyTheme.white,
      backgroundColor: MyTheme.primary_color,
      onRefresh: _onPageRefresh,
      displacement: 10,
      child: buildBodyChildren(),
    );
  }

  CustomScrollView buildBodyChildren() {
    return CustomScrollView(
      controller: _mainScrollController,
      physics:
          const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      slivers: [
        SliverList(
          delegate: SliverChildListDelegate([
            //Profile Image
            Padding(
              padding: const EdgeInsets.only(right: 70.0, left: 70, top: 20),
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(color: MyTheme.white, width: 1),
                  //shape: BoxShape.rectangle,
                ),
                child: (user != null)
                    ? ClipRRect(
                        clipBehavior: Clip.hardEdge,
                        borderRadius: BorderRadius.all(Radius.circular(25.0)),
                        child: FadeInImage.assetNetwork(
                          placeholder: 'assets/placeholder.png',
                          image: "${avatar_original.$}",
                          fit: BoxFit.fill,
                        ))
                    : Image.asset(
                        'assets/profile_placeholder.png',
                        height: 150,
                        width: 150,
                        fit: BoxFit.fitHeight,
                      ),
              ),
            ),

            //Profile name /email
            Padding(
              padding: const EdgeInsets.only(left: 30.0, right: 30, top: 10),
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      10,
                    ),
                    color: Color(0xff75A4FE)),
                child: Center(child: buildUserInfo()),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: buildCountersRow(),
            ),

            SizedBox(height: 15),

            Padding(
              padding: const EdgeInsets.only(left: 18.0, right: 18),
              child: buildSettingAndAddonsHorizontalMenu(),
            ),

            SizedBox(height: 15),

            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20),
              child: buildBottomVerticalCardList(),
            ),

            SizedBox(
              height: 100,
            )
          ]),
        )
      ],
    );
  }

  PreferredSize buildCustomAppBar(context) {
    return PreferredSize(
      preferredSize: Size(DeviceInfo(context).width!, 80),
      child: Container(
        height: 80,
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
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  // margin: EdgeInsets.only(right: 18),
                  height: 20,
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: IconButton(
                          onPressed: () {
                            homeData.scaffoldKey.currentState?.openDrawer();
                          },
                          icon: Icon(
                            Icons.menu,
                            color: MyTheme.white,
                            size: 25,
                          )),
                    ),
                  ),
                ),
                Center(
                  child: Text(AppLocalizations.of(context)!.acccount_ucf,
                      style: TextStyle(
                          color: MyTheme.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          letterSpacing: .5,
                          fontFamily: 'Poppins')),
                ),
                SizedBox(
                  width: 30,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildBottomVerticalCardList() {
    return Container(
      // margin: EdgeInsets.only(bottom: 120, ),
      // padding: EdgeInsets.symmetric(horizontal: 22,),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildBottomVerticalCardListItem(
              "assets/wallet.png",
              LangText(context).local!.notification_ucf,
              Color(0xff9747FF), onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return NotificationScreen();
            }));
          }),

          buildBottomVerticalCardListItem(
              "assets/wallet.png",
              LangText(context).local!.wallet_balance_ucf,
              Color(0xffBB3636), onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return Wallet();
            }));
          }),

          buildBottomVerticalCardListItem(
              "assets/wallet.png",
              LangText(context).local!.purchase_ucf,
              Color(0xff69BB36), onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return OrderList();
            }));
          }),

          //if (false)
          /* Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildBottomVerticalCardListItem(
                    "assets/coupon.png", LangText(context).local!.coupons_ucf,Color(0xff9747FF),
                    onPressed: () {}),
                Divider(
                  thickness: 1,
                  color: MyTheme.light_grey,
                ),
                buildBottomVerticalCardListItem("assets/favoriteseller.png",
                    LangText(context).local!.favorite_seller_ucf,Color(0xff),
                    onPressed: () {}),
                Divider(
                  thickness: 1,
                  color: MyTheme.light_grey,
                ),
              ],
            ),*/

          /*  buildBottomVerticalCardListItem("assets/download.png",
              LangText(context).local!.all_digital_products_ucf, Color(0xff9747FF), onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return DigitalProducts();
                }));
              }),*/
          /* Divider(
            thickness: 1,
            color: MyTheme.light_grey,
          ),*/

          // this is addon
          // if (false)

          /* Column(
              children: [
                buildBottomVerticalCardListItem("assets/auction.png",
                    LangText(context).local!.on_auction_products_ucf,Color(0xff),
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
            ),*/

          /*if (classified_product_status.$)
            Column(
              children: [
                buildBottomVerticalCardListItem("assets/classified_product.png",
                    LangText(context).local!.classified_ads_ucf, Color(0xff9747FF), onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                        return ClassifiedAds();
                      }));
                    }),
                Divider(
                  thickness: 1,
                  color: MyTheme.light_grey,
                ),
              ],
            ),*/

          // this is addon auction product
          //  if (false)
          /*   Column(
              children: [
                buildBottomVerticalCardListItem("assets/auction.png",
                    LangText(context).local!.on_auction_products_ucf,Color(0xff9747FF),
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
            ),*/
          // if (auction_addon_installed.$)
          /*  Column(
              children: [
                buildBottomVerticalCardListItem("assets/auction.png",
                    LangText(context).local!.on_auction_products_ucf,Color(0xff9747FF),
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
            ),*/

          // this is addon
          // if (false)
          /*  Column(
              children: [
                buildBottomVerticalCardListItem("assets/wholesale.png",
                    LangText(context).local!.wholesale_products_ucf,Color(0xff9747FF),
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
            ),*/

          //  if (vendor_system.$)
          /* Column(
              children: [
                buildBottomVerticalCardListItem("assets/shop.png",
                    LangText(context).local!.browse_all_sellers_ucf,Color(0xffBB3636),
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
            ),*/

          //if (is_logged_in.$)

          // if (is_logged_in.$)
          /*  Column(
              children: [
                buildBottomVerticalCardListItem("assets/delete.png",
                    LangText(context).local!.delete_my_account,Color(0xff9747FF), onPressed: () {
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
            ),*/

          // if (false)
          /*  buildBottomVerticalCardListItem(
                "assets/blog.png", LangText(context).local!.blogs_ucf,Color(0xff69BB36),
                onPressed: () {}),*/
        ],
      ),
    );
  }

  Container buildBottomVerticalCardListItem(String img, String label, color,
      {Function()? onPressed, bool isDisable = false}) {
    return Container(
      height: 60,
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
              child: CircleAvatar(
                backgroundColor: color,
                radius: 25,
                child: Image.asset(
                  img,
                  height: 25,
                  width: 25,
                  color: isDisable ? MyTheme.white : MyTheme.white,
                ),
              ),
            ),
            Text(
              label,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  letterSpacing: .5,
                  color: isDisable ? Color(0xff2F2D2D) : Color(0xff2F2D2D),
                  fontFamily: 'Poppins'),
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
      // margin: EdgeInsets.only(top: 20),
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
              (user != null),
              "assets/edit.png",
              AppLocalizations.of(context)!.edit_profile_ucf,
              // is_logged_in.$
              (user != null)
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
              (user != null),
              "assets/location.png",
              AppLocalizations.of(context)!.address_ucf,
              // is_logged_in.$
              (user != null)
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
                      deleteAccountReq();
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
      width: DeviceInfo(context).width,
      child: GridView.count(
        // gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        //   crossAxisCount: 3,
        // ),
        crossAxisCount: 4,
        childAspectRatio: 1,
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        cacheExtent: 5.0,
        mainAxisSpacing: 16,
        children: [
          //if (wallet_system_status.$)
          /*  Container(
              // color: Colors.red,

              child: buildSettingAndAddonsHorizontalMenuItem(
                  "assets/wallet.png",
                  AppLocalizations.of(context)!.my_wallet_ucf, () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return Wallet();
                }));
              },Color(0xff10D8F3)),
            ),*/

          buildSettingAndAddonsHorizontalMenuItem(
              "assets/orders.png",
              AppLocalizations.of(context)!.orders_ucf,
              is_logged_in.$
                  ? () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return OrderList();
                      }));
                    }
                  : () => null,
              Color(0xff10D8F3)),

          buildSettingAndAddonsHorizontalMenuItem(
              "assets/profile.png",
              AppLocalizations.of(context)!.profile__ucf,
              is_logged_in.$
                  ? () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return ProfileEdit();
                      }));
                    }
                  : () => null,
              Color(0xffF60F0F)),

          buildSettingAndAddonsHorizontalMenuItem(
              "assets/messages.png",
              AppLocalizations.of(context)!.messages_ucf,
              is_logged_in.$
                  ? () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return MessengerList();
                      }));
                    }
                  : () => null,
              Color(0xff0A3CEE)),

          buildSettingAndAddonsHorizontalMenuItem(
              "assets/location.png",
              AppLocalizations.of(context)!.address_ucf,
              is_logged_in.$
                  ? () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return Address();
                      }));
                    }
                  : () => null,
              Color(0xffDB00FF)),

          //   if (club_point_addon_installed.$)
          /* buildSettingAndAddonsHorizontalMenuItem(
                "assets/points.png",
                AppLocalizations.of(context)!.earned_points_ucf,
                is_logged_in.$
                    ? () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) {
                        return Clubpoint();
                      }));
                }
                    : () => null,Color(0xff0A3CEE)),*/

          //  if (refund_addon_installed.$)
          /* buildSettingAndAddonsHorizontalMenuItem(
                "assets/refund.png",
                AppLocalizations.of(context)!.refund_requests_ucf,
                is_logged_in.$
                    ? () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) {
                        return RefundRequest();
                      }));
                }
                    : () => null,Color(0xff0A3CEE)),*/
          //  if (conversation_system_status.$)

          // if (auction_addon_installed.$)

          // if (false)

          /*  buildSettingAndAddonsHorizontalMenuItem(
                "assets/auction.png",
                AppLocalizations.of(context)!.auction_ucf,
                is_logged_in.$
                    ? () {
                  // Navigator.push(context,
                  //     MaterialPageRoute(builder: (context) {
                  //   return MessengerList();
                  // }));
                }
                    : () => null,Color(0xff0A3CEE)),*/

          //if (classified_product_status.$)

          /*  buildSettingAndAddonsHorizontalMenuItem(
                "assets/classified_product.png",
                AppLocalizations.of(context)!.classified_products,
                is_logged_in.$
                    ? () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) {
                        return MyClassifiedAds();
                      }));
                }
                    : () => null,Color(0xffDB00FF)),*/
        ],
      ),
    );
  }

  Container buildSettingAndAddonsHorizontalMenuItem(
      String img, String text, Function() onTap, color) {
    return Container(
      height: 100,
      alignment: Alignment.center,
      width: DeviceInfo(context).width! / 4,
      child: InkWell(
        onTap: is_logged_in.$
            ? onTap
            : () {
                showLoginWarning();
              },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            CircleAvatar(
              backgroundColor: color,
              radius: 25,
              child: Image.asset(
                img,
                scale: .1,
                width: 25,
                height: 25,
                color: is_logged_in.$ ? MyTheme.white : MyTheme.white,
              ),
            ),
            SizedBox(
              height: 1,
            ),
            Text(
              text,
              textAlign: TextAlign.center,
              maxLines: 1,
              style: TextStyle(
                  color: is_logged_in.$
                      ? MyTheme.dark_font_grey
                      : MyTheme.medium_grey_50,
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
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        buildCountersRowItem(
          _cartCounterString,
          AppLocalizations.of(context)!.in_your_cart_all_lower,
        ),
        buildCountersRowItem(
          _wishlistCounterString,
          AppLocalizations.of(context)!.in_your_wishlist_all_lower,
        ),
      ],
    );
  }

  Widget buildCountersRowItem(String counter, String title) {
    return Container(
        margin: EdgeInsets.only(top: 10),
        padding: EdgeInsets.symmetric(vertical: 14),
        width: DeviceInfo(context).width! / 3.8,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: MyTheme.green_light,
        ),
        child: IconButton(
          onPressed: () {},
          icon: Image.asset(
            'assets/cart.png',
            height: 16,
            color: Colors.red,
          ),
        ));
  }

  Widget buildAppbarSection() {
    return Container(
      // color: Colors.amber,
      alignment: Alignment.center,
      height: 48,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          //logout
          /* Container(
            width: 70,
            height: 26,
            child: Btn.basic(
              padding: EdgeInsets.symmetric(horizontal: 14, vertical: 7),
              // 	rgb(50,205,50)
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                  side: BorderSide(color: MyTheme.white)),
              child: Text(
                is_logged_in.$
                    ? AppLocalizations.of(context)!.logout_ucf
                    : LangText(context).local!.login_ucf,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w500),
              ),
              onPressed: () {
                if (is_logged_in.$)
                  onTapLogout(context);
                else
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Login()));
              },
            ),
          ),*/
        ],
      ),
    );
  }

  Widget buildUserInfo() {
    return is_logged_in.$
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                "${user_name.$}",
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.w500),
              ),
              Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text(
                    //if user email is not available then check user phone if user phone is not available use empty string
                    "${user_email.$ != "" && user_email.$ != null ? user_email.$ : user_phone.$ != "" && user_phone.$ != null ? user_phone.$ : ''}",
                    style: TextStyle(color: Colors.black, fontSize: 18),
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
