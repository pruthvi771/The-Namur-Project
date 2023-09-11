import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../custom/device_info.dart';
import '../../my_theme.dart';

class Description extends StatefulWidget {
  const Description({Key? key}) : super(key: key);

  @override
  State<Description> createState() => _DescriptionState();
}

class _DescriptionState extends State<Description> {

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
                SizedBox(width: 30,),

                Center(
                  child: Text(
                      AppLocalizations.of(context)!
                          .descriptions_ucf,
                      style: TextStyle(
                          color: MyTheme.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          letterSpacing: .5,
                          fontFamily: 'Poppins')),
                ),

                Container(
                  margin: EdgeInsets.only(right: 0),
                  height: 35,
                  child:  Container(
                    child: InkWell(
                      //padding: EdgeInsets.zero,
                      onTap: (){
                        Navigator.pop(context);
                      } ,child:Icon(Icons.keyboard_arrow_left,size: 35,color: MyTheme.white,), ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bodycontent(){

    return ListView(
      children: [
        Container(
          height: 200,
            width: MediaQuery.of(context).size.width,
            child: Image.asset("assets/graph.png",
            fit: BoxFit.fill,),
        ),

        Container(
          margin: EdgeInsets.only(top: 10),
          height: 90,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(color: MyTheme.light_grey,
          borderRadius: BorderRadius.circular(15)),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                 Row(
                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   children: [
                     Text("Onion",style: TextStyle(
                       fontSize: 25,
                       fontWeight: FontWeight.w500
                     ),),

                     Text("Rs 100kg",style: TextStyle(
                         fontSize: 20,
                         fontWeight: FontWeight.w500,
                       color: Colors.red
                     ),),
                   ],
                 ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Stock Avail 1 Ton",style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      color: MyTheme.textfield_grey
                    ),),

                    Icon(Icons.favorite_border,
                    color: Colors.red,),

                    Text("Qty",style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: MyTheme.textfield_grey
                    ),),

                    Container(
                      height: 40,
                      width: 100,
                      decoration: BoxDecoration(color: Color(0xff9BEA63),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Icon(Icons.remove,color: MyTheme.textfield_grey,size: 25,),
                          Text("20",
                          style: TextStyle(fontSize: 20),),
                          Icon(Icons.add,color: MyTheme.textfield_grey,size: 25,)
                        ],
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),

        Container(
          margin: EdgeInsets.only(top: 10),
          height: 90,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(color: MyTheme.light_grey,
              borderRadius: BorderRadius.circular(15)),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Onion",style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w500
                    ),),

                    Text("Rs 100kg",style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Colors.red
                    ),),
                  ],
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Stock Avail 1 Ton",style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: MyTheme.textfield_grey
                    ),),

                    Icon(Icons.favorite_border,
                      color: Colors.red,),

                    Text("Qty",style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: MyTheme.textfield_grey
                    ),),

                    Container(
                      height: 40,
                      width: 100,
                      decoration: BoxDecoration(color: Color(0xff9BEA63),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Icon(Icons.remove,color: MyTheme.textfield_grey,size: 25,),
                          Text("20",
                            style: TextStyle(fontSize: 20),),
                          Icon(Icons.add,color: MyTheme.textfield_grey,size: 25,)
                        ],
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),

        Container(
          margin: EdgeInsets.only(top: 10),
          height: 90,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(color: MyTheme.light_grey,
              borderRadius: BorderRadius.circular(15)),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Onion",style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w500
                    ),),

                    Text("Rs 100kg",style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Colors.red
                    ),),
                  ],
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Stock Avail 1 Ton",style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: MyTheme.textfield_grey
                    ),),

                    Icon(Icons.favorite_border,
                      color: Colors.red,),

                    Text("Qty",style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: MyTheme.textfield_grey
                    ),),

                    Container(
                      height: 40,
                      width: 100,
                      decoration: BoxDecoration(color: Color(0xff9BEA63),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Icon(Icons.remove,color: MyTheme.textfield_grey,size: 25,),
                          Text("20",
                            style: TextStyle(fontSize: 20),),
                          Icon(Icons.add,color: MyTheme.textfield_grey,size: 25,)
                        ],
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        )

      ],
    );
  }
}

