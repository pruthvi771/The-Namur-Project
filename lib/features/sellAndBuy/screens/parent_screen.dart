import 'package:active_ecommerce_flutter/features/profile/address_list.dart';
import 'package:active_ecommerce_flutter/features/profile/screens/friends_screen.dart';
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
  final int initialIndexForTabBar;
  const ParentScreen({
    required this.parentEnum,
    this.isBuy = false,
    this.isSecondHand = false,
    this.initialIndexForTabBar = 0,
  });

  @override
  State<ParentScreen> createState() => _ParentScreenState();
}

class _ParentScreenState extends State<ParentScreen> {
  late bool? isSwitched;
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
    if (widget.parentEnum == enums.ParentEnum.machine) {
      isSwitched = false;
    } else {
      isSwitched = null;
    }
    totalFarmersCountFuture =
        getTotalFarmersCount(parentName: nameForParentEnum[widget.parentEnum]!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: widget.initialIndexForTabBar,
      length: categoryListForParentEnum[widget.parentEnum]!.length,
      child: Scaffold(
        appBar: AppBar(
          // backgroundColor: MyTheme.primary_color,
          automaticallyImplyLeading: false,
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
        InkWell(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return Friends();
            }));
          },
          child: Container(
            height: 80,
            width: double.infinity,
            color: Colors.blueGrey.shade50,
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: FutureBuilder(
                future: totalFarmersCountFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: LinearProgressIndicator());
                  }
                  if (snapshot.hasData && snapshot.data != null) {
                    return Container(
                      height: 80,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                CachedNetworkImage(
                                  imageUrl: imageForNameCloud['farmers']!,
                                  imageBuilder: (context, imageProvider) =>
                                      Container(
                                    margin: const EdgeInsets.only(right: 10),
                                    height: 50,
                                    width: 50,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  progressIndicatorBuilder:
                                      (context, url, progress) {
                                    return Container(
                                      height: 50,
                                      width: 50,
                                      child: Center(
                                          child: CircularProgressIndicator()),
                                    );
                                  },
                                ),
                                Flexible(
                                  child: Text(
                                    snapshot.data.toString() +
                                        ' ' +
                                        AppLocalizations.of(context)!.farmer,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15,
                                        color: Colors.black),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          isSwitched != null && widget.isBuy == true
                              ? Container(
                                  child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      AppLocalizations.of(context)!.rent,
                                      style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w600,
                                          fontSize: 15,
                                          color: Colors.black),
                                    ),
                                    Switch(
                                      value: isSwitched!,
                                      onChanged: (value) {
                                        setState(() {
                                          isSwitched = value;
                                        });
                                      },
                                      activeTrackColor: MyTheme.green_light,
                                      activeColor: MyTheme.primary_color,
                                    ),
                                    Text(
                                      AppLocalizations.of(context)!.buy,
                                      style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w600,
                                          fontSize: 15,
                                          color: Colors.black),
                                    ),
                                  ],
                                ))
                              : Container()
                        ],
                      ),
                    );
                  }
                  return Container();
                }),
          ),
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
                          fontSize: 12,
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
            children: List.generate(
              categoryListForParentEnum[widget.parentEnum]!.length,
              (index) {
                var categoryEnum =
                    categoryListForParentEnum[widget.parentEnum]![index];
                return SingleChildScrollView(
                    // controller: _xcrollController,
                    child: MasonryGridView.count(
                  crossAxisCount: 3,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  itemCount: subCategoryListsForCategory[categoryEnum]!.length,
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
                                    isMachine: (widget.parentEnum ==
                                        enums.ParentEnum.machine),
                                    subCategoryEnum: subCategoryEnum,
                                    isSecondHand: widget.isSecondHand,
                                    isRent: isSwitched == null
                                        ? null
                                        : !isSwitched!,
                                  ),
                                ),
                              )
                            : Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ProductInventory(
                                          isMachine: (widget.parentEnum ==
                                              enums.ParentEnum.machine),
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
                                    imageBuilder: (context, imageProvider) =>
                                        Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
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
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 2),
                              child: Text(
                                translatedName(
                                  name: nameForSubCategoryEnum[subCategoryEnum]!
                                      .toLowerCase(),
                                  context: context,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: TextStyle(
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
