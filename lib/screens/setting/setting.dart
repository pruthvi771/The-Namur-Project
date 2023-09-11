import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../custom/device_info.dart';
import '../../my_theme.dart';
class Setting extends StatefulWidget {
  const Setting({Key? key}) : super(key: key);

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  Future<void> _onPageRefresh() async {
    //reset();
    // fetchAll();
  }


  @override
  Widget build(BuildContext context) {
    return  Container(
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
      child: Container(),
    );
  }

  PreferredSize buildCustomAppBar(context) {
    return PreferredSize(
      preferredSize: Size(DeviceInfo(context).width!, 80),
      child: Container(
        height: 92,
        decoration: BoxDecoration(
            gradient:LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors:[Color(0xff107B28),Color(0xff4C7B10)]
            )),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(left: 20.0,right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: EdgeInsets.only(right: 18),
                  height: 30,
                  child:  Container(
                    child: InkWell(
                      //padding: EdgeInsets.zero,
                      onTap: (){
                        Navigator.pop(context);
                      } ,child:Icon(Icons.keyboard_arrow_left,size: 35,color: MyTheme.white,), ),
                  ),
                ),

                Center(
                  child: Text(
                      AppLocalizations.of(context)!
                          .setting_ucf,
                      style: TextStyle(
                          color: MyTheme.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          letterSpacing: .5,
                          fontFamily: 'Poppins')),
                ),
                SizedBox(width: 30,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
