import 'package:active_ecommerce_flutter/features/profile/expanded_tile_widget.dart';
import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../custom/device_info.dart';

import 'package:flutter_expanded_tile/flutter_expanded_tile.dart';
import 'package:percent_indicator/percent_indicator.dart';

// import '../seller_platform/seller_platform.dart';

class MoreDetails extends StatefulWidget {
  const MoreDetails({Key? key}) : super(key: key);

  @override
  State<MoreDetails> createState() => _MoreDetailsState();
}

class _MoreDetailsState extends State<MoreDetails> {
  final _controller1 = ExpandedTileController();
  final _controller2 = new ExpandedTileController();
  final _controller3 = new ExpandedTileController();
  final _controller35 = new ExpandedTileController();
  final _controller4 = new ExpandedTileController();

  String title = "KYC";
  final double progress = 0.80;

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
            body: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
              child: ListView(
                children: [
                  Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: MyTheme.dark_grey,
                        ),
                        borderRadius: BorderRadius.circular(15)),
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(3),
                          child: Stack(
                            children: [
                              ClipRRect(
                                child: CircleAvatar(
                                  backgroundColor: MyTheme.light_grey,
                                  radius: 40,
                                ),
                              ),
                              Positioned(
                                top: 0,
                                left: 0,
                                child: ClipRRect(
                                  child: CircleAvatar(
                                    backgroundImage:
                                        AssetImage("assets/girl.png"),
                                    radius: 40,
                                  ),
                                ),
                              ),
                              Positioned(
                                // top: 10,
                                // left: 5,
                                bottom: 0,
                                left: 55,
                                child: ClipRRect(
                                  child: CircleAvatar(
                                    radius: 12,
                                    backgroundColor: MyTheme.green,
                                    child: Icon(
                                      Icons.check,
                                      size: 17.0,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CircularPercentIndicator(
                            center: new Text(
                              "${(progress * 100).toInt()}%",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13.0,
                                  color: MyTheme.dark_grey),
                            ),
                            radius: 30.0,
                            lineWidth: 10.0,
                            percent: progress,
                            backgroundColor: MyTheme.dark_grey,
                            progressColor: MyTheme.green,
                          ),
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('10 friends & neighbours',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 13.0,
                                      color: Colors.black)),
                              SizedBox(
                                height: 5,
                              ),
                              Text('20 Groups',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 13.0,
                                      color: Colors.black)),
                              SizedBox(
                                height: 5,
                              ),
                              Text('Society: Pitlali 577511',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 13.0,
                                      color: Colors.black)),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ExpandedTileWidget(
                    controller: _controller1,
                    title: 'District, Taluk, Village, Pincode',
                    children: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(child: Text('1. Adhaar Card')),
                            Expanded(child: Text('7848749257')),
                            CircleAvatar(
                              radius: 12,
                              backgroundColor: MyTheme.green,
                              child: Icon(
                                Icons.check,
                                size: 15.0,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 3,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(child: Text('2. Pan Card')),
                            Expanded(child: Text('DLFJF8248D')),
                            Icon(
                              Icons.upload_file_outlined,
                              size: 23.0,
                              color: MyTheme.green,
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(child: Text('3. GST Details')),
                            Expanded(child: Text('HTFJF8245544148D')),
                            Icon(
                              Icons.upload_file_outlined,
                              size: 23.0,
                              color: MyTheme.green,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  ExpandedTileWidget(
                    controller: _controller2,
                    title: 'KYC',
                    children: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(child: Text('1. Adhaar Card')),
                            Expanded(child: Text('7848749257')),
                            CircleAvatar(
                              radius: 12,
                              backgroundColor: MyTheme.green,
                              child: Icon(
                                Icons.check,
                                size: 15.0,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 3,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(child: Text('2. Pan Card')),
                            Expanded(child: Text('DLFJF8248D')),
                            Icon(
                              Icons.upload_file_outlined,
                              size: 23.0,
                              color: MyTheme.green,
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(child: Text('3. GST Details')),
                            Expanded(child: Text('HTFJF8245544148D')),
                            Icon(
                              Icons.upload_file_outlined,
                              size: 23.0,
                              color: MyTheme.green,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  ExpandedTileWidget(
                    controller: _controller3,
                    title: 'Village, Land Details',
                    children: Column(
                      children: [
                        ExpandedTileWidget(
                          controller: _controller35,
                          title: 'Embedded',
                          children: Column(
                            children: [
                              Text('Text inside embedded'),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(child: Text('1. Adhaar Card')),
                            Expanded(child: Text('7848749257')),
                            CircleAvatar(
                              radius: 12,
                              backgroundColor: MyTheme.green,
                              child: Icon(
                                Icons.check,
                                size: 15.0,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 3,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(child: Text('2. Pan Card')),
                            Expanded(child: Text('DLFJF8248D')),
                            Icon(
                              Icons.upload_file_outlined,
                              size: 23.0,
                              color: MyTheme.green,
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(child: Text('3. GST Details')),
                            Expanded(child: Text('HTFJF8245544148D')),
                            Icon(
                              Icons.upload_file_outlined,
                              size: 23.0,
                              color: MyTheme.green,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  ExpandedTileWidget(
                    controller: _controller4,
                    title: title,
                    children: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(child: Text('1. Adhaar Card')),
                            Expanded(child: Text('7848749257')),
                            CircleAvatar(
                              radius: 12,
                              backgroundColor: MyTheme.green,
                              child: Icon(
                                Icons.check,
                                size: 15.0,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 3,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(child: Text('2. Pan Card')),
                            Expanded(child: Text('DLFJF8248D')),
                            Icon(
                              Icons.upload_file_outlined,
                              size: 23.0,
                              color: MyTheme.green,
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(child: Text('3. GST Details')),
                            Expanded(child: Text('HTFJF8245544148D')),
                            Icon(
                              Icons.upload_file_outlined,
                              size: 23.0,
                              color: MyTheme.green,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // RefreshIndicator buildBody() {
  //   return RefreshIndicator(
  //     color: MyTheme.white,
  //     backgroundColor: MyTheme.primary_color,
  //     onRefresh: _onPageRefresh,
  //     displacement: 10,
  //     child: bodycontent(),
  //   );
  // }

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
                  child: Text(AppLocalizations.of(context)!.more_detail_ucf,
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
}
