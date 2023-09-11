import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../custom/device_info.dart';
import '../../my_theme.dart';
class WeatherScreen extends StatefulWidget {
  const WeatherScreen({Key? key}) : super(key: key);

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {

  Future<void> _onPageRefresh() async {
    //reset();
    // fetchAll();
  }

  bool _switchValue = false;


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
      child: bodycontent(),
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
                          .weather_ucf,
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

  bodycontent(){

    return Column(
          children: [
           Padding(
             padding: const EdgeInsets.all(20.0),
             child: Container(
               height: 44,
               width: MediaQuery.of(context).size.width,
               decoration: BoxDecoration(
                 border: Border.all(color: MyTheme.textfield_grey),
                 color: MyTheme.light_grey,
                 borderRadius: BorderRadius.circular(5),
               ),
               child: Row(
                 children: [
                   Padding(
                   padding: const EdgeInsets.all(8.0),
                   child: Icon(Icons.search),
                 ),
                 Padding(
                   padding: const EdgeInsets.all(8.0),
                   child: Text("Pitlali 577511",
                   style: TextStyle(
                     fontWeight: FontWeight.bold,
                     fontSize: 15
                   ),),
                 )],
               )
             ),
           ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0,right: 20.0,),
              child: Image.asset("assets/weather1.png"),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0,right: 20.0,top: 10),
              child: Image.asset("assets/satelite.png"),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0,),
              child: Text("Satellite View",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15
                ),),
            )
          ],
    );
  }
}

