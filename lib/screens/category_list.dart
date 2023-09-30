import 'package:active_ecommerce_flutter/custom/box_decorations.dart';
import 'package:active_ecommerce_flutter/custom/btn.dart';
import 'package:active_ecommerce_flutter/custom/device_info.dart';
import 'package:active_ecommerce_flutter/custom/useful_elements.dart';
import 'package:active_ecommerce_flutter/data_model/category_response.dart';
import 'package:active_ecommerce_flutter/helpers/shimmer_helper.dart';
import 'package:active_ecommerce_flutter/presenter/bottom_appbar_index.dart';
import 'package:active_ecommerce_flutter/screens/calender/calender.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:active_ecommerce_flutter/drawer/drawer.dart';
import 'package:active_ecommerce_flutter/custom/toast_component.dart';
import 'package:hexagon/hexagon.dart';
import 'package:toast/toast.dart';
import 'package:active_ecommerce_flutter/screens/category_products.dart';
import 'package:active_ecommerce_flutter/repositories/category_repository.dart';
import 'package:shimmer/shimmer.dart';
import 'package:active_ecommerce_flutter/app_config.dart';
import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../controller/sub_category_controller.dart';
import '../presenter/home_presenter.dart';
import 'category/sub_category.dart';
import 'home_widget/buy_sell_button_widget.dart';
import 'home_widget/hexagonal_widget.dart';
import '../features/profile/title_bar_widget.dart';
import 'package:get/get.dart';

class CategoryList extends StatefulWidget {
  CategoryList({
    Key? key,
    this.parent_category_id = 0,
    this.parent_category_name = "",
    this.is_base_category = false,
    this.is_top_category = false,
    this.bottomAppbarIndex,
  }) : super(key: key);

  final int parent_category_id;
  final String parent_category_name;
  final bool is_base_category;
  final bool is_top_category;
  final BottomAppbarIndex? bottomAppbarIndex;

  @override
  _CategoryListState createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  SubCategoryController subCategoryCon = Get.put(SubCategoryController());
  HomePresenter homeData = HomePresenter();

  String color = "buy";
  bool isvalue = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection:
          app_language_rtl.$! ? TextDirection.rtl : TextDirection.ltr,
      child: Stack(children: [
        /*  Container(
          height: DeviceInfo(context).height! / 4,
          width: DeviceInfo(context).width,
          color: MyTheme.accent_color,
          alignment: Alignment.topRight,
          child: Image.asset(
            "assets/background_1.png",
          ),
        ),*/
        Scaffold(
            key: homeData.scaffoldKey,
            drawer: const MainDrawer(),
            backgroundColor: Colors.transparent,
            appBar: PreferredSize(
                child: buildAppBar(context),
                preferredSize: Size(
                  DeviceInfo(context).width!,
                  50,
                )),
            body: buildBody()),
        Align(
          alignment: Alignment.bottomCenter,
          child: widget.is_base_category || widget.is_top_category
              ? Container(
                  height: 0,
                )
              : buildBottomContainer(),
        )
      ]),
    );
  }

  Widget buildBody() {
    return CustomScrollView(
      physics: AlwaysScrollableScrollPhysics(),
      slivers: [
        SliverList(
            delegate: SliverChildListDelegate([
          TitleBar(),

          SizedBox(height: 24),

          //Buy Sell Button Design

          Center(
            child: Stack(
              children: [
                Container(
                  height: 44,
                  width: 162,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: MyTheme.light_grey,
                      border: Border.all(color: MyTheme.light_grey)),
                  child: Center(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(),
                      InkWell(
                        onTap: () {
                          setState(() {
                            color = "sell";
                            isvalue = false;
                            CategoryList();
                          });
                          //  Navigator.push(context, MaterialPageRoute(builder: (context)=> ProductInventory() ));
                        },
                        child: Container(
                          height: 44,
                          width: 77,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: color == "sell"
                                  ? MyTheme.primary_color
                                  : MyTheme.light_grey),
                          child: Center(
                            child: Text(
                              "SELL",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: color == "sell"
                                    ? MyTheme.white
                                    : Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )),
                ),
                Positioned(
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        color = "buy";
                        isvalue = true;
                      });
                    },
                    child: Container(
                      height: 44,
                      width: 77,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: color == "buy"
                              ? MyTheme.primary_color
                              : MyTheme.light_grey),
                      child: Center(
                        child: Text(
                          "BUY",
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color:
                                color == "buy" ? MyTheme.white : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),

          // buy sell button design closed

          SizedBox(height: 24),

          // Category hexagonal widget design start
          buildCategoryList(),

          //  SizedBox(height:16),

          // Calender widget design start
          Column(
            children: [
              Stack(
                children: [
                  HexagonWidget.flat(
                    width: 122,
                    cornerRadius: 15,
                    color: Colors.black,
                    elevation: 3,
                  ),
                  Positioned(
                    top: 1,
                    left: 1,
                    right: 1,
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Calender()));
                      },
                      child: HexagonWidget.flat(
                          width: 120,
                          cornerRadius: 15,
                          color: MyTheme.field_color,
                          elevation: 3,
                          child: Image.asset('assets/calender.png')),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 5),
              Text(
                "Calender",
                style: TextStyle(
                    fontWeight: FontWeight.w600, fontFamily: 'Poppins'),
              ),
            ],
          ),

          Container(
            height: widget.is_base_category ? 90 : 90,
          ),
        ]))
      ],
    );
  }

  // appbar design
  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      // backgroundColor: Colors.transparent,
      //centerTitle: true,
      // leading: widget.is_base_category
      //     ? Builder(
      //       builder: (context) => Padding(
      //         padding: const EdgeInsets.symmetric(
      //             vertical: 0.0, horizontal: 0.0),
      //         child: UsefulElements.backToMain(context, go_back: false,color: "white"),
      //       ),
      //     )
      //     : Builder(
      //         builder: (context) => IconButton(
      //           icon: Icon(CupertinoIcons.arrow_left, color: MyTheme.white),
      //           onPressed: () => Navigator.of(context).pop(),
      //         ),
      //       ),
      leading: IconButton(
          onPressed: () {
            homeData.scaffoldKey.currentState?.openDrawer();
          },
          icon: Icon(Icons.menu)),
      title: Text(
        getAppBarTitle(),
        style: TextStyle(
            fontSize: 16, color: MyTheme.white, fontWeight: FontWeight.bold),
      ),
      centerTitle: true,
      flexibleSpace: Container(
        height: 110,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xff107B28), Color(0xff4C7B10)])),
      ),
      elevation: 0.0,
      titleSpacing: 0,
    );
  }

  String getAppBarTitle() {
    String name = widget.parent_category_name == ""
        ? (widget.is_top_category
            ? AppLocalizations.of(context)!.top_categories_ucf
            : AppLocalizations.of(context)!.home_ucf)
        : widget.parent_category_name;

    return name;
  }

  buildCategoryList() {
    var data = widget.is_top_category
        ? CategoryRepository().getTopCategories()
        : CategoryRepository()
            .getCategories(parent_id: widget.parent_category_id);
    return FutureBuilder(
        future: data,
        builder: (context, AsyncSnapshot<CategoryResponse> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return SingleChildScrollView(child: buildShimmer());
          }
          if (snapshot.hasError) {
            //snapshot.hasError
            print("category list error");
            print(snapshot.error.toString());
            return Container(
              height: 10,
            );
          } else if (snapshot.hasData) {
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                mainAxisSpacing: 10,
                crossAxisSpacing: 20,
                childAspectRatio: 1.15,
                crossAxisCount: 2,
              ),
              itemCount: snapshot.data!.categories!.length,
              padding: EdgeInsets.only(
                  left: 18,
                  right: 18,
                  bottom: widget.is_base_category ? 30 : 0),
              scrollDirection: Axis.vertical,
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return buildCategoryItemCard(snapshot.data, index, isvalue);
              },
            );
          } else {
            return SingleChildScrollView(child: buildShimmer()
                /*
              ListView.builder(
                itemCount: 10,
                scrollDirection: Axis.vertical,
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(
                        top: 4.0, bottom: 4.0, left: 16.0, right: 16.0),
                    child: Row(
                      children: [
                        Shimmer.fromColors(
                          baseColor: MyTheme.shimmer_base,
                          highlightColor: MyTheme.shimmer_highlighted,
                          child: Container(
                            height: 60,
                            width: 60,
                            color: Colors.white,
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 16.0, bottom: 8.0),
                              child: Shimmer.fromColors(
                                baseColor: MyTheme.shimmer_base,
                                highlightColor: MyTheme.shimmer_highlighted,
                                child: Container(
                                  height: 20,
                                  width: MediaQuery.of(context).size.width * .7,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 16.0),
                              child: Shimmer.fromColors(
                                baseColor: MyTheme.shimmer_base,
                                highlightColor: MyTheme.shimmer_highlighted,
                                child: Container(
                                  height: 20,
                                  width: MediaQuery.of(context).size.width * .5,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),*/
                );
          }
        });
  }

  Widget buildCategoryItemCard(categoryResponse, index, isvalue) {
    var itemWidth = ((DeviceInfo(context).width! - 31) / 2);
    print(itemWidth);

    return Container(
      // decoration: BoxDecorations.buildBoxDecoration_1(),
      child: InkWell(
        onTap: () {
          subCategoryCon.GetSubCategory(categoryResponse.categories[index].id);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return SubCategory(
                  category_id: categoryResponse.categories[index].id,
                  category_name: categoryResponse.categories[index].name,
                  isvalue: isvalue,
                ); /* CategoryProducts(
                  category_id: categoryResponse.categories[index].id,
                  category_name: categoryResponse.categories[index].name,
                  isvalue: isvalue,
                );*/
              },
            ),
          );
        },
        child: Container(
          //padding: EdgeInsets.all(8),
          //color: Colors.amber,
          child: Column(
            children: [
              Stack(
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 5, top: 5),
                    child: HexagonWidget.flat(
                      color: Colors.black,
                      cornerRadius: 15,
                      width: 122,
                      inBounds: true,
                      elevation: 3,
                      child: AspectRatio(
                        aspectRatio: HexagonType.FLAT.ratio,
                        child: Padding(
                          padding: EdgeInsets.all(18.0),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 1,
                    left: 1,
                    right: 1,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 5, top: 5),
                      child: HexagonWidget.flat(
                        color: MyTheme.field_color,
                        cornerRadius: 15,
                        width: 120,
                        inBounds: true,
                        elevation: 3,
                        child: AspectRatio(
                          aspectRatio: HexagonType.FLAT.ratio,
                          child: Padding(
                            padding: EdgeInsets.all(18.0),
                            child: index == 0
                                ? Image.asset(
                                    "assets/animal.png",
                                    fit: BoxFit.fitHeight,
                                  )
                                : index == 1
                                    ? Image.asset(
                                        "assets/Frame6.png",
                                        fit: BoxFit.fitHeight,
                                      )
                                    : index == 2
                                        ? Image.asset(
                                            "assets/machine.png",
                                            fit: BoxFit.fitHeight,
                                          )
                                        : index == 3
                                            ? Image.asset(
                                                "assets/village.png",
                                                fit: BoxFit.fitHeight,
                                              )
                                            : Image.asset(
                                                "assets/calender.png",
                                                fit: BoxFit.fitHeight,
                                              ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Text(
                "${categoryResponse.categories[index].name}",
                style: TextStyle(
                    fontWeight: FontWeight.w600, fontFamily: 'Poppins'),
              )
            ],
          ),
          /*Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                constraints: BoxConstraints(maxHeight: itemWidth-28),
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(6), topLeft: Radius.circular(6)),
                  child: FadeInImage.assetNetwork(
                    placeholder: 'assets/placeholder.png',
                    image: categoryResponse.categories[index].banner,
                    fit: BoxFit.cover,
                    height: itemWidth,
                    width: DeviceInfo(context).width,
                  ),
                ),
              ),
              Container(
                height: 60,
                //color: Colors.amber,
                alignment: Alignment.center,
                width: DeviceInfo(context).width,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Text(
                  categoryResponse.categories[index].name,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: TextStyle(
                      color: MyTheme.font_grey,
                      fontSize: 10,
                      height: 1.6,
                      fontWeight: FontWeight.w600),

                ),
              ),
              Spacer()
              */ /*Container(
                height: 80,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.max,
                  children: [

                    Padding(
                      padding: EdgeInsets.fromLTRB(32, 8, 8, 4),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              if (categoryResponse
                                      .categories[index].number_of_children >
                                  0) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return CategoryList(
                                        parent_category_id:
                                            categoryResponse.categories[index].id,
                                        parent_category_name:
                                            categoryResponse.categories[index].name,
                                      );
                                    },
                                  ),
                                );
                              } else {
                                ToastComponent.showDialog(
                                    AppLocalizations.of(context)
                                        .category_list_screen_no_subcategories,
                                    gravity: Toast.center,
                                    duration: Toast.lengthLong);
                              }
                            },
                            child: Text(
                              AppLocalizations.of(context)
                                  .category_list_screen_view_subcategories,
                              textAlign: TextAlign.left,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: TextStyle(
                                  color: categoryResponse.categories[index]
                                              .number_of_children >
                                          0
                                      ? MyTheme.medium_grey
                                      : MyTheme.light_grey,
                                  decoration: TextDecoration.underline),
                            ),
                          ),
                          Text(
                            " | ",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: MyTheme.medium_grey,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return CategoryProducts(
                                      category_id:
                                          categoryResponse.categories[index].id,
                                      category_name:
                                          categoryResponse.categories[index].name,
                                    );
                                  },
                                ),
                              );
                            },
                            child: Text(
                              AppLocalizations.of(context)
                                  .category_list_screen_view_products,
                              textAlign: TextAlign.left,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: TextStyle(
                                  color: MyTheme.medium_grey,
                                  decoration: TextDecoration.underline),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),*/ /*
            ],
          ),*/
        ),
      ),
    );
  }

  Container buildBottomContainer() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
      ),

      height: widget.is_base_category ? 0 : 80,
      //color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Container(
                width: (MediaQuery.of(context).size.width - 32),
                height: 40,
                child: Btn.basic(
                  minWidth: MediaQuery.of(context).size.width,
                  color: MyTheme.accent_color,
                  shape: RoundedRectangleBorder(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(8.0))),
                  child: Text(
                    AppLocalizations.of(context)!.all_products_of_ucf +
                        " " +
                        widget.parent_category_name,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w600),
                  ),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return CategoryProducts(
                        category_id: widget.parent_category_id,
                        category_name: widget.parent_category_name,
                      );
                    }));
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildShimmer() {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        mainAxisSpacing: 14,
        crossAxisSpacing: 14,
        childAspectRatio: 1,
        crossAxisCount: 3,
      ),
      itemCount: 18,
      padding: EdgeInsets.only(
          left: 18, right: 18, bottom: widget.is_base_category ? 30 : 0),
      scrollDirection: Axis.vertical,
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecorations.buildBoxDecoration_1(),
          child: ShimmerHelper().buildBasicShimmer(),
        );
      },
    );
  }
}
