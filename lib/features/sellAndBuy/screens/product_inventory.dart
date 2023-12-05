// translation done

import 'package:active_ecommerce_flutter/custom/toast_component.dart';
import 'package:active_ecommerce_flutter/features/sellAndBuy/models/sell_product.dart';
import 'package:active_ecommerce_flutter/features/sellAndBuy/services/sell_bloc/sell_bloc.dart';
import 'package:active_ecommerce_flutter/features/sellAndBuy/services/sell_bloc/sell_event.dart';
import 'package:active_ecommerce_flutter/features/sellAndBuy/services/sell_bloc/sell_state.dart';
import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:active_ecommerce_flutter/features/sellAndBuy/screens/product_post.dart';
import 'package:active_ecommerce_flutter/utils/enums.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:toast/toast.dart';

class ProductInventory extends StatefulWidget {
  final SubCategoryEnum subCategoryEnum;
  final bool isSecondHand;
  const ProductInventory({
    Key? key,
    required this.subCategoryEnum,
    required this.isSecondHand,
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
    BlocProvider.of<SellBloc>(context).add(ProductsForSubCategoryRequested(
      subCategory: nameForSubCategoryEnum[widget.subCategoryEnum]!,
      isSecondHand: widget.isSecondHand,
    ));
    super.initState();
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
                              isSecondHand: widget.isSecondHand,
                            )));
              },
              child: Image.asset("assets/add 2.png"),
            )
          : SizedBox.shrink(),
    );
  }

  late List<String> productNames;
  bool floatingActionButtomEnabled = false;

  bodycontent() {
    return BlocListener<SellBloc, SellState>(
      listener: (context, state) {
        if (state is ProductsForSubCategoryReceived) {
          productNames = [];
          if (state.products.isNotEmpty) {
            setState(() {
              floatingActionButtomEnabled = true;
            });
          }
          for (var product in state.products) {
            productNames.add(product.productName);
          }
        }
        if (state is ProductAddEditDeleteSuccessfully) {
          ToastComponent.showDialog(AppLocalizations.of(context)!.stock_updated,
              gravity: Toast.center, duration: Toast.lengthLong);
          BlocProvider.of<SellBloc>(context)
              .add(ProductsForSubCategoryRequested(
            subCategory: nameForSubCategoryEnum[widget.subCategoryEnum]!,
            isSecondHand: widget.isSecondHand,
          ));
        }
      },
      child: BlocBuilder<SellBloc, SellState>(
        builder: (context, state) {
          if (state is ProductsForSubCategoryReceived) {
            return state.products.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.no_product_found,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: MyTheme.accent_color,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            AppLocalizations.of(context)!.add_product,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              letterSpacing: .5,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ProductPost(
                                          subCategoryEnum:
                                              widget.subCategoryEnum,
                                          alreadyExistingProductNames: [],
                                          isSecondHand: widget.isSecondHand,
                                        )));
                          },
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemCount: state.products.length,
                    itemBuilder: (context, index) {
                      var productName = state.products[index].productName;
                      var productSubSubCategory =
                          state.products[index].subSubCategory;
                      return ProductInventoryWidget(
                        productId: state.products[index].id,
                        productName: productName,
                        productSubSubCategory: productSubSubCategory,
                        productPrice: state.products[index].productPrice,
                        imageURL: state.products[index].imageURL,
                        productQuantity: state.products[index].productQuantity,
                        quantityUnit: state.products[index].quantityUnit,
                        // priceType: state.products[index].priceType,
                        subCategoryEnum: widget.subCategoryEnum,
                        sellerId: state.products[index].sellerId,
                        productDescription:
                            state.products[index].productDescription,
                        isSecondHand: state.products[index].isSecondHand,
                      );
                    },
                  );
          }
          if (state is ProductLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is ProductAddEditDeleteLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}

class ProductInventoryWidget extends StatelessWidget {
  ProductInventoryWidget({
    super.key,
    required this.productId,
    required this.productName,
    required this.productSubSubCategory,
    required this.productPrice,
    required this.imageURL,
    required this.productQuantity,
    required this.quantityUnit,
    // required this.priceType,
    required this.subCategoryEnum,
    required this.sellerId,
    required this.productDescription,
    required this.isSecondHand,
    // required this.
  });

  final String productId;
  final String productName;
  final String productSubSubCategory;
  final double productPrice;
  final List<dynamic> imageURL;
  final int productQuantity;
  final String quantityUnit;
  final String sellerId;
  final String productDescription;
  // final String priceType;
  final SubCategoryEnum subCategoryEnum;
  final bool isSecondHand;

  void onPressedDelete(BuildContext context, String productId) {
    BlocProvider.of<SellBloc>(context).add(DeleteProductRequested(
      productId: productId,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20, top: 10),
      child: Material(
        elevation: 0.5,
        borderRadius: BorderRadius.circular(5),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(
                  width: 1, color: MyTheme.medium_grey.withOpacity(0.5))),
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
                          fontSize: 19,
                          fontWeight: FontWeight.w600,
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
                              borderRadius: BorderRadius.circular(5),
                              child: CachedNetworkImage(
                                imageUrl: imageURL[0],
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
                                          fontWeight: FontWeight.w500),
                                    ),
                                    Text(
                                      "Stock: $productQuantity x $quantityUnit",
                                      maxLines: 2,
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          color: MyTheme.dark_grey,
                                          height: 1.2),
                                    ),
                                    Text(
                                      "₹ $productPrice per ${quantityUnit == "Units" ? 'unit' : quantityUnit}",
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
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ProductPost(
                                                      subCategoryEnum:
                                                          subCategoryEnum,
                                                      alreadyExistingProductNames: [],
                                                      isProductEditScreen: true,
                                                      isSecondHand:
                                                          isSecondHand,
                                                      sellProduct: SellProduct(
                                                        id: productId,
                                                        productName:
                                                            productName,
                                                        productDescription:
                                                            productDescription,
                                                        productPrice:
                                                            productPrice,
                                                        productQuantity:
                                                            productQuantity,
                                                        quantityUnit:
                                                            quantityUnit,
                                                        category: "",
                                                        subCategory: "",
                                                        subSubCategory:
                                                            productSubSubCategory,
                                                        imageURL: imageURL,
                                                        sellerId: sellerId,
                                                        isSecondHand:
                                                            isSecondHand,
                                                      ),
                                                    )));
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
                                        showAdaptiveDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                title: Text(
                                                  AppLocalizations.of(context)!
                                                      .delete_product,
                                                  style: TextStyle(
                                                    color:
                                                        MyTheme.primary_color,
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.w800,
                                                  ),
                                                ),
                                                content: Text(
                                                    '${AppLocalizations.of(context)!.are_you_sure_to_delete} $productName'),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: Text(
                                                      AppLocalizations.of(
                                                              context)!
                                                          .cancel,
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 15,
                                                      ),
                                                    ),
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      onPressedDelete(
                                                          context, productId);
                                                      Navigator.pop(context);
                                                    },
                                                    child: Text(
                                                      AppLocalizations.of(
                                                              context)!
                                                          .cancel,
                                                      style: TextStyle(
                                                        color: Colors.red,
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              );
                                            });
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
