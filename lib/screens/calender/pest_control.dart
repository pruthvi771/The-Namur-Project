import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../custom/device_info.dart';
import '../../data_model/calender/pests_control_model.dart';
import '../../my_theme.dart';
import '../../presenter/home_presenter.dart';

class PestControl extends StatefulWidget {
  const PestControl({Key? key}) : super(key: key);

  @override
  State<PestControl> createState() => _PestControlState();
}

class _PestControlState extends State<PestControl> {
  List<PlantingStage> plantinstagelist = [
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

  var colordata = 1;

  value() {
    var i = 1;
    do {
      colordata = 1;
      i++;
    } while (i < 40);
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
                SizedBox(
                  width: 30,
                ),
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
                  child: Text(AppLocalizations.of(context)!.pests_diseases_ucf,
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
        ListView(children: [
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
                        itemBuilder: (context, index) {
                          return Row(
                            children: [
                              Container(
                                height: 60,
                                width: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border:
                                      Border.all(color: MyTheme.primary_color),
                                ),
                                child: Image.asset(
                                    "${plantinstagelist.elementAt(index).image}"),
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

          // Planting Stage
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20),
            child: Container(
              height: 30,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(color: Color(0xffA4CD3C)),
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 8),
                child: Text(
                  "1.Planting Stage",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    decoration: BoxDecoration(),
                    child: Column(
                      children: [
                        Image.asset("assets/swirling.png"),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(
                            "Swirling Virus",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(),
                    child: Column(
                      children: [
                        Image.asset("assets/caterpiller.png"),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(
                            "Caterpiller ",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(),
                    child: Column(
                      children: [
                        Container(
                            height: 70,
                            child: Image.asset(
                              "assets/mosquoto.png",
                              fit: BoxFit.fill,
                            )),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(
                            "Mosquito",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),

          // Sapling Stage
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20),
            child: Container(
              height: 30,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(color: Color(0xffD12828)),
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 8),
                child: Text(
                  "1.Sapling Stage",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    decoration: BoxDecoration(),
                    child: Column(
                      children: [
                        Container(
                            height: 70,
                            child: Image.asset(
                              "assets/blackbugs.png",
                              fit: BoxFit.fill,
                            )),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(
                            "Black Bugs",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(),
                    child: Column(
                      children: [
                        Container(
                            height: 70,
                            child: Image.asset(
                              "assets/bugs.png",
                              fit: BoxFit.fill,
                            )),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(
                            "Bugs",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(),
                    child: Column(
                      children: [
                        Container(
                            height: 70,
                            child: Image.asset(
                              "assets/gonne.png",
                              fit: BoxFit.fill,
                            )),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(
                            "Gonne Hula",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),

          // Flowering Stage
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20),
            child: Container(
              height: 30,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(color: Color(0xff9747FF)),
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 8),
                child: Text(
                  "1.Flowering Stage",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    decoration: BoxDecoration(),
                    child: Column(
                      children: [
                        Container(
                            height: 70,
                            child: Image.asset(
                              "assets/termites.png",
                              fit: BoxFit.fill,
                            )),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(
                            "Termites",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(),
                    child: Column(
                      children: [
                        Container(
                            height: 70,
                            child: Image.asset(
                              "assets/blackbugs1.png",
                              fit: BoxFit.fill,
                            )),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(
                            "Black Bugs",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(),
                    child: Column(
                      children: [
                        Container(
                            height: 70,
                            child: Image.asset(
                              "assets/bees.png",
                              fit: BoxFit.fill,
                            )),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(
                            "Bees",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),

          // Havesting Stage
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20),
            child: Container(
              height: 30,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(color: Color(0xff47E3D7)),
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 8),
                child: Text(
                  "1.Harvesting Stage",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    decoration: BoxDecoration(),
                    child: Column(
                      children: [
                        Container(
                            height: 70,
                            child: Image.asset(
                              "assets/peacocks.png",
                              fit: BoxFit.fill,
                            )),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(
                            "Peacocks",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(),
                    child: Column(
                      children: [
                        Container(
                            height: 70,
                            child: Image.asset(
                              "assets/wildboars.png",
                              fit: BoxFit.fill,
                            )),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(
                            "Wildboars",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(),
                    child: Column(
                      children: [
                        Container(
                            height: 70,
                            child: Image.asset(
                              "assets/rodents.png",
                              fit: BoxFit.fill,
                            )),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(
                            "Rodents",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ])
      ],
    );
  }
}
