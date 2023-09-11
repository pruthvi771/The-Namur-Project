import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../custom/device_info.dart';
import '../../data_model/calender/cultivation_tips_model.dart';
import '../../data_model/calender/pests_control_model.dart';
import '../../my_theme.dart';
import '../../presenter/home_presenter.dart';
import '../../ui_sections/drawer.dart';

class CultivationTips extends StatefulWidget {
  const CultivationTips({Key? key}) : super(key: key);

  @override
  State<CultivationTips> createState() => _CultivationTipsState();
}

class _CultivationTipsState extends State<CultivationTips> {

  List <PlantingStage> plantinstagelist = [
    PlantingStage(
      image: "assets/onion.png",
      title: "cxmvnxdlk,",
    ),
    PlantingStage(
      image: "assets/mango 1/.png",
      title: "cxmvnxdlk,",
    ),
    PlantingStage(
      image: "assets/coconut 1.png",
      title: "cxmvnxdlk,",
    ),
    PlantingStage(
      image: "assets/sunflower-oil 1.png",
      title: "cxmvnxdlk,",
    )
  ];

  List<CultivationTipsModel> cultivationtipslist = [
    CultivationTipsModel(
      image: "assets/grape (3).png",
      title: "Select Plant"
    ),
    CultivationTipsModel(
        image: "assets/grape (3).png",
        title: "Planting"
    ),
    CultivationTipsModel(
        image: "assets/grape (3).png",
        title: "Monitoring"
    ),
    CultivationTipsModel(
        image: "assets/grape (3).png",
        title: "Select Site"
    ),
    CultivationTipsModel(
        image: "assets/grape (3).png",
        title: "Weeding"
    ),
    CultivationTipsModel(
        image: "assets/grape (3).png",
        title: "Irrigation"
    ),
    CultivationTipsModel(
        image:"assets/grape (3).png",
        title: "Fertilization"
    ),
    CultivationTipsModel(
        image: "assets/grape (3).png",
        title: "Precautions"
    ),
    CultivationTipsModel(
        image: "assets/grape (3).png",
        title: "Protection"
    ),
    CultivationTipsModel(
        image: "assets/orange (1) (3).png",
        title: "Harvesting"
    ),
    CultivationTipsModel(
        image: "assets/grape (3).png",
        title: "Post Harvest"
    ),
  ];
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
                IconButton(
                  onPressed: () {
                    homeData.scaffoldKey.currentState?.openDrawer();
                  },
                  icon: Icon(
                    Icons.menu,
                    color: Colors.white,
                  ),
                ),
                Center(
                  child: Text(
                      AppLocalizations.of(context)!.cultivation_tips_ucf,
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
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: 50,
                      width: MediaQuery.of(context).size.width - 100,
                      child: ListView.builder(
                          itemCount: plantinstagelist.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: ( context,index) {
                            return Row(
                              children: [
                                Container(
                                  height: 60,
                                  width: 50,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                        color: MyTheme.primary_color),
                                  ),
                                  child: Image.asset("${plantinstagelist.elementAt(index).image}"),
                                ),
                                SizedBox(
                                  width: 15,
                                )
                              ],
                            );
                          }),
                    ),
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: AssetImage("assets/add 2.png"),
                    ),
                  ],
                ),
              ),
            ),

            //Gridview builder
            Container(
              height: MediaQuery.of(context).size.height,
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0,right: 20),
                child: GridView.builder(
                    itemCount: cultivationtipslist.length, // The number of items in the grid
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3, // Number of columns in the grid
                      crossAxisSpacing: 20.0, // Spacing between columns
                      mainAxisSpacing: 20.0, // Spacing between rows
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      // Builder function to create grid items

                      return Container(
                        decoration: BoxDecoration(
                          color:index == colordata? MyTheme.green_light:Colors.white,

                        borderRadius: BorderRadius.circular(15)),
                       
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                              height:70,
                                child: Image.asset("${cultivationtipslist.elementAt(index).image}",
                                fit: BoxFit.fill,)),

                            Center(
                              child: Padding(
                                padding: const EdgeInsets.only(),
                                child: Text(
                                  ' $index. ${cultivationtipslist.elementAt(index).title}',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 13.0,
                                    fontWeight: FontWeight.w600
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
              ),
            )
          ],
        ),
      ],
    );
  }
}
