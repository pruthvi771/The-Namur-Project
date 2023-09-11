import 'package:active_ecommerce_flutter/screens/wallet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../custom/device_info.dart';
import '../../my_theme.dart';
import '../../presenter/home_presenter.dart';
import '../../sell_screen/product_post/product_post.dart';
import '../product_details.dart';


class Option extends StatefulWidget {
   Option({Key? key,this.id}) : super(key: key);

int? id;
  @override
  State<Option> createState() => _OptionState();
}

class _OptionState extends State<Option> {

  HomePresenter homeData = HomePresenter();

  Future<void> _onPageRefresh() async {
    //reset();
    // fetchAll();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  var colordata =  1;

  value(){
    var i = 1;
    do{
      colordata = 1;
      i++;
    }while(i<40);

  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: DeviceInfo(context).height,
      child: Stack(
        children: [
          Scaffold(
            key: homeData.scaffoldKey,
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
      child: bodyscreen(),
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
                SizedBox(width: 30,),
                /* IconButton(
                  onPressed: () {
                    homeData.scaffoldKey.currentState?.openDrawer();
                  },
                  icon: Icon(
                    Icons.menu,
                    color: Colors.white,
                  ),
                ),*/
                Center(
                  child: Text(
                      AppLocalizations.of(context)!.option_ucf,
                      style: TextStyle(
                          color: MyTheme.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          letterSpacing: .5,
                          fontFamily: 'Poppins')),
                ),
                Container(
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


    bodyscreen() {
    return Stack(
      children: [
        ListView(
          children: [
            Container(
              height: 40,
              child: ListView(
               // reverse: false,
              //  shrinkWrap: true,
                scrollDirection: Axis.horizontal,
            //     itemCount: 5,
                     children: [
                       Padding(
                         padding: const EdgeInsets.only(left: 8.0, top: 8),
                         child: Container(
                           decoration: BoxDecoration(
                               borderRadius: BorderRadius.circular(15),
                               border: Border.all(
                                 color: MyTheme.grey_153
                               )),
                           child: Padding(
                             padding: const EdgeInsets.all(8.0),
                             child: Row(
                               mainAxisAlignment: MainAxisAlignment.center,
                               children: [
                                 Text("Short By",
                                 style: TextStyle(fontSize: 12,
                                 fontWeight: FontWeight.w400,
                                 ),),
                                 Icon(Icons.keyboard_arrow_down_rounded,
                                   size: 15,)
                               ],
                             ),
                           ),),
                       ),

                       //filter
                       Padding(
                         padding: const EdgeInsets.only(left: 8.0, top: 8),
                         child: Container(
                           decoration: BoxDecoration(
                               borderRadius: BorderRadius.circular(15),
                               border: Border.all(color: MyTheme.grey_153)),
                           child: Padding(
                             padding: const EdgeInsets.all(8.0),
                             child: Row(
                               mainAxisAlignment: MainAxisAlignment.center,
                               children: [
                                 Icon(Icons.add,
                                   size: 15,),
                                 Text("Filter",
                                 style: TextStyle(fontSize: 12),),
                               ],
                             ),
                           ),),
                       ),

                       Padding(
                         padding: const EdgeInsets.only(left: 8.0, top: 8),
                         child: Container(
                           decoration: BoxDecoration(
                               borderRadius: BorderRadius.circular(15),
                               border: Border.all(color: MyTheme.grey_153)),
                           child: Padding(
                             padding: const EdgeInsets.all(8.0),
                             child: Row(
                               mainAxisAlignment: MainAxisAlignment.center,
                               children: [
                                 Text("Price"),
                                 Icon(Icons.keyboard_arrow_down_rounded,
                                   size: 15,)
                               ],
                             ),
                           ),),
                       ),

                       Padding(
                         padding: const EdgeInsets.only(left: 8.0, top: 8),
                         child: Container(
                           decoration: BoxDecoration(
                               borderRadius: BorderRadius.circular(15),
                               border: Border.all(color: MyTheme.grey_153)),
                           child: Padding(
                             padding: const EdgeInsets.all(8.0),
                             child: Row(
                               mainAxisAlignment: MainAxisAlignment.center,
                               children: [
                                 Text("Material"),
                                 Icon(Icons.keyboard_arrow_down_rounded,
                                   size: 15,)
                               ],
                             ),
                           ),),
                       ),

                       Padding(
                         padding: const EdgeInsets.only(left: 8.0, top: 8),
                         child: Container(width: 70,
                           height: 30,
                           decoration: BoxDecoration(
                               borderRadius: BorderRadius.circular(15),
                               border: Border.all(color: MyTheme.grey_153)),
                           child: Row(
                             mainAxisAlignment: MainAxisAlignment.center,
                             children: [
                               Text("Brand"),
                               Icon(Icons.keyboard_arrow_down_rounded,
                                 size: 15,)
                             ],
                           ),),
                       ),
                     ],
                  ),

              ),




            Container(
              height: MediaQuery.of(context).size.height,
              child: ListView.builder(
                  itemCount: 3,
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context,index){
                    return Padding(
                      padding: const EdgeInsets.only(left: 16.0,top: 16,right: 16.0),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) {
                            return ProductDetails(
                              id: widget.id,
                            );
                          }));
                        },
                        child: Container( width: 60,
                          height: 110,
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: MyTheme.light_grey,)),
                        child:  Row(
                          children: [
                            Container(
                              width: 110,
                              height: 110,
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: MyTheme.light_grey,
                                width: 2)
                                  ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: Image.asset("assets/graph.png",
                                fit: BoxFit.fill,),
                              ),
                            ),

                            Expanded(
                              child: Container(
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: [
                                          Text("Grapes Black",style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600
                                          ),),

                                        Text("1kg",style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500
                                        ),)
                                      ],),
                                    ),

                                    Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(border: Border.all(color: MyTheme.light_grey),
                                            borderRadius: BorderRadius.circular(20),),
                                            child: Padding(
                                              padding: const EdgeInsets.only(top: 4.0,left: 8,right: 8,bottom: 4),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                children: [
                                                  Text(" Size ",style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.w500
                                                  ),),
                                                  SizedBox(width: 5,),
                                                  Image.asset("assets/dropicon.png",
                                                  scale: 3,),
                                                ],
                                              ),
                                            ),
                                          ),

                                          Text("Rs 10/kg",style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600
                                          ),)
                                        ],),
                                    ),

                                    Padding(
                                      padding: const EdgeInsets.only(right: 16.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          SizedBox(),
                                          Padding(
                                            padding: const EdgeInsets.all(4.0),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                               CircleAvatar(
                                                 backgroundColor: MyTheme.primary_color,
                                                 radius:15,
                                                 child: Icon(Icons.remove,
                                                 size: 20,),
                                               ),

                                                SizedBox(width: 10,),
                                                Text("5",style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600
                                                ),),

                                                SizedBox(width: 10,),

                                                CircleAvatar(
                                                  backgroundColor: MyTheme.primary_color,
                                                  radius:15,
                                                  child: Icon(Icons.add,
                                                    size: 20,),
                                                ),
                                              ],),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),),
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
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> ProductPost()));
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

