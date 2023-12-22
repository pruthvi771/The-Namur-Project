import 'package:active_ecommerce_flutter/custom/device_info.dart';
import 'package:active_ecommerce_flutter/custom/useful_elements.dart';
import 'package:active_ecommerce_flutter/data_model/category_response.dart';
import 'package:active_ecommerce_flutter/helpers/shimmer_helper.dart';
import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:active_ecommerce_flutter/repositories/category_repository.dart';
import 'package:active_ecommerce_flutter/repositories/product_repository.dart';
import 'package:active_ecommerce_flutter/ui_elements/product_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../presenter/home_presenter.dart';
import '../drawer/drawer.dart';
import 'category/sub_category.dart';

class CategoryProducts extends StatefulWidget {
  CategoryProducts(
      {Key? key, this.category_name, this.category_id, this.isvalue})
      : super(key: key);
  final String? category_name;
  final int? category_id;
  var _index = 0;
  bool? isvalue;

  @override
  _CategoryProductsState createState() => _CategoryProductsState();
}

class _CategoryProductsState extends State<CategoryProducts> {
  HomePresenter homeData = HomePresenter();
  ScrollController _scrollController = ScrollController();
  ScrollController _xcrollController = ScrollController();
  TextEditingController _searchController = TextEditingController();

  List<dynamic> _productList = [];
  List<Category> _subCategoryList = [];
  bool _isInitial = true;
  int _page = 1;
  String _searchKey = "";
  int? _totalData = 0;
  bool _showLoadingContainer = false;
  bool _showSearchBar = false;

  getSubCategory() async {
    var res =
        await CategoryRepository().getCategories(parent_id: widget.category_id);
    _subCategoryList.addAll(res.categories!);
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchAllDate();

    _xcrollController.addListener(() {
      //print("position: " + _xcrollController.position.pixels.toString());
      //print("max: " + _xcrollController.position.maxScrollExtent.toString());

      if (_xcrollController.position.pixels ==
          _xcrollController.position.maxScrollExtent) {
        setState(() {
          _page++;
        });
        _showLoadingContainer = true;
        fetchData();
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _scrollController.dispose();
    _xcrollController.dispose();
    super.dispose();
  }

  fetchData() async {
    var productResponse = await ProductRepository().getCategoryProducts(
        id: widget.category_id, page: _page, name: _searchKey);
    _productList.addAll(productResponse.products!);
    _isInitial = false;
    _totalData = productResponse.meta!.total;
    _showLoadingContainer = false;
    setState(() {});
  }

  fetchAllDate() {
    fetchData();
    getSubCategory();
  }

  reset() {
    _subCategoryList.clear();
    _productList.clear();
    _isInitial = true;
    _totalData = 0;
    _page = 1;
    _showLoadingContainer = false;
    setState(() {});
  }

  Future<void> _onRefresh() async {
    reset();
    fetchAllDate();
  }

  var _index = 0;
  var id;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: homeData.scaffoldKey,
        drawer: const MainDrawer(),
        backgroundColor: Colors.white,
        appBar: buildAppBar(context),
        body: Column(
          children: [
            Container(
                height: 100,
                width: MediaQuery.of(context).size.width,
                color: MyTheme.light_grey,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        height: 25,
                      ),
                      SizedBox(
                        height: 50,
                        child: CircleAvatarwidget(),
                      ),
                      SizedBox(
                        height: 25,
                      )
                    ])),

            SizedBox(height: 16),

            // Sub category
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20),
              child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: MyTheme.titlebar_color),
                      borderRadius: BorderRadius.circular(15)),
                  height: 44,
                  child: ListView.separated(
                      padding: EdgeInsets.only(
                        left: 18,
                        right: 18,
                      ),
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            setState(() {
                              _index = index;
                              var id = "${_subCategoryList[index].id}";
                              // buildProductList();

                              SubCategory(
                                category_id: _subCategoryList[index].id,
                                //category_name: _subCategoryList[index].name,
                              );
                            });
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return CategoryProducts(
                                    category_id: _subCategoryList[index].id,
                                    category_name: _subCategoryList[index].name,
                                  );
                                },
                              ),
                            );
                          },
                          child: Container(
                            height: 44,
                            width: 90,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: _index == index
                                    ? MyTheme.primary_color
                                    : Colors.white),
                            alignment: Alignment.center,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "${_subCategoryList[index].name!}",
                                style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: _index == index
                                        ? Colors.white
                                        : MyTheme.font_grey,
                                    fontFamily: 'Poppins'),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (context, index) {
                        return SizedBox(
                          width: 10,
                        );
                      },
                      itemCount: _subCategoryList.length)
                  // !_isInitial ? buildSubCategory() : buildSubCategory(),
                  ),
            ),

            buildProductList(),

            // category name
            // Column(
            //   children: [
            //     Stack(
            //       children: [
            //         Padding(
            //           padding: const EdgeInsets.only(left: 20.0,right: 20),
            //           child: Container(
            //             decoration: BoxDecoration(border: Border.all(
            //                 color: MyTheme.titlebar_color
            //             ),borderRadius: BorderRadius.circular(15)),
            //             height:44,
            //             child:  ListView.separated(
            //                 padding: EdgeInsets.only(left: 18, right: 18, ),
            //                 scrollDirection: Axis.horizontal,
            //                 itemBuilder: (context, index) {
            //                   return InkWell(
            //                     onTap: () {
            //                       setState(() {
            //                         _index = index;
            //                         buildProductList();
            //                         // SubCategory(
            //                         //   category_id: _subCategoryList[index].id,
            //                         //   //category_name: _subCategoryList[index].name,
            //                         // );
            //                       });
            //                       Navigator.push(
            //                         context,
            //                         MaterialPageRoute(
            //                           builder: (context) {
            //                             return CategoryProducts(
            //                               category_id: _subCategoryList[index].id,
            //                               category_name: _subCategoryList[index].name,
            //                             );
            //                           },
            //                         ),
            //                       );
            //                     },
            //                     child: Container(
            //                       height:  44,
            //                       //   width: _subCategoryList.isEmpty ? 0 : 70,
            //                       decoration: BoxDecoration(borderRadius: BorderRadius.circular(15),
            //                           color: _index == index? MyTheme.primary_color:Colors.red),
            //                       alignment: Alignment.center,
            //
            //                       child: Padding(
            //                         padding: const EdgeInsets.all(8.0),
            //                         child: Text(
            //                          "${ _subCategoryList[index].name!}",
            //                           style: TextStyle(
            //                               fontSize: 13,
            //                               fontWeight: FontWeight.w600,
            //                               color: _index == index? Colors.white:MyTheme.font_grey,
            //                               fontFamily: 'Poppins'),
            //                           textAlign: TextAlign.center,
            //                         ),
            //                       ),
            //                     ),
            //                   );
            //                 },
            //                 separatorBuilder: (context, index) {
            //                   return SizedBox(
            //                     width: 10,
            //                   );
            //                 },
            //                 itemCount: _subCategoryList.length)
            //             // !_isInitial ? buildSubCategory() : buildSubCategory(),
            //           ),
            //         ),
            //       ],
            //     ),
            //
            //     buildProductList()
            //      //  SubCategory(
            //      // //category_name: _subCategoryList[index].name,
            //      //   ),
            //   ],
            // ),

            Align(
                alignment: Alignment.bottomCenter,
                child: buildLoadingContainer())
          ],
        ));
  }

  Container buildLoadingContainer() {
    return Container(
      height: _showLoadingContainer ? 36 : 0,
      width: double.infinity,
      color: Colors.white,
      child: Center(
        child: Text(_totalData == _productList.length
            ? AppLocalizations.of(context)!.no_more_products_ucf
            : AppLocalizations.of(context)!.loading_more_products_ucf),
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      leading: IconButton(
          onPressed: () {
            homeData.scaffoldKey.currentState?.openDrawer();
          },
          icon: Icon(Icons.menu)),
      toolbarHeight: _subCategoryList.isEmpty
          ? DeviceInfo(context).height! / 12
          : DeviceInfo(context).height! / 12,
      flexibleSpace: Container(
          height: DeviceInfo(context).height! / 4,
          width: DeviceInfo(context).width,
          // color: MyTheme.primary_color,
          alignment: Alignment.topRight,

          /*child: Image.asset(
          "assets/background_1.png",
        ),
*/
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xff107B28), Color(0xff4C7B10)]))),

      //bottom appbar
      /* bottom: PreferredSize(
          child: AnimatedContainer(
            height: _subCategoryList.isEmpty ? 0 : 60,
            duration: Duration(milliseconds: 500),
           child: !_isInitial ? buildSubCategory() : buildSubCategory(),
          ),
          preferredSize: Size.fromHeight(0.0)),*/

      /*leading: Builder(
        builder: (context) => IconButton(
          icon: Icon(CupertinoIcons.arrow_left, color: MyTheme.dark_grey),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),*/
      title: buildAppBarTitle(context),
      centerTitle: true,
      elevation: 0.0,
      titleSpacing: 0,
      /*actions: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
          child: IconButton(
            icon: Icon(Icons.search, color: MyTheme.dark_grey),
            onPressed: () {
              _searchKey = _searchController.text.toString();
              reset();
              fetchData();
            },
          ),
        ),
      ],*/
    );
  }

  Widget buildAppBarTitle(BuildContext context) {
    return AnimatedCrossFade(
        firstChild: buildAppBarTitleOption(context),
        secondChild: buildAppBarSearchOption(context),
        firstCurve: Curves.fastOutSlowIn,
        secondCurve: Curves.fastOutSlowIn,
        crossFadeState: _showSearchBar
            ? CrossFadeState.showSecond
            : CrossFadeState.showFirst,
        duration: Duration(milliseconds: 500));
  }

  Container buildAppBarTitleOption(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 18),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: EdgeInsets.only(left: 50),
            width: DeviceInfo(context).width! / 2,
            child: Text(
              widget.category_name!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Poppins'),
            ),
          ),
          Spacer(),
          Container(
            width: 20,
            child: UsefulElements.backButton(context, color: "white"),
          ),
          /*  SizedBox(
            width: 20,
            child: IconButton(
                onPressed: () {
                  _showSearchBar = true;
                  setState(() {});
                },
                padding: EdgeInsets.zero,
                icon: Icon(
                  Icons.search,
                  size: 25,
                )),
          ),*/
        ],
      ),
    );
  }

  Container buildAppBarSearchOption(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 18),
      width: DeviceInfo(context).width,
      height: 40,
      child: TextField(
        controller: _searchController,
        onTap: () {},
        onChanged: (txt) {
          _searchKey = txt;
          reset();
          fetchData();
        },
        onSubmitted: (txt) {
          _searchKey = txt;
          reset();
          fetchData();
        },
        autofocus: false,
        decoration: InputDecoration(
          suffixIcon: IconButton(
            onPressed: () {
              _showSearchBar = false;
              setState(() {});
            },
            icon: Icon(
              Icons.clear,
              color: MyTheme.grey_153,
            ),
          ),
          filled: true,
          fillColor: MyTheme.white.withOpacity(0.6),
          hintText: "${AppLocalizations.of(context)!.search_products_from} : " +
              widget.category_name!,
          hintStyle: TextStyle(fontSize: 14.0, color: MyTheme.font_grey),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: MyTheme.noColor, width: 0.0),
              borderRadius: BorderRadius.circular(6)),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: MyTheme.noColor, width: 0.0),
              borderRadius: BorderRadius.circular(6)),
          contentPadding: EdgeInsets.all(8.0),
        ),
      ),
    );
  }

  ListView buildSubCategory() {
    var _index = 0;
    return ListView.separated(
        padding: EdgeInsets.only(
          left: 18,
          right: 18,
        ),
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              setState(() {
                _index = index;
                buildProductList();
                // SubCategory(
                //   category_id: _subCategoryList[index].id,
                //   //category_name: _subCategoryList[index].name,
                // );
              });
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return CategoryProducts(
                      category_id: _subCategoryList[index].id,
                      category_name: _subCategoryList[index].name,
                    );
                  },
                ),
              );
            },
            child: Container(
              height: _subCategoryList.isEmpty ? 0 : 44,
              //   width: _subCategoryList.isEmpty ? 0 : 70,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color:
                      _index == index ? MyTheme.primary_color : Colors.white),
              alignment: Alignment.center,

              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  _subCategoryList[index].name!,
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: _index == index ? Colors.white : MyTheme.font_grey,
                      fontFamily: 'Poppins'),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          );
        },
        separatorBuilder: (context, index) {
          return SizedBox(
            width: 10,
          );
        },
        itemCount: _subCategoryList.length);
  }

  buildProductList() {
    if (_isInitial && _productList.length == 0) {
      return SingleChildScrollView(
          child: ShimmerHelper()
              .buildProductGridShimmer(scontroller: _scrollController));
    } else if (_productList.length > 0) {
      return RefreshIndicator(
        color: MyTheme.accent_color,
        backgroundColor: Colors.white,
        displacement: 0,
        onRefresh: _onRefresh,
        child: SingleChildScrollView(
          controller: _xcrollController,
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          child: MasonryGridView.count(
            crossAxisCount: 3,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            itemCount: _productList.length,
            shrinkWrap: true,
            padding: EdgeInsets.only(top: 10.0, left: 18, right: 18),
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              // 3
              return ProductCard(
                id: _productList[index].id,
                image: _productList[index].thumbnail_image,
                name: _productList[index].name,
                main_price: _productList[index].main_price,
                stroked_price: _productList[index].stroked_price,
                discount: _productList[index].discount,
                is_wholesale: _productList[index].isWholesale,
                has_discount: _productList[index].has_discount,
                isvalue: widget.isvalue,
              );
            },
          ),
        ),
      );
    } else if (_totalData == 0) {
      return Center(
          child: Text(AppLocalizations.of(context)!.no_data_is_available));
    } else {
      return Container(); // should never be happening
    }
  }

  CircleAvatarwidget() {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Row(
        children: [
          SizedBox(
            height: 50,
            width: 130,
            child: Stack(
              children: [
                for (var i = 0; i < [1, 2, 3, 4].length; i++)
                  Positioned(
                    left: (i * (1 - .4) * 40).toDouble(),
                    top: 0,
                    child: CircleAvatar(
                      radius: 28,
                      backgroundColor: Colors.transparent,
                      // Set the background color to transparent
                      backgroundImage: AssetImage(
                          'assets/Ellipse2.png'), // Provide the asset image path
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(
            height: 40,
            child: RichText(
                text: TextSpan(children: [
              TextSpan(
                  text: '200+${_subCategoryList.length}',
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: Colors.black)),
              TextSpan(
                  text: '\nFarmer',
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: Colors.black))
            ])),
          )
        ],
      ),
    );
  }

  // category gridview design

/*  category_gridview(){
    if (_isInitial && _productList.length == 0) {
      return SingleChildScrollView(
          child: ShimmerHelper()
              .buildProductGridShimmer(scontroller: _scrollController));
    } else if (_productList.length > 0) {
      return RefreshIndicator(
        color: MyTheme.accent_color,
        backgroundColor: Colors.white,
        displacement: 0,
        onRefresh: _onRefresh,
        child: SingleChildScrollView(
          controller: _xcrollController,
         */ /* physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),*/ /*
          child: MasonryGridView.count(
            crossAxisCount: 3,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            itemCount:   21,//_productList.length,
            shrinkWrap: true,
            padding:
            EdgeInsets.only(top: 10.0, left: 18, right: 18),
            physics: NeverScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index) {
              // 3
              return  (
                child: Container(
                //  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: MyTheme.light_grey,
                  ),
                   child: Column(
                     children: [
                       Padding(
                         padding: const EdgeInsets.only(top: 8.0),
                         child: Container(
                           height: 50,
                           width: 50,
                           child: Image.asset("assets/animal.png",
                           fit: BoxFit.cover,),
                         ),
                       ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0,bottom: 8.0),
                          child: Text("Grapes",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500
                          ),),
                        )
                     ],
                   ),
                ),
              );

            },
          ),
        ),
      );
    } else if (_totalData == 0) {
      return Center(
          child: Text(AppLocalizations.of(context)!.no_data_is_available));
    } else {
      return Container(); // should never be happening
    }
  }
*/
}




/*  Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20),
              child: Container(
                height: 44,
                decoration: BoxDecoration(
                  border: Border.all(color: MyTheme.titlebar_color),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ListView.builder(
                    itemCount: _subCategoryList.length,
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return Container(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    _index = index;
                                    _categoryId = _subCategoryList[index].id!;
                                     name = _subCategoryList.elementAt(index).name!;
                                    fetchData();
                                    buildProductList();
                                  });

                                },
                                child: Container(
                                    height: 44,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        color: _index == index
                                            ? MyTheme.primary_color
                                            : Colors.white),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Center(
                                          child: Text(
                                        "${_subCategoryList.elementAt(index).name}",
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                            color: _index == index
                                                ? Colors.white
                                                : MyTheme.font_grey,
                                            fontFamily: 'Poppins'),
                                      )),
                                    )),
                              ),
                              SizedBox(
                                width: 15,
                              )
                            ],
                          ),
                        ),
                      );
                    }),
              ),
            ),*/

