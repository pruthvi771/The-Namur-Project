import 'package:active_ecommerce_flutter/sell_screen/more_detail/more_detail.dart';
import 'package:active_ecommerce_flutter/sell_screen/product_inventory/product_inventory.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../custom/device_info.dart';
import '../../my_theme.dart';
import '../../presenter/home_presenter.dart';
import '../../drawer/drawer.dart';
import '../product_post/product_post.dart';

class SellerPlatform extends StatefulWidget {
  const SellerPlatform({Key? key}) : super(key: key);

  @override
  State<SellerPlatform> createState() => _SellerPlatformState();
}

class _SellerPlatformState extends State<SellerPlatform> {
  Future<void> _onPageRefresh() async {
    //reset();
    // fetchAll();
  }

  bool _switchValue = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: DeviceInfo(context).height,
      child: Stack(
        children: [
          Scaffold(
            // key: homeData.scaffoldKey,
            // drawer: const MainDrawer(),
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
      child: bodycontent(),
    );
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
                Container(
                  height: 30,
                  child: Center(
                    child: Text(
                        AppLocalizations.of(context)!.seller_platform_ucf,
                        style: TextStyle(
                            color: MyTheme.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            letterSpacing: .5,
                            fontFamily: 'Poppins')),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(right: 0, bottom: 10),
                  height: 30,
                  child: Container(
                    child: InkWell(
                      //padding: EdgeInsets.zero,
                      onTap: () {
                        Navigator.pop(context);
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

  bodycontent() {
    return Stack(
      children: [
        ListView(
          children: [
            Container(
              child: ListView.builder(
                  itemCount: 3,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding:
                          const EdgeInsets.only(left: 16.0, right: 16, top: 16),
                      child: Material(
                        elevation: 1,
                        borderRadius: BorderRadius.circular(15),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ProductInventory()));
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(
                                    width: 1, color: MyTheme.medium_grey)),
                            height: 90,
                            width: MediaQuery.of(context).size.width,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                    width:
                                        MediaQuery.of(context).size.width / 3,
                                    child: ClipRRect(
                                        borderRadius: BorderRadius.circular(15),
                                        child:
                                            Image.asset("assets/orange.png"))),
                                SizedBox(),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      "Orange",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Text(
                                      "20%off",
                                      maxLines: 2,
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w400,
                                          color: MyTheme.dark_grey,
                                          height: 1.2),
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                  ],
                                ),
                                SizedBox(),
                                Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text(
                                        "1kg",
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      Text(
                                        "Rs 10/kg",
                                        maxLines: 2,
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black,
                                            height: 1.2),
                                      ),
                                      Container(
                                        height: 25,
                                        width: 50,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: MyTheme.primary_color),
                                            borderRadius:
                                                BorderRadius.circular(8)),
                                        child: Center(child: Text("Add")),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
            ),
          ],
        ),
        Positioned(
          bottom: 80,
          left: 15,
          right: 15,
          child: InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SellerPlatform()));
            },
            child: Container(
              height: 50,
              width: MediaQuery.of(context).size.width / 1.2,
              decoration: BoxDecoration(
                  color: MyTheme.primary_color,
                  borderRadius: BorderRadius.circular(10)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: 30,
                          width: 35,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.white),
                          child: Image.asset("assets/onion.png"),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "3 items",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500),
                            ),
                            Text(
                              "Rs 30 Rs36",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Container(
                    child: Row(
                      children: [
                        Container(
                          child: Text(
                            "View Cart",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        Icon(
                          Icons.keyboard_arrow_right,
                          color: Colors.white,
                        ),
                        SizedBox(width: 5),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Spacer(),
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: FloatingActionButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => ProductPost()));
                  },
                  child: Image.asset("assets/add 2.png"),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
