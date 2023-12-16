// translation done.

import 'package:active_ecommerce_flutter/drawer/drawer.dart';
import 'package:active_ecommerce_flutter/features/sellAndBuy/screens/buy_product_list.dart';
import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:active_ecommerce_flutter/features/sellAndBuy/screens/product_inventory.dart';
import 'package:active_ecommerce_flutter/utils/enums.dart' as enums;
import 'package:active_ecommerce_flutter/utils/imageLinks.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ParentScreen extends StatefulWidget {
  final enums.ParentEnum parentEnum;
  final bool isBuy;
  final bool isSecondHand;
  const ParentScreen({
    required this.parentEnum,
    this.isBuy = false,
    this.isSecondHand = false,
  });

  @override
  State<ParentScreen> createState() => _ParentScreenState();
}

class _ParentScreenState extends State<ParentScreen> {
  bool isSwitched = false;
  late Future<int> totalFarmersCountFuture;

  var categoryListForParentEnum = enums.categoryListForParentEnum;
  var nameForParentEnum = enums.nameForParentEnum;
  var nameForCategoryEnum = enums.nameForCategoryEnum;
  var subCategoryListsForCategory = enums.subCategoryListsForCategory;
  var nameForSubCategoryEnum = enums.nameForSubCategoryEnum;

  var imageForName = imageForNameCloud;

  Future<int> getTotalFarmersCount({required String parentName}) async {
    CollectionReference sellersCollection =
        FirebaseFirestore.instance.collection('seller');

    QuerySnapshot querySnapshot = await sellersCollection
        .where('productParentNames', arrayContains: parentName)
        .get();

    return querySnapshot.size;
  }

  @override
  void initState() {
    // TODO: implement initState
    totalFarmersCountFuture =
        getTotalFarmersCount(parentName: nameForParentEnum[widget.parentEnum]!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: categoryListForParentEnum[widget.parentEnum]!.length,
      child: Scaffold(
        // key: homeData.scaffoldKey,
        drawer: const MainDrawer(),
        // appBar: buildCustomAppBar(context),
        appBar: AppBar(
          // backgroundColor: MyTheme.primary_color,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xff107B28), Color(0xff4C7B10)]),
            ),
          ),
          title: Text(nameForParentEnum[widget.parentEnum]!,
              style: TextStyle(
                  color: MyTheme.white,
                  fontWeight: FontWeight.w500,
                  letterSpacing: .5,
                  fontFamily: 'Poppins')),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.keyboard_arrow_left,
                size: 35,
                color: MyTheme.white,
              ),
            ),
            SizedBox(
              width: 10,
            ),
          ],
        ),
        body: bodycontent(),
      ),
    );
  }

  bodycontent() {
    return Column(
      children: [
        //top bar section
        Container(
          height: 80,
          width: double.infinity,
          color: Colors.blueGrey.shade50,
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: FutureBuilder(
              future: totalFarmersCountFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: LinearProgressIndicator());
                }
                if (snapshot.hasData && snapshot.data != null) {
                  return Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      Container(
                        // height: 40,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              snapshot.data.toString(),
                              style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                  color: Colors.black),
                            ),
                            Text(
                              AppLocalizations.of(context)!.farmer,
                              style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                  color: Colors.black),
                            )
                          ],
                        ),
                      ),
                    ],
                  );
                }
                return Container();
              }),
        ),

        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Container(
              height: 45,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
                border: Border.all(
                  color: MyTheme.field_color,
                ),
              ),
              child: TabBar(
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                  color: Color(0xff4C7B10),
                ),
                labelColor: Colors.white,
                unselectedLabelColor: Colors.black,
                isScrollable:
                    categoryListForParentEnum[widget.parentEnum]!.length > 3
                        ? true
                        : false,
                tabs: List.generate(
                  categoryListForParentEnum[widget.parentEnum]!.length,
                  (index) {
                    var item =
                        categoryListForParentEnum[widget.parentEnum]![index];
                    return Tab(
                      child: Text(
                        nameForCategoryEnum[item]!,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          // color: Colors.black,
                        ),
                      ),
                    );
                  },
                ).toList(),
              ),
            ),
          ),
        ),

        Expanded(
          child: TabBarView(
            physics: BouncingScrollPhysics(),
            children: List.generate(
              categoryListForParentEnum[widget.parentEnum]!.length,
              (index) {
                var categoryEnum =
                    categoryListForParentEnum[widget.parentEnum]![index];
                return SingleChildScrollView(
                    // controller: _xcrollController,
                    physics: const BouncingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics()),
                    child: MasonryGridView.count(
                      crossAxisCount: 3,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      itemCount:
                          subCategoryListsForCategory[categoryEnum]!.length,
                      shrinkWrap: true,
                      padding: EdgeInsets.only(top: 10.0, left: 18, right: 18),
                      physics: NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      itemBuilder: (context, index) {
                        enums.SubCategoryEnum subCategoryEnum =
                            subCategoryListsForCategory[categoryEnum]![index];
                        return InkWell(
                          onTap: () {
                            widget.isBuy
                                ? Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => BuyProductList(
                                              subCategoryEnum: subCategoryEnum,
                                              isSecondHand: widget.isSecondHand,
                                            )),
                                  )
                                : Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ProductInventory(
                                              subCategoryEnum: subCategoryEnum,
                                              isSecondHand: widget.isSecondHand,
                                            )));
                          },
                          child: Container(
                            height: 120,
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color: MyTheme.field_color,
                              ),
                            ),
                            child: Column(
                              children: [
                                Expanded(
                                  child: Container(
                                    margin: const EdgeInsets.all(5),
                                    child: AspectRatio(
                                      aspectRatio: 1,
                                      child: CachedNetworkImage(
                                        imageUrl: imageForName[
                                                nameForSubCategoryEnum[
                                                        subCategoryEnum]!
                                                    .toLowerCase()] ??
                                            imageForName['placeholder']!,
                                        imageBuilder:
                                            (context, imageProvider) =>
                                                Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            image: DecorationImage(
                                              image: imageProvider,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        placeholder: (context, url) => Center(
                                            child: CircularProgressIndicator()),
                                        errorWidget: (context, url, error) =>
                                            Icon(Icons.error),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                FittedBox(
                                  child: Text(
                                    nameForSubCategoryEnum[subCategoryEnum]!,
                                    style: TextStyle(
                                      // fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    ));
              },
            ).toList(),
          ),
        ),
      ],
    );
  }
}
