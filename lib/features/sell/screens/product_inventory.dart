import 'package:active_ecommerce_flutter/features/sell/services/bloc/sell_bloc.dart';
import 'package:active_ecommerce_flutter/features/sell/services/bloc/sell_event.dart';
import 'package:active_ecommerce_flutter/features/sell/services/bloc/sell_state.dart';
import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:active_ecommerce_flutter/features/sell/screens/product_post.dart';
import 'package:active_ecommerce_flutter/utils/enums.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProductInventory extends StatefulWidget {
  final SubCategoryEnum subCategoryEnum;
  const ProductInventory({
    Key? key,
    required this.subCategoryEnum,
  }) : super(key: key);

  @override
  State<ProductInventory> createState() => _ProductInventoryState();
}

class _ProductInventoryState extends State<ProductInventory> {
  // HomePresenter homeData = HomePresenter();

  Future<void> _onPageRefresh() async {
    //reset();
    // fetchAll();
  }

  void initState() {
    super.initState();
    BlocProvider.of<SellBloc>(context).add(ProductsForSubCategoryRequested(
      subCategory: nameForSubCategoryEnum[widget.subCategoryEnum]!,
    ));
    // fetchAll();
  }

  Future<void> getProductsFromFirebase() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        // backgroundColor: MyTheme.primary_color,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xff107B28), Color(0xff4C7B10)]),
          ),
        ),
        title: Text(AppLocalizations.of(context)!.product_inventory_ucf,
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
      floatingActionButton: floatingActionButtomEnabled
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ProductPost(
                              subCategoryEnum: widget.subCategoryEnum,
                              alreadyExistingProductNames: productNames,
                            )));
              },
              child: Image.asset("assets/add 2.png"),
            )
          : SizedBox.shrink(),
    );
  }

  // RefreshIndicator buildBody() {
  //   return RefreshIndicator(
  //     color: MyTheme.white,
  //     backgroundColor: MyTheme.primary_color,
  //     onRefresh: _onPageRefresh,
  //     displacement: 10,
  //     child: bodycontent(),
  //   );
  // }

  late List<String> productNames;
  bool floatingActionButtomEnabled = false;

  bodycontent() {
    return BlocListener<SellBloc, SellState>(
      listener: (context, state) {
        if (state is ProductsForSubCategoryReceived) {
          productNames = [];
          for (var product in state.products) {
            productNames.add(product.productName);
          }
          setState(() {
            floatingActionButtomEnabled = true;
          });
        }
      },
      child: BlocBuilder<SellBloc, SellState>(
        builder: (context, state) {
          if (state is ProductsForSubCategoryReceived) {
            return state.products.isEmpty
                ? Center(
                    child: Text(
                      'No products found',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                  )
                : ListView(
                    physics: BouncingScrollPhysics(),
                    children: [
                      Container(
                        child: ListView.builder(
                            itemCount: state.products.length,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            itemBuilder: (context, index) {
                              var productName =
                                  state.products[index].productName;
                              var productSubSubCategory =
                                  state.products[index].subSubCategory;
                              return ProductInventoryWidget(
                                productName: productName,
                                productSubSubCategory: productSubSubCategory,
                                productPrice:
                                    state.products[index].productPrice,
                                productPriceType:
                                    state.products[index].priceType,
                                imageURL: state.products[index].imageURL,
                                productQuantity:
                                    state.products[index].productQuantity,
                                priceType: state.products[index].priceType,
                              );
                            }),
                      ),
                    ],
                  );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  // bodycontent() {
  //   return ListView(
  //     physics: BouncingScrollPhysics(),
  //     children: [
  //       Text(nameForSubCategoryEnum[widget.subCategoryEnum]!,
  //           style: TextStyle(
  //               fontSize: 20,
  //               fontWeight: FontWeight.w600,
  //               color: MyTheme.font_grey)),
  //       Column(),
  //       Container(
  //         child: ListView.builder(
  //             itemCount: 3,
  //             shrinkWrap: true,
  //             physics: NeverScrollableScrollPhysics(),
  //             scrollDirection: Axis.vertical,
  //             itemBuilder: (context, index) {
  //               var productName = 'Fresh Green Grapes';
  //               var productSubSubCategory = "Grapes Black";
  //               return ProductInventoryWidget(
  //                   productName: productName,
  //                   productSubSubCategory: productSubSubCategory);
  //             }),
  //       ),
  //     ],
  //   );
  // }
}

class ProductInventoryWidget extends StatelessWidget {
  ProductInventoryWidget({
    super.key,
    required this.productName,
    required this.productSubSubCategory,
    required this.productPrice,
    required this.productPriceType,
    required this.imageURL,
    required this.productQuantity,
    required this.priceType,
    // required this.
  });

  final String productName;
  final String productSubSubCategory;
  final double productPrice;
  final String productPriceType;
  final String imageURL;
  final int productQuantity;
  final String priceType;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20, top: 10),
      child: Material(
        elevation: 1,
        borderRadius: BorderRadius.circular(15),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(width: 1, color: MyTheme.medium_grey)),
          height: 140,
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Column(
              children: [
                // product name
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Text(productName,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        )),
                  ),
                ),

                // product details
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // product image
                      Expanded(
                        flex: 1,
                        child: Container(
                            padding: EdgeInsets.all(7),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                imageURL,
                                fit: BoxFit.cover,
                              ),
                            )),
                      ),
                      Expanded(
                        flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: Row(
                            // crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      productSubSubCategory,
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Text(
                                      "Stock: $productQuantity ${priceType == 'Per kg' ? 'kg' : 'units'}",
                                      maxLines: 2,
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          color: MyTheme.dark_grey,
                                          height: 1.2),
                                    ),
                                    Text(
                                      "₹ $productPrice/${priceType == 'Per kg' ? 'kg' : 'unit'}",
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          color: MyTheme.dark_grey,
                                          height: 1.2),
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                // mainAxisAlignment:
                                //     MainAxisAlignment.spaceAround,
                                children: [
                                  Expanded(
                                    child: IconButton(
                                      splashRadius: 20,
                                      onPressed: () {
                                        print('tapped');
                                      },
                                      icon: Image.asset(
                                        "assets/edit1.png",
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: IconButton(
                                      splashRadius: 20,
                                      onPressed: () {
                                        print('tapped');
                                      },
                                      icon: Image.asset(
                                        "assets/delet1.png",
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
