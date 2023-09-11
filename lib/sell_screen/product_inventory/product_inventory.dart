import 'package:active_ecommerce_flutter/screens/seller_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../custom/device_info.dart';
import '../../my_theme.dart';
import '../../presenter/home_presenter.dart';
import '../../ui_sections/drawer.dart';
import '../product_post/product_post.dart';
import '../seller_platform/seller_platform.dart';
class ProductInventory extends StatefulWidget {
  const ProductInventory({Key? key}) : super(key: key);

  @override
  State<ProductInventory> createState() => _ProductInventoryState();
}

class _ProductInventoryState extends State<ProductInventory> {

  HomePresenter homeData = HomePresenter();

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
                  margin: EdgeInsets.only(right: 15,bottom: 10),
                  height: 30,
                  child:  Container(
                    child: IconButton(
                        onPressed: () {
                          homeData.scaffoldKey.currentState?.openDrawer();
                        },
                        icon: Center(child: Icon(Icons.menu,color: Colors.white,))),
                  ),
                ),


                Container(
                  height: 30,
                  child: Center(
                    child: Text(
                        AppLocalizations.of(context)!
                            .product_inventory_ucf,
                        style: TextStyle(
                            color: MyTheme.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            letterSpacing: .5,
                            fontFamily: 'Poppins')),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(right:0,bottom: 10),
                  height: 30,
                  child:  Container(
                    child:  InkWell(
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
                  itemBuilder: (context,index){
                    return Padding(
                      padding: const EdgeInsets.only(left: 20.0,right: 20,top: 10),
                      child: Material(
                        elevation: 1,
                        borderRadius: BorderRadius.circular(15),
                        child: Container(
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(15),
                          border: Border.all(width: 1,color: MyTheme.medium_grey)),
                          height:100,
                          width: MediaQuery.of(context).size.width,
                          child: Padding(
                            padding: const EdgeInsets.all(7.0),
                            child: Row(
                           //    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                    height: 88,
                                    width: MediaQuery.of(context).size.width/3,
                                    child: Image.asset("assets/graph.png")),
                                Padding(
                                  padding: const EdgeInsets.only(top: 4.0,bottom: 4.0,left: 4.0),
                                  child: Container(
                                    width: MediaQuery.of(context).size.width/2,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text("Grapes Black",
                                                style: TextStyle(
                                                    fontSize: 15,fontWeight: FontWeight.w600
                                                ),),

                                              Text("1kg",
                                                style: TextStyle(
                                                    fontSize: 15,fontWeight: FontWeight.w500
                                                ),),
                                            ],
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text("20%off",
                                              maxLines: 2,
                                              style: TextStyle(fontSize:15,
                                                  fontWeight: FontWeight.w400,
                                                  color: MyTheme.dark_grey,
                                                  height: 1.2),),
                                            Text("Rs 10/kg",
                                              maxLines: 2,
                                              style: TextStyle(fontSize:13,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.black,
                                                  height: 1.2),),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text("Stock 300kg",
                                              maxLines: 2,
                                              style: TextStyle(fontSize:15,
                                                  fontWeight: FontWeight.w400,
                                                  color: MyTheme.dark_grey,
                                                  height: 1.2),),
                                          Image.asset("assets/edit1.png"),
                                            Image.asset("assets/delet1.png"),

                                          ],
                                        )
                                      ],
                                    ),
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

         Container(
           width: MediaQuery.of(context).size.width,
           child: Column(
             crossAxisAlignment: CrossAxisAlignment.end,
             children: [
               Spacer(),
               Padding(
                 padding: const EdgeInsets.all( 18.0),
                 child: FloatingActionButton(onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> ProductPost()));//ProductPost()
        },
                 child: Image.asset("assets/add 2.png"),),
               ),
             ],
           ),
         )
      ],
    );
  }
}
